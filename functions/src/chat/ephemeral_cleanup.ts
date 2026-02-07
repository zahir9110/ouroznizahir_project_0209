
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { getFirestore, Timestamp, FieldValue } from 'firebase-admin/firestore';

const db = getFirestore();

// ============================================================================
// NETTOYAGE DES MESSAGES ÉPHÉMÈRES
// ============================================================================

export const cleanupEphemeralMessages = functions.pubsub
  .schedule('*/15 * * * *')  // Toutes les 15 minutes
  .timeZone('Africa/Porto-Novo')
  .onRun(async (context) => {
    const now = Timestamp.now();

    const expiredMessages = await db
      .collectionGroup('messages')
      .where('ephemeral.enabled', '==', true)
      .where('ephemeral.expiresAt', '<=', now)
      .where('ephemeral.deleted', '!=', true)
      .limit(200)
      .get();

    const batch = db.batch();
    let deletedCount = 0;

    expiredMessages.docs.forEach((doc) => {
      const message = doc.data();
      
      // Vérifier si tous les participants ont vu
      const conversationId = doc.ref.parent.parent!.id;
      
      // Soft delete - remplacer le contenu
      batch.update(doc.ref, {
        'content.text': '⏱️ Ce message a disparu',
        'content.url': null,
        'content.thumbnail': null,
        'ephemeral.deleted': true,
        'ephemeral.deletedAt': now,
      });

      deletedCount++;
    });

    if (deletedCount > 0) {
      await batch.commit();
      console.log(`🗑️ ${deletedCount} messages éphémères nettoyés`);
    }

    return { deleted: deletedCount };
  });

// ============================================================================
// DÉTECTION SCREENSHOT (iOS/Android)
// ============================================================================

export const logScreenshot = functions.https.onCall(async (data, context) => {
  const { conversationId, messageId } = data;
  const userId = context.auth?.uid;

  if (!userId) {
    throw new functions.https.HttpsError('unauthenticated', 'Auth requise');
  }

  // Logger la tentative de screenshot
  await db.collection('security_events').add({
    type: 'screenshot_detected',
    userId,
    conversationId,
    messageId,
    timestamp: FieldValue.serverTimestamp(),
  });

  // Notifier l'expéditeur original
  const message = await db
    .collection('conversations')
    .doc(conversationId)
    .collection('messages')
    .doc(messageId)
    .get();

  const senderId = message.data()?.senderId;
  if (senderId && senderId !== userId) {
    const sender = await db.collection('users').doc(senderId).get();
    const fcmToken = sender.data()?.fcmToken;

    if (fcmToken) {
      // Import dynamique pour éviter circular dependency
      const { getMessaging } = await import('firebase-admin/messaging');
      await getMessaging().send({
        token: fcmToken,
        notification: {
          title: '⚠️ Capture d\'écran détectée',
          body: 'Quelqu\'un a capturé votre message éphémère',
        },
        data: {
          type: 'screenshot_alert',
        },
      });
    }
  }

  return { logged: true };
});
