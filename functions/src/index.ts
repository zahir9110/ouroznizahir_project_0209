// functions/src/index.ts

import * as admin from 'firebase-admin';
import { getFirestore } from 'firebase-admin/firestore';
import { getStorage } from 'firebase-admin/storage';
import { getMessaging } from 'firebase-admin/messaging';

// Initialisation Firebase Admin
admin.initializeApp();

// Export des services pour utilisation globale
export const db = getFirestore();
export const storage = getStorage();
export const messaging = getMessaging();

// ============================================================================
// EXPORTS DES FONCTIONS PAR FEATURE
// ============================================================================

// Vérification Professionnelle
export * from './verification/ai_verification_service';

// Stories & Contenu Temporaire
export * from './stories/story_lifecycle';

// Notifications Push
export * from './notifications/push_notifications';

// Feed & Algorithmes
export * from './feed/feed_aggregation';

// Chat & Messagerie
export * from './chat/message_delivery';
export * from './chat/ephemeral_cleanup';

// Analytics & Reporting
export * from './analytics/engagement_tracking';

// Test simple
export const helloWorld = functions.https.onRequest((request, response) => {
  response.json({ 
    message: 'Hello from Benin Experience API!',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});