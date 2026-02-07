
import * as functions from 'firebase-functions';
import { getFirestore, FieldValue } from 'firebase-admin/firestore';

const db = getFirestore();

// ============================================================================
// TRACKING VUES STORIES (COMPTE PRÉCIS)
// ============================================================================

export const trackStoryView = functions.firestore
  .document('stories/{storyId}/views/{viewerId}')
  .onCreate(async (snap, context) => {
    const { storyId } = context.params;
    const viewData = snap.data();

    // Incrémenter compteur global
    await db.collection('stories').doc(storyId).update({
      viewCount: FieldValue.increment(1),
      [`viewerStats.${viewData.platform || 'unknown'}`]: FieldValue.increment(1),
    });

    // Analytics pour auteur
    const story = await db.collection('stories').doc(storyId).get();
    const authorId = story.data()?.authorId;

    if (authorId) {
      await db.collection('analytics').doc(`${authorId}_${new Date().toISOString().slice(0, 10)}`).set({
        type: 'story_view',
        storyId,
        viewerId: context.params.viewerId,
        viewedAt: FieldValue.serverTimestamp(),
        watchDuration: viewData.watchDuration || 0,
        completed: viewData.completed || false,
      }, { merge: true });
    }

    return null;
  });

// ============================================================================
// RAPPORT HEBDOMADAIRE POUR PROS
// ============================================================================

export const sendWeeklyReport = functions.pubsub
  .schedule('0 9 * * 1')  // Tous les lundis à 9h
  .timeZone('Africa/Porto-Novo')
  .onRun(async (context) => {
    const oneWeekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);

    // Récupérer les comptes pros actifs
    const pros = await db
      .collection('professional_profiles')
      .where('status', '==', 'active')
      .get();

    for (const pro of pros.docs) {
      const proData = pro.data();
      const userId = pro.id;

      // Agréger les stats
      const posts = await db
        .collection('feed_posts')
        .where('authorId', '==', userId)
        .where('createdAt', '>=', oneWeekAgo)
        .get();

      const stories = await db
        .collection('stories')
        .where('authorId', '==', userId)
        .where('createdAt', '>=', oneWeekAgo)
        .get();

      const totalViews = posts.docs.reduce((sum, p) => sum + (p.data().engagement?.views || 0), 0);
      const totalLikes = posts.docs.reduce((sum, p) => sum + (p.data().engagement?.likes || 0), 0);
      const storyViews = stories.docs.reduce((sum, s) => sum + (s.data().viewCount || 0), 0);

      // Envoyer email (via SendGrid ou autre) ou notification
      const user = await db.collection('users').doc(userId).get();
      const email = user.data()?.email;

      if (email) {
        // TODO: Intégrer SendGrid
        console.log(`📧 Rapport pour ${email}: ${totalViews} vues, ${totalLikes} likes`);
      }
    }

    return null;
  });
