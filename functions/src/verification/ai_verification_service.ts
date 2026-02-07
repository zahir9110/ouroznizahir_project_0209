// functions/src/verification/ai_verification_service.ts

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { OpenAI } from 'openai';
import { getStorage } from 'firebase-admin/storage';

const db = admin.firestore();

// Configuration avec fallback
const getOpenAI = () => {
  const apiKey = functions.config().openai?.key || process.env.OPENAI_API_KEY;
  if (!apiKey) throw new Error('OpenAI API key not configured');
  return new OpenAI({ apiKey });
};

// Interface complète
interface VerificationData {
  userId: string;
  businessName: string;
  description: string;
  location: {
    commune: string;
    department: string;
    coordinates: admin.firestore.GeoPoint;
  };
  media: {
    exteriorPhotos: string[];
    videoTour?: string;
  };
  offer: {
    category: string;
    languages: string[];
  };
  createdAt: admin.firestore.Timestamp;
}

interface CulturalContext {
  ethnicGroups: string[];
  landmarks: string[];
  festivals: string[];
  cuisine: string[];
}

// Base de connaissances culturelle du Bénin
const BENIN_CULTURAL_KNOWLEDGE: Record<string, CulturalContext> = {
  'Atlantique': {
    ethnicGroups: ['Fon', 'Aja', 'Xwla', 'Hwedanou'],
    landmarks: ['Porte du Non-Retour', 'Temple des Pythons', 'Sacred Forest', 'Place des Enchères'],
    festivals: ['Festival Vodoun', 'Fête de la Guani', 'Gelede'],
    cuisine: ['Amiwo', 'Koki', 'Choukouya', 'Akassa']
  },
  'Littoral': {
    ethnicGroups: ['Fon'],
    landmarks: ['Marché Dantokpa', 'Cotonou Cathedral', 'Fidjrossè Beach'],
    festivals: ['Foire Internationale de Cotonou'],
    cuisine: ['Garba', 'Chouk', 'Pâte rouge']
  },
  'Zou': {
    ethnicGroups: ['Fon'],
    landmarks: ['Palais Royaux d\'Abomey', 'Musée Historique', 'Temples Akaba'],
    festivals: ['Fête des Rois', 'Festivités royales'],
    cuisine: ['Choukouya de poulet', 'Ablo', 'Aklui']
  },
  'Ouémé': {
    ethnicGroups: ['Fon', 'Yoruba'],
    landmarks: ['Porto-Novo', 'Musée da Silva', 'Palais Royal'],
    festivals: ['Egungun', 'Gelede'],
    cuisine: ['Wassi-wassi', 'Moyo', 'Djenkoume']
  },
  'Borgou': {
    ethnicGroups: ['Bariba', 'Dendi', 'Fulani'],
    landmarks: ['Parc National de la Pendjari', 'Royal Palaces of Nikki'],
    festivals: ['Gaani', 'Djwabwo'],
    cuisine: ['Dekounoun', 'Choukouya', 'Wô']
  },
  'Mono': {
    ethnicGroups: ['Aja', 'Ewe', 'Gen'],
    landmarks: ['Lac Ahémé', 'Grand-Popo'],
    festivals: ['Vodoun Festival'],
    cuisine: ['Aklui', 'Ablo', 'Koklo']
  },
  'Collines': {
    ethnicGroups: ['Yoruba', 'Mahi'],
    landmarks: ['Savè', 'Dassa-Zoumè'],
    festivals: ['Fêtes des rois'],
    cuisine: ['Igname pilée', 'Sauce d\'arachide']
  }
};

// Fonction principale
export const processVerificationRequest = functions.firestore
  .document('verification_requests/{requestId}')
  .onCreate(async (snap, context) => {
    const requestId = context.params.requestId;
    const data = snap.data() as VerificationData;
    
    console.log(`🔍 [${requestId}] Analyse démarrée pour: ${data.businessName}`);

    try {
      // 1. Vérifier si assez de médias
      if (!data.media?.exteriorPhotos || data.media.exteriorPhotos.length < 2) {
        await snap.ref.update({
          status: 'additional_info_required',
          aiAnalysis: {
            reason: 'insufficient_media',
            message: 'Au moins 2 photos extérieures requises',
            processedAt: admin.firestore.FieldValue.serverTimestamp()
          }
        });
        return;
      }

      // 2. Analyse IA parallélisée
      const [culturalAnalysis, mediaQuality] = await Promise.all([
        analyzeCulturalAuthenticity(data),
        analyzeMediaQuality(data.media)
      ]);

      // 3. Calcul score pondéré
      const overallScore = calculateOverallScore({
        cultural: culturalAnalysis.score,
        media: mediaQuality.score,
        completeness: calculateCompleteness(data)
      });

      // 4. Déterminer statut et durée stories
      const result = {
        status: overallScore >= 0.75 ? 'approved' : 
                overallScore >= 0.5 ? 'human_review' : 'additional_info_required',
        aiAnalysis: {
          processedAt: admin.firestore.FieldValue.serverTimestamp(),
          culturalRelevance: culturalAnalysis,
          mediaQuality: mediaQuality,
          overallScore: overallScore,
          confidence: overallScore > 0.8 ? 'high' : overallScore > 0.6 ? 'medium' : 'low',
          recommendedStoryDuration: determineStoryDuration(data.offer.category, overallScore),
          suggestedBadges: generateBadges(data, culturalAnalysis),
          flags: culturalAnalysis.flags,
          extractedEntities: culturalAnalysis.entities
        }
      };

      await snap.ref.update(result);

      // 5. Actions post-analyse
      if (result.status === 'approved') {
        await handleAutoApproval(snap.ref, data, result.aiAnalysis);
      }

      console.log(`✅ [${requestId}] Score: ${overallScore.toFixed(2)} | Status: ${result.status}`);

    } catch (error) {
      console.error(`❌ [${requestId}] Erreur:`, error);
      await snap.ref.update({
        status: 'error',
        error: {
          message: error instanceof Error ? error.message : 'Unknown error',
          timestamp: admin.firestore.FieldValue.serverTimestamp()
        }
      });
    }
  });

// Analyse culturelle avec GPT-4
async function analyzeCulturalAuthenticity(data: VerificationData) {
  const context = BENIN_CULTURAL_KNOWLEDGE[data.location.department] || {
    ethnicGroups: ['Divers'],
    landmarks: [],
    festivals: [],
    cuisine: []
  };

  const openai = getOpenAI();

  const prompt = `Tu es un expert en patrimoine culturel béninois. Analyse cette offre touristique.

CONTEXTE RÉGION: ${data.location.department}
- Groupes ethniques: ${context.ethnicGroups.join(', ')}
- Sites emblématiques: ${context.landmarks.join(', ')}
- Festivals: ${context.festivals.join(', ')}
- Gastronomie: ${context.cuisine.join(', ')}

OFFRE À ANALYSER:
Nom: ${data.businessName}
Type: ${data.offer.category}
Description: ${data.description}
Langues: ${data.offer.languages.join(', ')}

Évalue et retourne UNIQUEMENT ce JSON:
{
  "score": 0.0-1.0,
  "authenticity": 0.0-1.0,
  "tourismValue": 0.0-1.0,
  "justification": "analyse détaillée",
  "flags": ["alerte1", "alerte2"],
  "entities": {
    "mentionedLandmarks": [],
    "ethnicGroups": [],
    "culturalPractices": [],
    "languages": []
  },
  "recommendations": ["suggestion1"]
}

Critères:
- Mentionne-t-il des éléments culturels authentiques?
- Est-ce générique ("belle plage") ou spécifique ("plage de Fidjrossè, spot de surf")?
- Y a-t-il des risques d'appropriation culturelle?
- Le lien avec le territoire est-il crédible?`;

  try {
    const response = await openai.chat.completions.create({
      model: "gpt-4-turbo-preview",
      messages: [
        { 
          role: "system", 
          content: "Expert patrimoine UNESCO Bénin. Réponds uniquement en JSON valide." 
        },
        { role: "user", content: prompt }
      ],
      response_format: { type: "json_object" },
      temperature: 0.3,
      max_tokens: 1000
    });

    const content = response.choices[0].message.content;
    if (!content) throw new Error('Empty OpenAI response');

    const analysis = JSON.parse(content);
    
    return {
      score: Math.min(Math.max(analysis.score || 0.5, 0), 1),
      authenticity: analysis.authenticity || 0.5,
      tourismValue: analysis.tourismValue || 0.5,
      justification: analysis.justification || 'Analyse complétée',
      flags: analysis.flags || [],
      entities: analysis.entities || {
        mentionedLandmarks: [],
        ethnicGroups: [],
        culturalPractices: [],
        languages: []
      },
      recommendations: analysis.recommendations || []
    };

  } catch (error) {
    console.error('OpenAI analysis failed:', error);
    // Fallback sécurisé
    return {
      score: 0.5,
      authenticity: 0.5,
      tourismValue: 0.5,
      justification: 'Analyse IA indisponible - revue manuelle requise',
      flags: ['ai_analysis_failed'],
      entities: { mentionedLandmarks: [], ethnicGroups: [], culturalPractices: [], languages: [] },
      recommendations: ['vérification manuelle recommandée']
    };
  }
}

// Analyse qualité médias (simulation - peut utiliser Vision API)
async function analyzeMediaQuality(media: any) {
  const photoCount = media.exteriorPhotos?.length || 0;
  const hasVideo = !!media.videoTour;
  
  let score = 0.3; // Base
  
  if (photoCount >= 2) score += 0.2;
  if (photoCount >= 4) score += 0.2;
  if (hasVideo) score += 0.3;
  
  return {
    score: Math.min(score, 1.0),
    photoCount,
    hasVideo,
    diversity: photoCount > 3 ? 'good' : photoCount > 1 ? 'adequate' : 'poor'
  };
}

// Calcul complétude formulaire
function calculateCompleteness(data: VerificationData): number {
  let score = 0;
  if (data.businessName?.length > 3) score += 0.2;
  if (data.description?.length > 50) score += 0.2;
  if (data.location?.commune) score += 0.2;
  if (data.media?.exteriorPhotos?.length >= 2) score += 0.2;
  if (data.offer?.languages?.length > 0) score += 0.2;
  return score;
}

// Score global pondéré
function calculateOverallScore(scores: {
  cultural: number;
  media: number;
  completeness: number;
}) {
  return (scores.cultural * 0.5) + (scores.media * 0.3) + (scores.completeness * 0.2);
}

// Détermination durée stories
function determineStoryDuration(
  category: string, 
  score: number
): 24 | 48 | 72 {
  if (score >= 0.85) return 72;
  if (category === 'cultural_site' || category === 'event_organizer') return 72;
  if (score >= 0.7) return 48;
  return 24;
}

// Génération badges suggérés
function generateBadges(data: VerificationData, analysis: any): string[] {
  const badges: string[] = [];
  
  if (analysis.score >= 0.8) badges.push('cultural_heritage');
  if (analysis.entities?.languages?.includes('en')) badges.push('english_friendly');
  if (analysis.entities?.languages?.includes('fon')) badges.push('local_language');
  if (data.offer.category === 'cultural_site') badges.push('authentic_experience');
  if (analysis.authenticity >= 0.8) badges.push('community_verified');
  
  return badges;
}

// Gestion auto-approval
async function handleAutoApproval(
  ref: admin.firestore.DocumentReference,
  data: VerificationData,
  analysis: any
) {
  // Créer le profil professionnel
  await db.collection('professional_profiles').doc(data.userId).set({
    userId: data.userId,
    businessName: data.businessName,
    status: 'active',
    verificationStatus: 'verified',
    badges: analysis.suggestedBadges,
    storyDurationHours: analysis.recommendedStoryDuration,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    aiAnalysis: analysis
  });

  // Envoyer notification
  await db.collection('notifications').add({
    userId: data.userId,
    type: 'verification_approved',
    title: 'Compte vérifié !',
    body: `Félicitations, ${data.businessName} est maintenant un partenaire vérifié.`,
    data: {
      storyDuration: analysis.recommendedStoryDuration,
      badges: analysis.suggestedBadges
    },
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    read: false
  });
}