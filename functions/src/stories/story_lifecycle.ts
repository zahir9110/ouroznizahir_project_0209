// functions/src/stories/story_lifecycle.ts

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

const db = admin.firestore();
const storage = admin.storage();

/**
 * 🎬 Créer une story et propager aux followers (fanout)
 * Trigger: onCreate stories/{storyId}
 */
export const onStoryCreated = functions.firestore
  .document('stories/{storyId}')
  .onCreate(async (snapshot, context) => {
    const story = snapshot.data();
    const userId = story.userId;
    const storyId = context.params.storyId;

    console.log(`✅ Story créée par ${userId}: ${storyId}`);

    try {
      // Récupérer tous les followers
      const followersSnapshot = await db
        .collection('users')
        .doc(userId)
        .collection('followers')
        .get();

      if (followersSnapshot.empty) {
        console.log('⚠️ Aucun follower à notifier');
        return;
      }

      // Fanout: écrire dans stories_feed de chaque follower
      const batch = db.batch();

      followersSnapshot.forEach((followerDoc) => {
        const followerFeedRef = db
          .collection('users')
          .doc(followerDoc.id)
          .collection('stories_feed')
          .doc(storyId);

        batch.set(followerFeedRef, {
          userId,
          userDisplayName: story.userDisplayName,
          userPhotoUrl: story.userPhotoUrl || '',
          hasNewContent: true,
          lastSegmentSeen: -1,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      });

      await batch.commit();
      console.log(`📢 Story propagée à ${followersSnapshot.size} followers`);

      // Optionnel: Envoyer notifications push
      // await sendStoriesNotifications(followersSnapshot, story);

    } catch (error) {
      console.error('❌ Erreur fanout story:', error);
      throw error;
    }
  });

/**
 * 🗑️ Nettoyage automatique des stories expirées
 * Trigger: Scheduled (toutes les 2 heures)
 */
export const cleanupExpiredStories = functions.pubsub
  .schedule('every 2 hours')
  .timeZone('Africa/Porto-Novo') // Bénin timezone
  .onRun(async (context) => {
    console.log('🧹 Démarrage nettoyage stories expirées...');

    const now = admin.firestore.Timestamp.now();

    try {
      // Récupérer stories expirées (actives mais expiresAt < now)
      const expiredSnapshot = await db
        .collection('stories')
        .where('status', '==', 'active')
        .where('expiresAt', '<', now)
        .limit(100) // Traiter par lots
        .get();

      if (expiredSnapshot.empty) {
        console.log('✅ Aucune story à nettoyer');
        return;
      }

      const batch = db.batch();

      expiredSnapshot.forEach((doc) => {
        // Marquer comme expirée (soft delete)
        batch.update(doc.ref, {
          status: 'expired',
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        // Optionnel: Supprimer médias Storage
        const segments = doc.data().segments || [];
        segments.forEach((segment: any) => {
          const filePath = extractStoragePath(segment.mediaUrl);
          if (filePath) {
            storage.bucket().file(filePath).delete().catch(console.error);
          }
        });
      });

      await batch.commit();
      console.log(`🗑️ ${expiredSnapshot.size} stories nettoyées`);

    } catch (error) {
      console.error('❌ Erreur nettoyage:', error);
      throw error;
    }
  });

/**
 * 📊 Mise à jour compteur vues en temps réel
 * Trigger: onCreate stories/{storyId}/viewers/{viewerId}
 */
export const onViewerAdded = functions.firestore
  .document('stories/{storyId}/viewers/{viewerId}')
  .onCreate(async (snapshot, context) => {
    const storyId = context.params.storyId;

    try {
      await db.collection('stories').doc(storyId).update({
        viewsCount: admin.firestore.FieldValue.increment(1),
        lastViewedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      console.log(`👀 Vue enregistrée pour story ${storyId}`);
    } catch (error) {
      console.error('❌ Erreur update vue:', error);
    }
  });

/**
 * 🎯 Enregistrer interaction CTA
 * Callable function
 */
export const recordStoryInteraction = functions.https.onCall(
  async (data, context) => {
    // Vérifier authentification
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'Authentification requise'
      );
    }

    const { storyId, ctaType } = data;
    const userId = context.auth.uid;

    if (!storyId || !ctaType) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'storyId et ctaType requis'
      );
    }

    try {
      await db.runTransaction(async (transaction) => {
        const storyRef = db.collection('stories').doc(storyId);
        transaction.update(storyRef, {
          interactionsCount: admin.firestore.FieldValue.increment(1),
        });

        const viewerRef = storyRef.collection('viewers').doc(userId);
        transaction.update(viewerRef, {
          interacted: true,
          interactionType: ctaType,
          interactedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      });

      console.log(`✅ Interaction CTA enregistrée: ${ctaType}`);
      return { success: true };

    } catch (error) {
      console.error('❌ Erreur interaction:', error);
      throw new functions.https.HttpsError('internal', 'Erreur serveur');
    }
  }
);

/**
 * 📈 Calculer analytics d'une story
 * Callable function
 */
export const getStoryAnalytics = functions.https.onCall(
  async (data, context) => {
    // Vérifier authentification
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'Authentification requise'
      );
    }

    const { storyId } = data;
    const userId = context.auth.uid;

    if (!storyId) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'storyId requis'
      );
    }

    try {
      // Vérifier propriétaire
      const storyDoc = await db.collection('stories').doc(storyId).get();
      
      if (!storyDoc.exists) {
        throw new functions.https.HttpsError('not-found', 'Story introuvable');
      }

      const story = storyDoc.data()!;

      if (story.userId !== userId) {
        throw new functions.https.HttpsError(
          'permission-denied',
          'Accès refusé'
        );
      }

      // Récupérer viewers
      const viewersSnapshot = await db
        .collection('stories')
        .doc(storyId)
        .collection('viewers')
        .orderBy('viewedAt', 'desc')
        .limit(100)
        .get();

      const viewers = viewersSnapshot.docs.map((doc) => ({
        userId: doc.id,
        ...doc.data(),
      }));

      return {
        storyId,
        viewsCount: story.viewsCount || 0,
        completionCount: story.completionCount || 0,
        interactionsCount: story.interactionsCount || 0,
        completionRate: story.viewsCount > 0
          ? ((story.completionCount / story.viewsCount) * 100).toFixed(1)
          : 0,
        interactionRate: story.viewsCount > 0
          ? ((story.interactionsCount / story.viewsCount) * 100).toFixed(1)
          : 0,
        viewers,
      };

    } catch (error) {
      console.error('❌ Erreur analytics:', error);
      throw new functions.https.HttpsError('internal', 'Erreur serveur');
    }
  }
);

/**
 * Helper: Extraire path Storage depuis URL
 */
function extractStoragePath(url: string): string | null {
  try {
    const matches = url.match(/\/o\/(.+?)\?/);
    return matches ? decodeURIComponent(matches[1]) : null;
  } catch {
    return null;
  }
}
