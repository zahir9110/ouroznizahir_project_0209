import { Timestamp, GeoPoint } from 'firebase-admin/firestore';

// ============================================================================
// COLLECTION: verification_requests
// ============================================================================

export interface VerificationRequest {
  id: string;
  userId: string;                    // Référence auth
  
  // Métadonnées temporelles
  createdAt: Timestamp;
  updatedAt: Timestamp;
  expiresAt?: Timestamp;             // Pour relances automatiques
  
  // Statut workflow
  status: VerificationStatus;
  
  // Progression utilisateur
  completionPercentage: number;      // Pour reprendre plus tard
  
  // Étape 1: Identité
  identity: IdentityInfo;
  
  // Étape 2: Entité légale
  legal: LegalInfo;
  
  // Étape 3: Localisation & Culture
  location: LocationInfo;
  
  // Étape 4: Preuves visuelles
  media: MediaInfo;
  
  // Étape 5: Offre & Contexte
  offer: OfferInfo;
  
  // Résultats IA
  aiAnalysis?: AIAnalysisResult;
  
  // Review manuelle (si nécessaire)
  manualReview?: ManualReview;
  
  // Appel API externe (prévention fraude)
  fraudCheck?: FraudCheck;
  
  // Audit complet
  auditLog: AuditLogEntry[];
}

// ============================================================================
// SOUS-TYPES
// ============================================================================

export type VerificationStatus = 
  | 'draft' 
  | 'submitted' 
  | 'ai_processing' 
  | 'human_review' 
  | 'approved' 
  | 'rejected' 
  | 'appealed';

export interface IdentityInfo {
  fullName: string;
  birthDate: Timestamp;
  nationality: string;
  idDocumentType: IdDocumentType;
  idDocumentUrl: string;           // Storage path
  idDocumentVerified: boolean;
  selfieUrl?: string;              // Liveness check optionnel
}

export type IdDocumentType = 
  | 'passport' 
  | 'national_id' 
  | 'driver_license' 
  | 'residence_permit';

export interface LegalInfo {
  businessType: BusinessType;
  businessName: string;
  registrationNumber: string;      // RCCM au Bénin
  taxId?: string;
  legalDocumentUrl: string;
  bankAccount?: BankAccountInfo;
}

export type BusinessType = 
  | 'individual' 
  | 'llc' 
  | 'corporation' 
  | 'cooperative' 
  | 'ngo';

export interface BankAccountInfo {
  bankName: string;
  accountNumber: string;           // Encrypté
  verified: boolean;
}

export interface LocationInfo {
  coordinates: GeoPoint;           // Vérifié vs déclaré
  address: string;
  commune: string;                 // Cotonou, Abomey...
  department: string;              // Atlantique, Zou...
  region: string;
  
  // Spécifique Bénin
  traditionalAuthority?: string;   // Chef de village, roi...
  culturalAffiliation?: string[];  // Fon, Yoruba, Bariba...
  proximityToLandmarks?: string[]; // Auto-détecté via IA
}

export interface MediaInfo {
  exteriorPhotos: string[];        // Min 2, max 5
  interiorPhotos?: string[];       // Si applicable
  activityPhotos?: string[];       // Pour expériences
  videoTour?: string;              // Optionnel mais boost score
  logo?: string;
}

export interface OfferInfo {
  category: BusinessCategory;
  subcategories: string[];         // Ex: ["vaudou", "cuisine_traditionnelle"]
  description: string;             // Analysé par IA
  languages: string[];             // FR, EN, FON...
  capacity?: number;
  priceRange: PriceRange;
}

export type BusinessCategory = 
  | 'hotel' 
  | 'restaurant' 
  | 'event_organizer' 
  | 'tour_guide' 
  | 'cultural_site' 
  | 'transport' 
  | 'artisan';

export type PriceRange = 'budget' | 'mid' | 'luxury';

// ============================================================================
// RÉSULTATS IA
// ============================================================================

export interface AIAnalysisResult {
  processedAt: Timestamp;
  culturalScore: number;           // 0-1
  authenticityScore: number;
  locationScore: number;
  documentScore: number;
  overallScore: number;
  confidence: 'high' | 'medium' | 'low';
  flags: string[];                 // Alertes pour reviewer humain
  suggestedBadges: string[];       // Ex: ["verified_cultural_site"]
  extractedEntities: ExtractedEntities;
  estimatedStoryDuration: 24 | 48 | 72; // Heures
  recommendations?: string[];      // Suggestions d'amélioration
}

export interface ExtractedEntities {
  landmarks: string[];
  ethnicGroups: string[];
  festivals: string[];
  culturalPractices: string[];
  languages: string[];
}

// ============================================================================
// REVIEW MANUELLE
// ============================================================================

export interface ManualReview {
  reviewerId: string;
  startedAt: Timestamp;
  completedAt?: Timestamp;
  notes: string;
  decision: ManualDecision;
  requestedChanges?: string[];
}

export type ManualDecision = 'approve' | 'reject' | 'request_info';

// ============================================================================
// FRAUD CHECK
// ============================================================================

export interface FraudCheck {
  checkedAt: Timestamp;
  riskScore: number;
  blacklistsChecked: string[];
  clear: boolean;
  warnings?: string[];
}

// ============================================================================
// AUDIT LOG
// ============================================================================

export interface AuditLogEntry {
  action: AuditAction;
  actor: string;                   // userId ou 'system'
  timestamp: Timestamp;
  details: Record<string, any>;
}

export type AuditAction = 
  | 'created'
  | 'updated'
  | 'submitted'
  | 'ai_analysis_started'
  | 'ai_analysis_completed'
  | 'manual_review_started'
  | 'manual_review_completed'
  | 'approved'
  | 'rejected'
  | 'document_uploaded'
  | 'status_changed';

// ============================================================================
// DONNÉES CULTURELLES BÉNIN (Référentiel)
// ============================================================================

export interface CulturalContext {
  ethnicGroups: string[];
  landmarks: string[];
  festivals: string[];
  cuisine: string[];
  crafts: string[];
  languages: string[];
}

export const BENIN_CULTURAL_KNOWLEDGE: Record<string, CulturalContext> = {
  'Atlantique': {
    ethnicGroups: ['Fon', 'Aja', 'Xwla', 'Hwedanou'],
    landmarks: [
      'Porte du Non-Retour',
      'Temple des Pythons',
      'Forêt Sacrée de Kpassè',
      'Place des Enchères',
      'Musée d\'Histoire de Ouidah'
    ],
    festivals: ['Festival Vodoun', 'Fête de la Guani', 'Gelede'],
    cuisine: ['Amiwo', 'Koki', 'Choukouya', 'Akassa', 'Sauce graine'],
    crafts: ['Appliqués de Ouidah', 'Vannerie', 'Poterie'],
    languages: ['Fon', 'Aja', 'Français']
  },
  
  'Littoral': {
    ethnicGroups: ['Fon'],
    landmarks: [
      'Marché Dantokpa',
      'Cathédrale de Cotonou',
      'Plage de Fidjrossè',
      'Pont de Cotonou',
      'Jardin des Plantes'
    ],
    festivals: ['Foire Internationale de Cotonou'],
    cuisine: ['Garba', 'Chouk', 'Pâte rouge', 'Kpaklo'],
    crafts: ['Art urbain', 'Mode africaine'],
    languages: ['Fon', 'Français', 'Yoruba']
  },
  
  'Zou': {
    ethnicGroups: ['Fon'],
    landmarks: [
      'Palais Royaux d\'Abomey',
      'Musée Historique d\'Abomey',
      'Temples Akaba',
      'Fosse aux Lions'
    ],
    festivals: ['Fête des Rois', 'Festivités royales', 'Gelede'],
    cuisine: ['Choukouya de poulet', 'Ablo', 'Aklui', 'Migan'],
    crafts: ['Tissus Fondhomme', 'Sculptures sur bois'],
    languages: ['Fon', 'Français']
  },
  
  'Ouémé': {
    ethnicGroups: ['Fon', 'Yoruba', 'Goun'],
    landmarks: [
      'Porto-Novo',
      'Musée da Silva',
      'Palais Royal de Porto-Novo',
      'Mosquée centrale'
    ],
    festivals: ['Egungun', 'Gelede', 'Zangbeto'],
    cuisine: ['Wassi-wassi', 'Moyo', 'Djenkoume', 'Amiwo'],
    crafts: ['Mosaïques', 'Peinture sur verre'],
    languages: ['Fon', 'Yoruba', 'Goun', 'Français']
  },
  
  'Borgou': {
    ethnicGroups: ['Bariba', 'Dendi', 'Fulani', 'Boko'],
    landmarks: [
      'Parc National de la Pendjari',
      'Palais Royal de Nikki',
      'Parc National de la W',
      'Cascades de Tanougou'
    ],
    festivals: ['Gaani', 'Djwabwo', 'Gani'],
    cuisine: ['Dekounoun', 'Choukouya', 'Wô', 'Babatou'],
    crafts: ['Cuir', 'Forge', 'Tissage'],
    languages: ['Bariba', 'Dendi', 'Fulfulde', 'Français']
  },
  
  'Mono': {
    ethnicGroups: ['Aja', 'Ewe', 'Gen'],
    landmarks: [
      'Lac Ahémé',
      'Grand-Popo',
      'Bouche du Roy',
      'Plage de Grand-Popo'
    ],
    festivals: ['Festival Vodoun', 'Fête du Meyi'],
    cuisine: ['Aklui', 'Ablo', 'Koklo', 'Adémè'],
    crafts: ['Pêche traditionnelle', 'Vannerie'],
    languages: ['Aja', 'Ewe', 'Gen', 'Français']
  },
  
  'Collines': {
    ethnicGroups: ['Yoruba', 'Mahi', 'Idaasha'],
    landmarks: [
      'Savè',
      'Dassa-Zoumè',
      'Monts Sokbaro',
      'Chutes de Kota'
    ],
    festivals: ['Fêtes des rois', 'New Yam Festival'],
    cuisine: ['Igname pilée', 'Sauce d\'arachide', 'Fufu'],
    crafts: ['Bois sculpté', 'Poterie'],
    languages: ['Yoruba', 'Mahi', 'Français']
  },
  
  'Couffo': {
    ethnicGroups: ['Aja', 'Fon'],
    landmarks: [
      'Aplahoué',
      'Lac Ahémé (partie nord)',
      'Forêts sacrées'
    ],
    festivals: ['Vodoun Festival'],
    cuisine: ['Aklui', 'Sauce feuille'],
    crafts: ['Agriculture traditionnelle'],
    languages: ['Aja', 'Fon', 'Français']
  },
  
  'Donga': {
    ethnicGroups: ['Yom', 'Lokpa', 'Fulani'],
    landmarks: [
      'Djougou',
      'Marché de Djougou',
      'Monts Mango'
    ],
    festivals: ['Fêtes traditionnelles Yom'],
    cuisine: ['Cuisine du nord', 'Mil', 'Sorgho'],
    crafts: ['Tissage de coton'],
    languages: ['Yom', 'Lokpa', 'Français']
  },
  
  'Alibori': {
    ethnicGroups: ['Dendi', 'M\'Berma', 'Fulani'],
    landmarks: [
      'Kandi',
      'Parc National de la W (partie nord)',
      'Ferme de Gaya'
    ],
    festivals: ['Tabaski', 'Fêtes de récolte'],
    cuisine: ['Riz au gras', 'Sauce arachide'],
    crafts: ['Agriculture', 'Élevage'],
    languages: ['Dendi', 'Fulfulde', 'Français']
  },
  
  'Atacora': {
    ethnicGroups: ['Berba', 'Gurma', 'Fulani'],
    landmarks: [
      'Natitingou',
      'Les Tata Somba',
      'Parc National de la Pendjari',
      'Chutes de Tanougou'
    ],
    festivals: ['Evala (concours de lutte)'],
    cuisine: ['Sorgho', 'Igname', 'Cuisine des montagnes'],
    crafts: ['Architecture Tata', 'Poterie'],
    languages: ['Berba', 'Gurma', 'Français']
  },
  
  'Plateau': {
    ethnicGroups: ['Yoruba', 'Tori'],
    landmarks: [
      'Pobè',
      'Kétou',
      'Forêts de la Lama'
    ],
    festivals: ['Gelede'],
    cuisine: ['Igname', 'Manioc'],
    crafts: ['Sculpture'],
    languages: ['Yoruba', 'Français']
  }
};

// Helper pour obtenir le contexte culturel
export function getCulturalContext(department: string): CulturalContext {
  return BENIN_CULTURAL_KNOWLEDGE[department] || {
    ethnicGroups: ['Divers'],
    landmarks: [],
    festivals: [],
    cuisine: [],
    crafts: [],
    languages: ['Français']
  };
}
