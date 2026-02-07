
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { getFirestore, FieldValue } from 'firebase-admin/firestore';

const db = getFirestore();

// ============================================================================
// CALCUL DU SCORE DE TENDANCE (TRENDING)
// ============================================================================

export const calculateTrendingScore = functions.firestore
  .document('feed_posts/{postId}')
  .onWrite(async (change, context) => {
    const postId = context.params.postId;
    
    // Ne recalculer que si engagement changé
    if (!change.after.exists) return null; // Post supprimé
    
    const before = change.before.data() || {};
    const after = change.after.data() || {};
    
    const engagementBefore = before.engagement || {};
    const engagementAfter = after.engagement || {};
    
    // Vérifier si engagement significativement changé
    const likesDiff = (engagementAfter.likes || 0) - (engagementBefore.likes || 0);
    const commentsDiff = (engagementAfter.comments || 0) - (engagementBefore.comments || 0);
    
    if (likesDiff < 5 && commentsDiff < 2) return null; // Pas assez de changement

    const now = Date.now();
    const createdAt = after.createdAt?.toMillis() || now;
    const ageHours = (now - createdAt) / (1000 * 60 * 60);

    // Algorithme: (likes * 1 + comments * 3 + shares * 5) / (age + 2)^1.5
    const likes = engagementAfter.likes || 0;
    const comments = engagementAfter.comments || 0;
    const shares = engagementAfter.shares || 0;
    const saves = engagementAfter.saves || 0;

    const score = (
      (likes * 1) +
      (comments * 3) +
      (shares * 5) +
      (saves * 2)
    ) / Math.pow(ageHours + 2, 1.5);

    await change.after.ref.update({
      'metadata.trendingScore': score,
      'metadata.lastScoreUpdate': FieldValue.serverTimestamp(),
    });

    // Si score très haut, ajouter à trending
    if (score > 100) {
      await db.collection('trending').doc(postId).set({
        postId,
        score,
        commune: after.context?.commune,
        department: after.context?.department,
        updatedAt: FieldValue.serverTimestamp(),
      });
    }

    return null;
  });

// ============================================================================
// GÉNÉRATION DU FEED PERSONNALISÉ (FONCTION SCHEDULÉE)
// ============================================================================

export const generatePersonalizedFeeds = functions.pubsub
  .schedule('0 */6 * * *')  // Toutes les 6 heures
  .timeZone('Africa/Porto-Novo')
  .onRun(async (context) => {
    // Récupérer les utilisateurs actifs
    const activeUsers = await db
      .collection('users')
      .where('lastActive', '>', new Date(Date.now() - 7 * 24 * 60 * 60 * 1000))
      .limit(100)
      .get();

    const promises = activeUsers.docs.map(async (userDoc) => {
      const user = userDoc.data();
      const userId = userDoc.id;

      // Récupérer leurs préférences
      const prefs = user.preferences || {};
      const followedUsers = user.following || [];
      const preferredCommunes = prefs.preferredCommunes || [user.location?.commune];

      // Requête 1: Posts des utilisateurs suivis
      const followingPosts = await db
        .collection('feed_posts')
        .where('authorId', 'in', followedUsers.slice(0, 10))
        .where('createdAt', '>', new Date(Date.now() - 48 * 60 * 60 * 1000))
        .orderBy('createdAt', 'desc')
        .limit(10)
        .get();

      // Requête 2: Posts populaires dans les communes préférées
      const nearbyPosts = await db
        .collection('feed_posts')
        .where('context.commune', 'in', preferredCommunes.slice(0, 10))
        .orderBy('metadata.trendingScore', 'desc')
        .limit(10)
        .get();

      // Requête 3: Découvertes culturelles
      const culturalPosts = await db
        .collection('feed_posts')
        .where('badges', 'array-contains', 'cultural_heritage')
        .orderBy('createdAt', 'desc')
        .limit(5)
        .get();

      // Fusion et déduplication
      const allPosts = [
        ...followingPosts.docs,
        ...nearbyPosts.docs,
        ...culturalPosts.docs,
      ];

      const uniquePosts = Array.from(
        new Map(allPosts.map(p => [p.id, p])).values()
      );

      // Trier par score combiné
      const scoredPosts = uniquePosts.map(doc => {
        const data = doc.data();
        const isFollowing = followedUsers.includes(data.authorId);
        const isNearby = preferredCommunes.includes(data.context?.commune);
        const trendingScore = data.metadata?.trendingScore || 0;

        return {
          postId: doc.id,
          score: (isFollowing ? 100 : 0) + (isNearby ? 50 : 0) + trendingScore,
        };
      });

      scoredPosts.sort((a, b) => b.score - a.score);

      // Sauvegarder le feed généré
      await db.collection('user_feeds').doc(userId).set({
        postIds: scoredPosts.slice(0, 50).map(p => p.postId),
        generatedAt: FieldValue.serverTimestamp(),
        expiresAt: new Date(Date.now() + 6 * 60 * 60 * 1000), // 6h
      });

      return { userId, count: scoredPosts.length };
    });

    const results = await Promise.all(promises);
    console.log(`📰 Feeds générés pour ${results.length} utilisateurs`);

    return { generated: results.length };
  });
