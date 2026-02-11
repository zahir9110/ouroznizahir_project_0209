# 🤖 ARCHITECTURE IA COMPLÈTE - BENIN EXPERIENCE

## Vue d'ensemble

Système IA scalable intégrant **OpenAI** (enrichissement + embeddings) et **Pinecone** (similarité vectorielle) pour alimenter un feed social hybride intelligent.

---

## 📊 Flux de données complet

```
┌─────────────────────────────────────────────────────────────────────┐
│                        SOURCES EXTERNES                              │
│  AllEvents API • Eventbrite • Instagram • Scrapers locaux           │
└──────────────────────────────┬──────────────────────────────────────┘
                               ↓
┌──────────────────────────────────────────────────────────────────────┐
│  🔄 INGESTION (Cloud Function - Scheduled 6h)                        │
│  ├─ fetchEvents.ts          → Récupération multi-sources             │
│  ├─ normalize.ts            → Standardisation format                 │
│  └─ deduplication.ts        → Détection doublons                     │
└──────────────────────────────┬───────────────────────────────────────┘
                               ↓
                    Firestore: raw_events/
                    (Événements bruts non enrichis)
                               ↓
┌──────────────────────────────────────────────────────────────────────┐
│  🧠 ENRICHISSEMENT IA (Cloud Function - Firestore Trigger)           │
│  ├─ enrichEvent.ts          → GPT-4 réécriture + catégorisation     │
│  ├─ generateEmbedding.ts    → text-embedding-3-small (1536 dim)     │
│  ├─ extractTags.ts          → NER + extraction entités              │
│  └─ moderateContent.ts      → Vérification sécurité (opt)           │
└──────────────────────────────┬───────────────────────────────────────┘
                               ↓
                    Firestore: events/ (clean)
                               ↓
┌──────────────────────────────────────────────────────────────────────┐
│  📊 VECTORISATION (Cloud Function - Firestore Trigger)               │
│  ├─ upsertVector.ts         → Upload vers Pinecone                   │
│  └─ Namespace: events                                                │
└──────────────────────────────┬───────────────────────────────────────┘
                               ↓
                    Pinecone: benin-experience-feed
                    (Vecteurs + métadonnées)
                               ↓
┌──────────────────────────────────────────────────────────────────────┐
│  🎯 RECOMMANDATION (HTTPS Callable - Client Flutter)                 │
│  ├─ queryVector.ts          → Similarité vectorielle                │
│  ├─ geoFilter.ts            → Filtrage géographique                 │
│  ├─ hybridScore.ts          → Combinaison ML + règles métier        │
│  └─ buildFeed.ts            → Assembly final (events+stories+tickets)│
└──────────────────────────────┬───────────────────────────────────────┘
                               ↓
                         Client Flutter
                               ↓
┌──────────────────────────────────────────────────────────────────────┐
│  🔔 NOTIFICATIONS (Cloud Function - Scheduled + Event-driven)        │
│  ├─ smartNotify.ts          → GPT micro-copy personnalisé           │
│  ├─ targetAudience.ts       → Sélection utilisateurs ciblés         │
│  └─ fcmBatch.ts             → Envoi FCM batch (500/lot)             │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 📁 Arborescence Cloud Functions

```
functions/
├─ package.json
├─ tsconfig.json
├─ .env.example
├─ src/
│   ├─ index.ts                        # Point d'entrée, export fonctions
│   │
│   ├─ ingestion/
│   │   ├─ fetchEvents.ts              # Scheduled: récup événements externes
│   │   ├─ normalizeEvent.ts           # Helper: standardisation format
│   │   ├─ deduplicateEvents.ts        # Helper: détection doublons
│   │   └─ types.ts                    # Types source/événements
│   │
│   ├─ ai/
│   │   ├─ enrichEvent.ts              # Firestore Trigger: enrichissement GPT
│   │   ├─ generateEmbedding.ts        # Helper: création vecteurs OpenAI
│   │   ├─ extractEntities.ts          # Helper: NER avec GPT
│   │   ├─ moderateContent.ts          # Helper: modération (opt)
│   │   └─ prompts.ts                  # Prompts GPT centralisés
│   │
│   ├─ vector/
│   │   ├─ pineconeClient.ts           # Client Pinecone singleton
│   │   ├─ upsertVector.ts             # Firestore Trigger: sync Pinecone
│   │   ├─ queryVector.ts              # Helper: recherche similarité
│   │   ├─ deleteVector.ts             # Cleanup vecteurs expirés
│   │   └─ types.ts                    # Types Pinecone
│   │
│   ├─ feed/
│   │   ├─ buildFeed.ts                # HTTPS Callable: feed hybride
│   │   ├─ scoreHybrid.ts              # Helper: scoring final
│   │   ├─ filterGeo.ts                # Helper: filtrage géographique
│   │   ├─ interleave.ts               # Helper: mélange events/stories/tickets
│   │   └─ types.ts                    # Types feed/items
│   │
│   ├─ notifications/
│   │   ├─ smartNotify.ts              # Scheduled: notifications intelligentes
│   │   ├─ generateCopy.ts             # Helper: micro-copy GPT
│   │   ├─ targetAudience.ts           # Helper: sélection utilisateurs
│   │   ├─ sendFCMBatch.ts             # Helper: envoi batch FCM
│   │   └─ types.ts                    # Types notifications
│   │
│   ├─ shared/
│   │   ├─ openaiClient.ts             # Client OpenAI singleton
│   │   ├─ firebaseAdmin.ts            # Init Firebase Admin
│   │   ├─ cache.ts                    # Redis/Memcache helpers
│   │   ├─ rateLimiter.ts              # Rate limiting
│   │   ├─ retry.ts                    # Retry logic avec backoff
│   │   ├─ logger.ts                   # Structured logging
│   │   └─ constants.ts                # Constantes globales
│   │
│   └─ types/
│       ├─ event.ts                    # Types événements
│       ├─ user.ts                     # Types utilisateurs
│       └─ common.ts                   # Types communs
│
└─ lib/                                # Compiled JS (auto-généré)
```

---

## 🔧 Configuration initiale

### `package.json`

```json
{
  "name": "benin-experience-functions",
  "version": "1.0.0",
  "engines": {
    "node": "20"
  },
  "scripts": {
    "build": "tsc",
    "serve": "npm run build && firebase emulators:start --only functions",
    "deploy": "npm run build && firebase deploy --only functions",
    "logs": "firebase functions:log"
  },
  "dependencies": {
    "firebase-admin": "^12.0.0",
    "firebase-functions": "^4.7.0",
    "openai": "^4.28.0",
    "@pinecone-database/pinecone": "^2.0.1",
    "axios": "^1.6.7",
    "zod": "^3.22.4",
    "date-fns": "^3.3.1"
  },
  "devDependencies": {
    "@types/node": "^20.11.19",
    "typescript": "^5.3.3"
  }
}
```

### `tsconfig.json`

```json
{
  "compilerOptions": {
    "module": "commonjs",
    "target": "ES2020",
    "lib": ["ES2020"],
    "outDir": "lib",
    "rootDir": "src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "lib"]
}
```

### `.env.example`

```bash
# OpenAI
OPENAI_API_KEY=sk-proj-...
OPENAI_MODEL=gpt-4-turbo-preview
OPENAI_EMBEDDING_MODEL=text-embedding-3-small

# Pinecone
PINECONE_API_KEY=pcsk_...
PINECONE_ENVIRONMENT=us-east-1
PINECONE_INDEX_NAME=benin-experience-feed

# External APIs
ALLEVENTS_API_KEY=ae_...
EVENTBRITE_TOKEN=BEARER_...

# Config
MAX_BATCH_SIZE=100
EMBEDDING_DIMENSION=1536
```

---

## 📝 Implémentation détaillée

### 1. **Shared - Clients & Utils**

#### `src/shared/firebaseAdmin.ts`

```typescript
import * as admin from 'firebase-admin';

// Init Firebase Admin (singleton)
if (!admin.apps.length) {
  admin.initializeApp();
}

export const db = admin.firestore();
export const auth = admin.auth();
export const storage = admin.storage();
export const messaging = admin.messaging();

// Helpers
export const timestamp = admin.firestore.Timestamp;
export const fieldValue = admin.firestore.FieldValue;
```

#### `src/shared/openaiClient.ts`

```typescript
import OpenAI from 'openai';
import { logger } from './logger';

const OPENAI_API_KEY = process.env.OPENAI_API_KEY;

if (!OPENAI_API_KEY) {
  throw new Error('OPENAI_API_KEY not configured');
}

export const openai = new OpenAI({
  apiKey: OPENAI_API_KEY,
});

// Helper: génération embedding avec retry
export async function generateEmbedding(
  text: string,
  retries: number = 3
): Promise<number[]> {
  for (let i = 0; i < retries; i++) {
    try {
      const response = await openai.embeddings.create({
        model: 'text-embedding-3-small',
        input: text,
        encoding_format: 'float',
      });
      
      return response.data[0].embedding;
    } catch (error: any) {
      logger.warn(`Embedding attempt ${i + 1} failed:`, error.message);
      
      if (i === retries - 1) throw error;
      
      // Backoff exponentiel
      await new Promise(resolve => setTimeout(resolve, Math.pow(2, i) * 1000));
    }
  }
  
  throw new Error('Failed to generate embedding after retries');
}

// Helper: chat completion avec retry
export async function chatCompletion(
  messages: OpenAI.Chat.Completions.ChatCompletionMessageParam[],
  options?: {
    model?: string;
    temperature?: number;
    maxTokens?: number;
  }
): Promise<string> {
  const response = await openai.chat.completions.create({
    model: options?.model || 'gpt-4-turbo-preview',
    messages,
    temperature: options?.temperature || 0.7,
    max_tokens: options?.maxTokens || 1000,
  });
  
  return response.choices[0].message.content || '';
}
```

#### `src/shared/logger.ts`

```typescript
import * as functions from 'firebase-functions';

export const logger = functions.logger;

// Structured logging helpers
export function logInfo(message: string, data?: any) {
  logger.info(message, { timestamp: new Date().toISOString(), ...data });
}

export function logError(message: string, error: any, data?: any) {
  logger.error(message, {
    timestamp: new Date().toISOString(),
    error: error.message || error,
    stack: error.stack,
    ...data,
  });
}

export function logPerformance(
  operation: string,
  duration: number,
  metadata?: any
) {
  logger.info('Performance metric', {
    operation,
    durationMs: duration,
    ...metadata,
  });
}
```

#### `src/shared/retry.ts`

```typescript
export async function retryWithBackoff<T>(
  fn: () => Promise<T>,
  options: {
    maxRetries?: number;
    initialDelay?: number;
    maxDelay?: number;
    backoffMultiplier?: number;
  } = {}
): Promise<T> {
  const {
    maxRetries = 3,
    initialDelay = 1000,
    maxDelay = 30000,
    backoffMultiplier = 2,
  } = options;
  
  let lastError: any;
  
  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      return await fn();
    } catch (error) {
      lastError = error;
      
      if (attempt === maxRetries) {
        throw error;
      }
      
      const delay = Math.min(
        initialDelay * Math.pow(backoffMultiplier, attempt),
        maxDelay
      );
      
      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }
  
  throw lastError;
}
```

### 2. **Ingestion - Récupération événements**

#### `src/ingestion/types.ts`

```typescript
export interface RawEvent {
  sourceId: string;           // ID source externe
  source: 'allevents' | 'eventbrite' | 'manual' | 'scraper';
  title: string;
  description: string;
  
  dateStart: Date;
  dateEnd?: Date;
  
  location: {
    name?: string;
    address?: string;
    city?: string;
    region?: string;
    country: string;
    lat?: number;
    lng?: number;
  };
  
  organizer?: {
    name: string;
    email?: string;
    phone?: string;
  };
  
  images?: string[];
  categories?: string[];
  price?: {
    min?: number;
    max?: number;
    currency: string;
  };
  
  url?: string;
  fetchedAt: Date;
}

export interface NormalizedEvent {
  id: string;
  sourceId: string;
  source: string;
  
  title: string;
  description: string;
  
  schedule: {
    startDate: Date;
    endDate?: Date;
    timezone: string;
  };
  
  venue: {
    name: string;
    address: string;
    city: string;
    region: string;
    country: string;
    coordinates: {
      lat: number;
      lng: number;
    } | null;
  };
  
  media: {
    coverImage: string | null;
    gallery: string[];
  };
  
  priceRange: {
    min: number;
    max: number;
    currency: string;
  } | null;
  
  rawCategories: string[];
  
  status: 'pending_enrichment';
  createdAt: Date;
  updatedAt: Date;
}
```

#### `src/ingestion/fetchEvents.ts`

```typescript
import * as functions from 'firebase-functions';
import axios from 'axios';
import { db, timestamp } from '../shared/firebaseAdmin';
import { logInfo, logError } from '../shared/logger';
import { normalizeEvent } from './normalizeEvent';
import { detectDuplicate } from './deduplicateEvents';
import type { RawEvent } from './types';

// Scheduled function: tous les jours à 6h UTC
export const fetchEvents = functions
  .runWith({
    timeoutSeconds: 540,
    memory: '1GB',
  })
  .pubsub.schedule('0 6 * * *')
  .timeZone('UTC')
  .onRun(async (context) => {
    const startTime = Date.now();
    logInfo('Starting event ingestion');
    
    try {
      // 1. Fetch AllEvents API
      const allEventsData = await fetchFromAllEvents();
      logInfo(`Fetched ${allEventsData.length} events from AllEvents`);
      
      // 2. Fetch Eventbrite (optionnel)
      // const eventbriteData = await fetchFromEventbrite();
      
      // 3. Normaliser et stocker
      let savedCount = 0;
      let duplicateCount = 0;
      
      const batch = db.batch();
      let batchCount = 0;
      
      for (const rawEvent of allEventsData) {
        try {
          // Normalisation
          const normalized = normalizeEvent(rawEvent);
          
          // Détection doublons
          const isDuplicate = await detectDuplicate(normalized);
          if (isDuplicate) {
            duplicateCount++;
            continue;
          }
          
          // Stockage Firestore
          const docRef = db.collection('raw_events').doc();
          batch.set(docRef, {
            ...normalized,
            id: docRef.id,
            createdAt: timestamp.now(),
            updatedAt: timestamp.now(),
          });
          
          savedCount++;
          batchCount++;
          
          // Commit batch tous les 100 items
          if (batchCount >= 100) {
            await batch.commit();
            batchCount = 0;
          }
        } catch (error) {
          logError('Error processing event', error, { rawEvent });
        }
      }
      
      // Commit restant
      if (batchCount > 0) {
        await batch.commit();
      }
      
      const duration = Date.now() - startTime;
      logInfo('Event ingestion completed', {
        saved: savedCount,
        duplicates: duplicateCount,
        durationMs: duration,
      });
      
      return { success: true, saved: savedCount, duplicates: duplicateCount };
    } catch (error) {
      logError('Fatal error in event ingestion', error);
      throw error;
    }
  });

// Helper: récupération AllEvents API
async function fetchFromAllEvents(): Promise<RawEvent[]> {
  const apiKey = process.env.ALLEVENTS_API_KEY;
  
  if (!apiKey) {
    logInfo('AllEvents API key not configured, skipping');
    return [];
  }
  
  try {
    const response = await axios.get('https://allevents.in/api/events', {
      params: {
        country: 'BJ', // Bénin
        rows: 100,
        from: new Date().toISOString().split('T')[0],
      },
      headers: {
        'Authorization': `Bearer ${apiKey}`,
      },
      timeout: 30000,
    });
    
    return response.data.data.map((event: any): RawEvent => ({
      sourceId: event.id,
      source: 'allevents',
      title: event.title,
      description: event.description || '',
      dateStart: new Date(event.start_date),
      dateEnd: event.end_date ? new Date(event.end_date) : undefined,
      location: {
        name: event.venue_name,
        city: event.city,
        region: event.region,
        country: 'BJ',
        lat: event.latitude,
        lng: event.longitude,
      },
      images: event.images || [],
      categories: event.categories || [],
      url: event.url,
      fetchedAt: new Date(),
    }));
  } catch (error: any) {
    logError('Failed to fetch from AllEvents', error);
    return [];
  }
}
```

#### `src/ingestion/normalizeEvent.ts`

```typescript
import type { RawEvent, NormalizedEvent } from './types';

export function normalizeEvent(raw: RawEvent): Omit<NormalizedEvent, 'id' | 'createdAt' | 'updatedAt'> {
  // Normalisation titre
  const title = raw.title.trim().slice(0, 200);
  
  // Normalisation description
  const description = raw.description
    .replace(/<[^>]*>/g, '') // Strip HTML
    .trim()
    .slice(0, 5000);
  
  // Normalisation localisation
  const venue = {
    name: raw.location.name || 'Non spécifié',
    address: raw.location.address || '',
    city: raw.location.city || 'Cotonou',
    region: raw.location.region || 'Atlantique',
    country: raw.location.country,
    coordinates: (raw.location.lat && raw.location.lng) ? {
      lat: raw.location.lat,
      lng: raw.location.lng,
    } : null,
  };
  
  // Normalisation images
  const coverImage = raw.images?.[0] || null;
  const gallery = raw.images || [];
  
  // Normalisation prix
  const priceRange = raw.price ? {
    min: raw.price.min || 0,
    max: raw.price.max || raw.price.min || 0,
    currency: raw.price.currency || 'XOF',
  } : null;
  
  return {
    sourceId: raw.sourceId,
    source: raw.source,
    title,
    description,
    schedule: {
      startDate: raw.dateStart,
      endDate: raw.dateEnd,
      timezone: 'Africa/Porto-Novo',
    },
    venue,
    media: {
      coverImage,
      gallery,
    },
    priceRange,
    rawCategories: raw.categories || [],
    status: 'pending_enrichment',
  };
}
```

#### `src/ingestion/deduplicateEvents.ts`

```typescript
import { db } from '../shared/firebaseAdmin';
import type { NormalizedEvent } from './types';

// Détection de doublons basée sur similarité
export async function detectDuplicate(
  event: Omit<NormalizedEvent, 'id' | 'createdAt' | 'updatedAt'>
): Promise<boolean> {
  // Stratégie 1: sourceId identique
  const bySourceId = await db
    .collection('raw_events')
    .where('sourceId', '==', event.sourceId)
    .where('source', '==', event.source)
    .limit(1)
    .get();
  
  if (!bySourceId.empty) {
    return true;
  }
  
  // Stratégie 2: titre + date + ville similaires
  const titleNormalized = event.title.toLowerCase().trim();
  const dateKey = event.schedule.startDate.toISOString().split('T')[0];
  
  const bySimilarity = await db
    .collection('raw_events')
    .where('venue.city', '==', event.venue.city)
    .get();
  
  for (const doc of bySimilarity.docs) {
    const existing = doc.data();
    const existingTitle = existing.title.toLowerCase().trim();
    const existingDate = existing.schedule.startDate.toDate().toISOString().split('T')[0];
    
    // Similarité titre > 80% et même date
    if (
      dateKey === existingDate &&
      calculateSimilarity(titleNormalized, existingTitle) > 0.8
    ) {
      return true;
    }
  }
  
  return false;
}

// Helper: similarité Levenshtein simplifiée
function calculateSimilarity(a: string, b: string): number {
  const longer = a.length > b.length ? a : b;
  const shorter = a.length > b.length ? b : a;
  
  if (longer.length === 0) return 1.0;
  
  const editDistance = levenshteinDistance(longer, shorter);
  return (longer.length - editDistance) / longer.length;
}

function levenshteinDistance(a: string, b: string): number {
  const matrix: number[][] = [];
  
  for (let i = 0; i <= b.length; i++) {
    matrix[i] = [i];
  }
  
  for (let j = 0; j <= a.length; j++) {
    matrix[0][j] = j;
  }
  
  for (let i = 1; i <= b.length; i++) {
    for (let j = 1; j <= a.length; j++) {
      if (b.charAt(i - 1) === a.charAt(j - 1)) {
        matrix[i][j] = matrix[i - 1][j - 1];
      } else {
        matrix[i][j] = Math.min(
          matrix[i - 1][j - 1] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j] + 1
        );
      }
    }
  }
  
  return matrix[b.length][a.length];
}
```

### 3. **AI - Enrichissement intelligent**

#### `src/ai/prompts.ts`

```typescript
export const ENRICHMENT_SYSTEM_PROMPT = `Tu es un assistant IA spécialisé dans la réécriture d'événements culturels au Bénin.

Ton rôle :
1. Réécrire le titre et la description pour les rendre attractifs
2. Extraire les catégories pertinentes
3. Générer un résumé court (max 200 caractères)
4. Identifier les tags clés

Contexte culturel :
- Public cible : touristes et locaux au Bénin
- Valoriser la culture béninoise (vaudou, histoire des rois, artisanat)
- Mettre en avant l'authenticité et l'expérience unique

Format de réponse (JSON strict) :
{
  "title": "Titre amélioré (max 100 caractères)",
  "description": "Description enrichie (max 1000 caractères)",
  "shortSummary": "Résumé accrocheur (max 200 caractères)",
  "category": "culture|nature|sport|gastronomie|aventure|wellness",
  "tags": ["tag1", "tag2", "tag3", ...],
  "culturalSignificance": "low|medium|high"
}`;

export const NOTIFICATION_COPY_PROMPT = `Tu es un copywriter spécialisé en notifications push ultra-courtes.

Contraintes :
- Titre: max 50 caractères
- Corps: max 120 caractères
- Ton: enthousiaste mais authentique
- Personnalisation basée sur le profil utilisateur

Format de réponse (JSON) :
{
  "title": "Titre accrocheur",
  "body": "Corps incitatif avec emoji approprié"
}`;
```

#### `src/ai/enrichEvent.ts`

```typescript
import * as functions from 'firebase-functions';
import { db, timestamp } from '../shared/firebaseAdmin';
import { chatCompletion, generateEmbedding } from '../shared/openaiClient';
import { logInfo, logError, logPerformance } from '../shared/logger';
import { retryWithBackoff } from '../shared/retry';
import { ENRICHMENT_SYSTEM_PROMPT } from './prompts';

// Firestore Trigger: enrichissement automatique
export const enrichEvent = functions
  .runWith({
    timeoutSeconds: 300,
    memory: '512MB',
  })
  .firestore.document('raw_events/{eventId}')
  .onCreate(async (snap, context) => {
    const eventId = context.params.eventId;
    const rawEvent = snap.data();
    
    const startTime = Date.now();
    logInfo('Starting event enrichment', { eventId });
    
    try {
      // 1. Enrichissement GPT
      const enriched = await retryWithBackoff(() => 
        enrichEventWithGPT(rawEvent)
      );
      
      // 2. Génération embedding
      const embeddingText = `${enriched.title} ${enriched.shortSummary} ${enriched.tags.join(' ')}`;
      const embedding = await retryWithBackoff(() =>
        generateEmbedding(embeddingText)
      );
      
      // 3. Sauvegarde événement enrichi
      await db.collection('events').doc(eventId).set({
        // Données originales
        sourceId: rawEvent.sourceId,
        source: rawEvent.source,
        
        // Données enrichies
        title: enriched.title,
        description: enriched.description,
        shortSummary: enriched.shortSummary,
        
        // Catégorisation IA
        category: enriched.category,
        tags: enriched.tags,
        culturalSignificance: enriched.culturalSignificance,
        
        // Données normalisées
        schedule: rawEvent.schedule,
        venue: rawEvent.venue,
        media: rawEvent.media,
        priceRange: rawEvent.priceRange,
        
        // Métadonnées
        status: 'active',
        enrichedAt: timestamp.now(),
        createdAt: rawEvent.createdAt,
        updatedAt: timestamp.now(),
        
        // Embedding (pour backup, principal dans Pinecone)
        embeddingPreview: embedding.slice(0, 10), // Premiers 10 dims
      });
      
      // 4. Log performance
      const duration = Date.now() - startTime;
      logPerformance('enrichEvent', duration, {
        eventId,
        category: enriched.category,
        tagCount: enriched.tags.length,
      });
      
      logInfo('Event enrichment completed', { eventId, duration });
      
    } catch (error) {
      logError('Event enrichment failed', error, { eventId });
      
      // Marquer comme erreur pour retry manuel
      await snap.ref.update({
        status: 'enrichment_failed',
        error: error instanceof Error ? error.message : 'Unknown error',
        updatedAt: timestamp.now(),
      });
    }
  });

// Helper: enrichissement avec GPT
async function enrichEventWithGPT(event: any) {
  const userPrompt = `Événement à enrichir :

Titre original : ${event.title}
Description : ${event.description}
Ville : ${event.venue.city}
Date : ${event.schedule.startDate.toDate().toLocaleDateString('fr-FR')}
Catégories brutes : ${event.rawCategories.join(', ')}

Enrichis cet événement en JSON.`;

  const response = await chatCompletion([
    { role: 'system', content: ENRICHMENT_SYSTEM_PROMPT },
    { role: 'user', content: userPrompt },
  ], {
    model: 'gpt-4-turbo-preview',
    temperature: 0.7,
    maxTokens: 1500,
  });
  
  // Parse JSON response
  const jsonMatch = response.match(/\{[\s\S]*\}/);
  if (!jsonMatch) {
    throw new Error('GPT response is not valid JSON');
  }
  
  return JSON.parse(jsonMatch[0]);
}
```

### 4. **Vector - Pinecone Integration**

#### `src/vector/pineconeClient.ts`

```typescript
import { Pinecone } from '@pinecone-database/pinecone';
import { logError } from '../shared/logger';

const PINECONE_API_KEY = process.env.PINECONE_API_KEY;
const PINECONE_INDEX_NAME = process.env.PINECONE_INDEX_NAME || 'benin-experience-feed';

if (!PINECONE_API_KEY) {
  throw new Error('PINECONE_API_KEY not configured');
}

// Singleton Pinecone client
let pineconeClient: Pinecone | null = null;

export function getPineconeClient(): Pinecone {
  if (!pineconeClient) {
    pineconeClient = new Pinecone({
      apiKey: PINECONE_API_KEY!,
    });
  }
  return pineconeClient;
}

export function getPineconeIndex() {
  const client = getPineconeClient();
  return client.index(PINECONE_INDEX_NAME);
}

// Helper: formatage métadonnées pour Pinecone
export function formatMetadata(event: any) {
  return {
    type: 'event',
    eventId: event.id || '',
    title: event.title.slice(0, 200),
    category: event.category,
    city: event.venue?.city || '',
    region: event.venue?.region || '',
    lat: event.venue?.coordinates?.lat || 0,
    lng: event.venue?.coordinates?.lng || 0,
    date: event.schedule?.startDate.toDate().toISOString().split('T')[0] || '',
    organizerId: event.organizerId || '',
    culturalSignificance: event.culturalSignificance || 'medium',
    tags: event.tags?.join(',') || '',
    priceMin: event.priceRange?.min || 0,
    priceMax: event.priceRange?.max || 0,
    createdAt: Date.now(),
  };
}
```

#### `src/vector/upsertVector.ts`

```typescript
import * as functions from 'firebase-functions';
import { db } from '../shared/firebaseAdmin';
import { generateEmbedding } from '../shared/openaiClient';
import { getPineconeIndex, formatMetadata } from './pineconeClient';
import { logInfo, logError } from '../shared/logger';
import { retryWithBackoff } from '../shared/retry';

// Firestore Trigger: sync vers Pinecone
export const upsertVector = functions
  .runWith({
    timeoutSeconds: 180,
    memory: '512MB',
  })
  .firestore.document('events/{eventId}')
  .onWrite(async (change, context) => {
    const eventId = context.params.eventId;
    
    // Suppression
    if (!change.after.exists) {
      try {
        const index = getPineconeIndex();
        await index.namespace('events').deleteOne(eventId);
        logInfo('Vector deleted from Pinecone', { eventId });
      } catch (error) {
        logError('Failed to delete vector', error, { eventId });
      }
      return;
    }
    
    const event = change.after.data();
    
    // Ignorer si pas encore enrichi
    if (event.status !== 'active') {
      return;
    }
    
    try {
      // 1. Générer embedding
      const embeddingText = `${event.title} ${event.shortSummary} ${event.tags.join(' ')}`;
      const embedding = await retryWithBackoff(() =>
        generateEmbedding(embeddingText)
      );
      
      // 2. Formater métadonnées
      const metadata = formatMetadata({
        ...event,
        id: eventId,
      });
      
      // 3. Upsert dans Pinecone
      const index = getPineconeIndex();
      await retryWithBackoff(() =>
        index.namespace('events').upsert([{
          id: eventId,
          values: embedding,
          metadata,
        }])
      );
      
      logInfo('Vector upserted to Pinecone', {
        eventId,
        dimension: embedding.length,
        metadataKeys: Object.keys(metadata).length,
      });
      
      // 4. Marquer comme vectorisé
      await change.after.ref.update({
        vectorized: true,
        vectorizedAt: new Date(),
      });
      
    } catch (error) {
      logError('Failed to upsert vector', error, { eventId });
    }
  });
```

#### `src/vector/queryVector.ts`

```typescript
import { getPineconeIndex } from './pineconeClient';
import { generateEmbedding } from '../shared/openaiClient';
import { logPerformance } from '../shared/logger';
import type { QueryOptions } from '@pinecone-database/pinecone';

export interface VectorQueryOptions {
  userQuery: string;
  userLocation?: { lat: number; lng: number };
  category?: string;
  dateRange?: { start: string; end: string };
  maxResults?: number;
  minScore?: number;
}

export async function queryVectors(
  options: VectorQueryOptions
): Promise<any[]> {
  const startTime = Date.now();
  
  // 1. Générer embedding de la requête utilisateur
  const queryEmbedding = await generateEmbedding(options.userQuery);
  
  // 2. Construire filtres Pinecone
  const filter: Record<string, any> = {
    type: { $eq: 'event' },
  };
  
  if (options.category) {
    filter.category = { $eq: options.category };
  }
  
  if (options.dateRange) {
    filter.date = {
      $gte: options.dateRange.start,
      $lte: options.dateRange.end,
    };
  }
  
  // Filtrage géographique (rayon 50km)
  if (options.userLocation) {
    // Note: Pinecone ne supporte pas nativement le rayon géographique
    // Filtrage post-query nécessaire
  }
  
  // 3. Query Pinecone
  const index = getPineconeIndex();
  const queryResponse = await index.namespace('events').query({
    vector: queryEmbedding,
    topK: options.maxResults || 20,
    filter,
    includeMetadata: true,
  });
  
  // 4. Filtrage géographique post-query
  let results = queryResponse.matches || [];
  
  if (options.userLocation) {
    results = results.filter(match => {
      if (!match.metadata?.lat || !match.metadata?.lng) return false;
      
      const distance = calculateDistance(
        options.userLocation!.lat,
        options.userLocation!.lng,
        match.metadata.lat as number,
        match.metadata.lng as number
      );
      
      return distance <= 50; // 50km
    });
  }
  
  // 5. Filtrer par score minimum
  if (options.minScore) {
    results = results.filter(match => (match.score || 0) >= options.minScore!);
  }
  
  const duration = Date.now() - startTime;
  logPerformance('queryVectors', duration, {
    resultsCount: results.length,
    filters: Object.keys(filter).length,
  });
  
  return results;
}

// Helper: distance haversine
function calculateDistance(
  lat1: number,
  lng1: number,
  lat2: number,
  lng2: number
): number {
  const R = 6371; // Rayon Terre en km
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLng = (lng2 - lng1) * Math.PI / 180;
  
  const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLng / 2) * Math.sin(dLng / 2);
  
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}
```

### 5. **Feed - Construction hybride**

#### `src/feed/buildFeed.ts`

```typescript
import * as functions from 'firebase-functions';
import { db } from '../shared/firebaseAdmin';
import { queryVectors } from '../vector/queryVector';
import { calculateHybridScore } from './scoreHybrid';
import { interleaveContent } from './interleave';
import { logInfo, logPerformance } from '../shared/logger';

interface BuildFeedRequest {
  userId: string;
  location?: { lat: number; lng: number };
  interests?: string[];
  limit?: number;
}

// HTTPS Callable: génération feed personnalisé
export const buildFeed = functions
  .runWith({
    timeoutSeconds: 30,
    memory: '512MB',
  })
  .https.onCall(async (data: BuildFeedRequest, context) => {
    const startTime = Date.now();
    
    // Authentification requise
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'User must be authenticated'
      );
    }
    
    const userId = context.auth.uid;
    logInfo('Building feed', { userId });
    
    try {
      // 1. Récupérer profil utilisateur
      const userProfile = await getUserProfile(userId);
      
      // 2. Construire requête vectorielle
      const userQuery = buildUserQuery(userProfile, data.interests);
      
      // 3. Query Pinecone (événements similaires)
      const vectorResults = await queryVectors({
        userQuery,
        userLocation: data.location || userProfile.location,
        maxResults: 50,
        minScore: 0.5,
      });
      
      // 4. Récupérer stories récentes
      const stories = await getRecentStories(userId);
      
      // 5. Récupérer tickets en promotion
      const tickets = await getFeaturedTickets(data.location);
      
      // 6. Scoring hybride (ML + règles métier)
      const scoredEvents = await Promise.all(
        vectorResults.map(async (result) => {
          const eventDoc = await db.collection('events').doc(result.id).get();
          if (!eventDoc.exists) return null;
          
          const event = eventDoc.data()!;
          const hybridScore = calculateHybridScore(
            event,
            userProfile,
            result.score || 0
          );
          
          return {
            ...event,
            id: eventDoc.id,
            type: 'event',
            score: hybridScore,
          };
        })
      );
      
      const validEvents = scoredEvents.filter(Boolean);
      
      // 7. Interleaving (mélange stories/events/tickets)
      const feed = interleaveContent({
        stories,
        events: validEvents,
        tickets,
        limit: data.limit || 20,
      });
      
      const duration = Date.now() - startTime;
      logPerformance('buildFeed', duration, {
        userId,
        itemCount: feed.length,
        storiesCount: stories.length,
        eventsCount: validEvents.length,
      });
      
      return {
        success: true,
        feed,
        metadata: {
          generatedAt: new Date().toISOString(),
          count: feed.length,
          durationMs: duration,
        },
      };
      
    } catch (error: any) {
      logError('Feed generation failed', error, { userId });
      throw new functions.https.HttpsError('internal', error.message);
    }
  });

// Helpers
async function getUserProfile(userId: string) {
  const doc = await db.collection('users').doc(userId).get();
  
  if (!doc.exists) {
    return {
      interests: ['culture', 'nature'],
      location: { lat: 6.3703, lng: 2.3912 }, // Cotonou par défaut
      following: [],
      preferences: {},
    };
  }
  
  return doc.data();
}

function buildUserQuery(profile: any, interests?: string[]): string {
  const userInterests = interests || profile.interests || ['culture'];
  return `Événements au Bénin: ${userInterests.join(', ')}`;
}

async function getRecentStories(userId: string): Promise<any[]> {
  // Récupérer stories des personnes suivies (dernières 24h)
  const oneDayAgo = new Date(Date.now() - 24 * 60 * 60 * 1000);
  
  const storiesSnap = await db.collection('stories')
    .where('createdAt', '>=', oneDayAgo)
    .where('expiresAt', '>', new Date())
    .orderBy('createdAt', 'desc')
    .limit(20)
    .get();
  
  return storiesSnap.docs.map(doc => ({
    ...doc.data(),
    id: doc.id,
    type: 'story',
  }));
}

async function getFeaturedTickets(location?: { lat: number; lng: number }): Promise<any[]> {
  const ticketsSnap = await db.collection('tickets')
    .where('status', '==', 'active')
    .where('featured', '==', true)
    .limit(10)
    .get();
  
  return ticketsSnap.docs.map(doc => ({
    ...doc.data(),
    id: doc.id,
    type: 'ticket',
  }));
}
```

#### `src/feed/scoreHybrid.ts`

```typescript
// Implémentation scoring hybride (voir HYBRID_FEED_ALGORITHM.md)

export function calculateHybridScore(
  event: any,
  userProfile: any,
  vectorScore: number // 0-1 de Pinecone
): number {
  // 1. Relevance (40%)
  const relevanceScore = calculateRelevance(event, userProfile) * 0.4;
  
  // 2. Recency (25%)
  const recencyScore = calculateRecency(event) * 0.25;
  
  // 3. Engagement (20%)
  const engagementScore = calculateEngagement(event) * 0.2;
  
  // 4. Vector similarity (15%)
  const vectorWeight = vectorScore * 0.15;
  
  return relevanceScore + recencyScore + engagementScore + vectorWeight;
}

function calculateRelevance(event: any, profile: any): number {
  let score = 0;
  
  // Catégorie matching
  if (profile.interests?.includes(event.category)) {
    score += 30;
  }
  
  // Proximité géographique
  if (profile.location && event.venue?.coordinates) {
    const distance = calculateDistance(
      profile.location.lat,
      profile.location.lng,
      event.venue.coordinates.lat,
      event.venue.coordinates.lng
    );
    
    if (distance < 10) score += 25;
    else if (distance < 30) score += 15;
    else if (distance < 50) score += 5;
  }
  
  // Signifiance culturelle
  if (event.culturalSignificance === 'high') {
    score += 20;
  } else if (event.culturalSignificance === 'medium') {
    score += 10;
  }
  
  return Math.min(score, 100);
}

function calculateRecency(event: any): number {
  const now = Date.now();
  const createdAt = event.createdAt?.toDate?.()?.getTime() || now;
  const ageHours = (now - createdAt) / (1000 * 60 * 60);
  
  // Décroissance exponentielle
  return Math.max(0, 100 * Math.exp(-ageHours / 48));
}

function calculateEngagement(event: any): number {
  const social = event.social || { likes: 0, shares: 0, views: 0 };
  
  const totalEngagement = 
    social.likes * 1 +
    social.shares * 3 +
    (social.views || 0) * 0.1;
  
  return Math.min(Math.log10(totalEngagement + 1) * 20, 100);
}

function calculateDistance(lat1: number, lng1: number, lat2: number, lng2: number): number {
  const R = 6371;
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLng = (lng2 - lng1) * Math.PI / 180;
  
  const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLng / 2) * Math.sin(dLng / 2);
  
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}
```

### 6. **Notifications - Envoi intelligent**

#### `src/notifications/smartNotify.ts`

```typescript
import * as functions from 'firebase-functions';
import { db, messaging } from '../shared/firebaseAdmin';
import { generateNotificationCopy } from './generateCopy';
import { targetAudience } from './targetAudience';
import { sendFCMBatch } from './sendFCMBatch';
import { logInfo, logError } from '../shared/logger';

// Scheduled: notifications quotidiennes
export const smartNotify = functions
  .runWith({
    timeoutSeconds: 540,
    memory: '1GB',
  })
  .pubsub.schedule('0 18 * * *') // 18h quotidien
  .timeZone('Africa/Porto-Novo')
  .onRun(async (context) => {
    logInfo('Starting smart notifications');
    
    try {
      // 1. Récupérer événements pertinents (prochains 7 jours)
      const upcoming = await getUpcomingEvents(7);
      
      for (const event of upcoming) {
        // 2. Cibler audience pertinente
        const targetUsers = await targetAudience(event);
        
        logInfo(`Targeting ${targetUsers.length} users for event`, {
          eventId: event.id,
          eventTitle: event.title,
        });
        
        // 3. Batch processing (groupes de 100)
        const batchSize = 100;
        for (let i = 0; i < targetUsers.length; i += batchSize) {
          const batch = targetUsers.slice(i, i + batchSize);
          
          // 4. Générer copies personnalisées
          const notifications = await Promise.all(
            batch.map(async (user) => {
              const copy = await generateNotificationCopy(event, user);
              
              return {
                userId: user.id,
                fcmToken: user.fcmToken,
                title: copy.title,
                body: copy.body,
                data: {
                  type: 'event',
                  eventId: event.id,
                  deepLink: `beninexperience://event/${event.id}`,
                },
              };
            })
          );
          
          // 5. Envoyer FCM batch
          await sendFCMBatch(notifications);
          
          // Pause anti-throttling
          await new Promise(resolve => setTimeout(resolve, 1000));
        }
      }
      
      logInfo('Smart notifications completed');
      
    } catch (error) {
      logError('Smart notifications failed', error);
    }
  });

async function getUpcomingEvents(daysAhead: number): Promise<any[]> {
  const now = new Date();
  const future = new Date(now.getTime() + daysAhead * 24 * 60 * 60 * 1000);
  
  const snapshot = await db.collection('events')
    .where('status', '==', 'active')
    .where('schedule.startDate', '>=', now)
    .where('schedule.startDate', '<=', future)
    .where('notified', '==', false)
    .limit(10)
    .get();
  
  return snapshot.docs.map(doc => ({ ...doc.data(), id: doc.id }));
}
```

#### `src/notifications/generateCopy.ts`

```typescript
import { chatCompletion } from '../shared/openaiClient';
import { NOTIFICATION_COPY_PROMPT } from '../ai/prompts';

export async function generateNotificationCopy(
  event: any,
  user: any
): Promise<{ title: string; body: string }> {
  const userPrompt = `Génère une notification pour :

Événement : ${event.title}
Catégorie : ${event.category}
Date : ${new Date(event.schedule.startDate.toDate()).toLocaleDateString('fr-FR')}
Ville : ${event.venue.city}

Profil utilisateur :
- Intérêts : ${user.interests?.join(', ') || 'culture'}
- Prénom : ${user.displayName || 'Voyageur'}

Ton : enthousiaste, personnalisé, incitatif.`;

  const response = await chatCompletion([
    { role: 'system', content: NOTIFICATION_COPY_PROMPT },
    { role: 'user', content: userPrompt },
  ], {
    temperature: 0.9, // Plus créatif
    maxTokens: 200,
  });
  
  const jsonMatch = response.match(/\{[\s\S]*\}/);
  if (!jsonMatch) {
    // Fallback
    return {
      title: event.title.slice(0, 50),
      body: `📅 ${new Date(event.schedule.startDate.toDate()).toLocaleDateString('fr-FR')} • ${event.venue.city}`,
    };
  }
  
  return JSON.parse(jsonMatch[0]);
}
```

---

## 🎛️ Configuration Pinecone

### Création Index

```bash
# Via Pinecone Console ou CLI
pinecone create-index \
  --name benin-experience-feed \
  --dimension 1536 \
  --metric cosine \
  --pod-type p1.x1
```

### Structure Metadata Recommandée

```typescript
{
  // Type de contenu
  type: 'event' | 'story' | 'ticket',
  
  // Identification
  eventId: string,
  title: string,
  
  // Catégorisation
  category: string,
  tags: string, // CSV
  culturalSignificance: 'low' | 'medium' | 'high',
  
  // Géolocalisation
  city: string,
  region: string,
  lat: number,
  lng: number,
  
  // Temporel
  date: string, // ISO date
  createdAt: number, // Timestamp
  
  // Commercial
  priceMin: number,
  priceMax: number,
  
  // Organisateur
  organizerId: string,
  
  // Statut
  featured: boolean,
}
```

---

## 💰 Optimisation des Coûts

### Stratégies de Réduction

```typescript
// 1. Batch embeddings (plutôt que 1 par 1)
export async function batchGenerateEmbeddings(
  texts: string[]
): Promise<number[][]> {
  const BATCH_SIZE = 100; // Max OpenAI
  const results: number[][] = [];
  
  for (let i = 0; i < texts.length; i += BATCH_SIZE) {
    const batch = texts.slice(i, i + BATCH_SIZE);
    
    const response = await openai.embeddings.create({
      model: 'text-embedding-3-small', // Moins cher que ada-002
      input: batch,
    });
    
    results.push(...response.data.map(d => d.embedding));
  }
  
  return results;
}

// 2. Cache résultats fréquents
import * as admin from 'firebase-admin';

const cache = new Map<string, any>();
const CACHE_TTL = 3600 * 1000; // 1h

export async function cachedQuery(
  key: string,
  fn: () => Promise<any>
): Promise<any> {
  const cached = cache.get(key);
  
  if (cached && Date.now() - cached.timestamp < CACHE_TTL) {
    return cached.value;
  }
  
  const value = await fn();
  cache.set(key, { value, timestamp: Date.now() });
  
  return value;
}

// 3. Réduire dimensionnalité si nécessaire
// text-embedding-3-small: 1536 dims (default)
// text-embedding-3-large: 3072 dims (meilleur mais +cher)
// Possibilité de réduire à 512 dims avec PCA post-processing
```

### Estimation Coûts Mensuels

```
# OpenAI (pour 10K événements/mois)
- Embeddings (text-embedding-3-small): $0.02/1M tokens
  → ~10K events × 500 tokens = 5M tokens = $0.10
  
- Enrichissement GPT-4 Turbo: $0.01/1K tokens input, $0.03/1K output
  → ~10K events × 1K tokens avg = $400/mois
  
  💡 Alternative: GPT-3.5-turbo = $0.001/$0.002 → $30/mois

# Pinecone
- Starter (1M vecteurs, 1 pod p1.x1): $70/mois
- Standard (5M vecteurs, 1 pod p1.x2): $140/mois

# Firebase (Gen 2 Functions)
- Invocations: 2M/mois gratuites
- Compute: ~$0.50/mois (optimisé)

Total estimé: $100-150/mois (avec GPT-3.5) ou $500/mois (GPT-4)
```

---

## 🚀 Bonnes Pratiques

### 1. Retry & Error Handling

```typescript
// Implémenté dans src/shared/retry.ts
import { retryWithBackoff } from '../shared/retry';

// Utilisation
const result = await retryWithBackoff(
  () => openai.embeddings.create({ ... }),
  {
    maxRetries: 3,
    initialDelay: 1000,
    maxDelay: 10000,
  }
);
```

### 2. Rate Limiting

```typescript
// src/shared/rateLimiter.ts
export class RateLimiter {
  private queue: Array<() => Promise<any>> = [];
  private running = 0;
  
  constructor(private maxConcurrent: number) {}
  
  async execute<T>(fn: () => Promise<T>): Promise<T> {
    while (this.running >= this.maxConcurrent) {
      await new Promise(resolve => setTimeout(resolve, 100));
    }
    
    this.running++;
    try {
      return await fn();
    } finally {
      this.running--;
    }
  }
}

// Usage
const limiter = new RateLimiter(5); // Max 5 requêtes parallèles
await limiter.execute(() => openai.embeddings.create({ ... }));
```

### 3. Monitoring & Alerting

```typescript
// src/shared/monitoring.ts
import { logInfo } from './logger';

export function trackMetric(
  name: string,
  value: number,
  tags?: Record<string, string>
) {
  logInfo('Metric', {
    metric: name,
    value,
    tags,
    timestamp: Date.now(),
  });
  
  // Optionnel: export vers Google Cloud Monitoring
  // monitoring.recordPoint({
  //   metric: `custom.googleapis.com/${name}`,
  //   value,
  // });
}

// Usage
trackMetric('feed.generation.duration', 1234, { userId: 'abc123' });
trackMetric('openai.tokens.used', 5000, { model: 'gpt-4' });
```

---

## 🧪 Tests & Déploiement

### Tests locaux

```bash
# 1. Émulateurs Firebase
npm run serve

# 2. Test ingestion
curl http://localhost:5001/PROJECT_ID/us-central1/buildFeed \
  -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
  -H "Content-Type: application/json" \
  -d '{"data": {"userId": "test123", "limit": 10}}'

# 3. Test enrichissement (trigger Firestore)
# → Créer document dans raw_events via console
```

### Déploiement

```bash
# 1. Build
npm run build

# 2. Déploiement sélectif
firebase deploy --only functions:fetchEvents,functions:enrichEvent

# 3. Déploiement complet
firebase deploy --only functions

# 4. Vérification logs
firebase functions:log --only enrichEvent
```

---

## 📈 Évolutions Futures

### Phase 2: Vision AI

```typescript
// src/ai/visionModeration.ts
import OpenAI from 'openai';

export async function moderateImage(imageUrl: string): Promise<{
  safe: boolean;
  categories: string[];
  description: string;
}> {
  const response = await openai.chat.completions.create({
    model: 'gpt-4-vision-preview',
    messages: [{
      role: 'user',
      content: [
        { type: 'text', text: 'Analyse cette image d\'événement. Est-elle appropriée ? Décris son contenu.' },
        { type: 'image_url', image_url: { url: imageUrl } },
      ],
    }],
  });
  
  // Parse réponse...
  return {
    safe: true,
    categories: ['culture', 'outdoor'],
    description: response.choices[0].message.content || '',
  };
}
```

### Phase 3: Fine-tuning Personnalisé

```typescript
// Entraîner modèle custom sur données Bénin
// 1. Collecter dataset (événements + engagement)
// 2. Fine-tune GPT-3.5 ou text-embedding
// 3. Déployer modèle custom via OpenAI API
```

---

## 📚 Ressources

- [OpenAI Embeddings Guide](https://platform.openai.com/docs/guides/embeddings)
- [Pinecone Docs](https://docs.pinecone.io/)
- [Firebase Functions Best Practices](https://firebase.google.com/docs/functions/best-practices)
- [Cost Optimization Guide](https://cloud.google.com/functions/docs/bestpractices/tips)

---

**🎯 Checklist Déploiement:**

✅ Variables d'environnement configurées (.env)  
✅ Index Pinecone créé (benin-experience-feed)  
✅ Firebase Functions déployées  
✅ Scheduled functions activées (ingestion + notifications)  
✅ Firestore indexes créés  
✅ Rate limiting configuré  
✅ Monitoring actif (Cloud Logging)  
✅ Budget alerts (Google Cloud)
