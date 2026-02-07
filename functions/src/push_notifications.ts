
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { getMessaging } from 'firebase-admin/messaging';
import { getFirestore, Timestamp, FieldValue } from 'firebase-admin/firestore';

const db = getFirestore();

// ============================================================================
// ENVOI NOTIFICATION À LA RÉCEPTION D'UN MESSAGE
// ============================================================================

export const sendMessageNotification = functions.firestore
  .document('conversations/{conversationId}/messages/{messageId}')
  .onCreate(async (snap, context) => {
    const message = snap.data();
    const { conversationId, messageId } = context.params;

    // Ne pas notifier si c'est un message système
    if (message.senderId === 'system') return null;

    // Récupérer la conversation pour connaître les participants
    const conversationDoc = await db
      .collection('conversations')
      .doc(conversationId)
      .get();
    
    if (!conversationDoc.exists) return null;

    const conversation = conversationDoc.data()!;
    const participants = conversation.participants || {};
    
    // Notifier tous les autres participants
    const notificationPromises = Object.entries(participants)
      .filter(([userId, _]) => userId !== message.senderId)
      .map(async ([userId, userData]: [string, any]) => {
        // Vérifier si l'utilisateur est en ligne
        const userStatus = await db.collection('user_status').doc(userId).get();
        if (userStatus.data()?.isOnline) return null; // Pas de notif si en ligne

        // Vérifier si notifications activées pour cette conversation
        const settings = userData.notificationSettings || {};
        if (settings.muted) return null;

        const fcmToken = userData.fcmToken;
        if (!fcmToken) return null;

        // Construire le payload
        const payload = buildMessagePayload(message, conversation, userData);

        try {
          await getMessaging().send({
            token: fcmToken,
            notification: payload.notification,
            data: payload.data,
            android: {
              priority: 'high',
              notification: {
                channelId: 'chat_messages',
                sound: 'default',
              },
            },
            apns: {
              payload: {
                aps: {
                  sound: 'default',
                  badge: (userData.unreadCount || 0) + 1,
                },
              },
            },
          });

          // Logger la notification
          await db.collection('notifications_sent').add({
            userId,
            messageId,
            conversationId,
            type: 'chat_message',
            sentAt: FieldValue.serverTimestamp(),
            delivered: true,
          });

        } catch (error) {
          console.error(`❌ Erreur envoi notif à ${userId}:`, error);
          
          // Si token invalide, le supprimer
          if ((error as any).code === 'messaging/registration-token-not-registered') {
            await db.collection('conversations').doc(conversationId).update({
              [`participants.${userId}.fcmToken`]: FieldValue.delete(),
            });
          }
        }
      });

    await Promise.all(notificationPromises);
    return null;
  });

// ============================================================================
// NOTIFICATION LIKE/SUIVI/MENTION
// ============================================================================

export const sendSocialNotification = functions.firestore
  .document('notifications/{notificationId}')
  .onCreate(async (snap, context) => {
    const notif = snap.data();
    
    // Ne pas envoyer si l'utilisateur a désactivé ce type
    const userPrefs = await db
      .collection('user_preferences')
      .doc(notif.recipientId)
      .get();
    
    const prefs = userPrefs.data() || {};
    const typeSettings = prefs.notifications || {};
    
    if (typeSettings[notif.type] === false) return null;

    const recipient = await db.collection('users').doc(notif.recipientId).get();
    const fcmToken = recipient.data()?.fcmToken;
    
    if (!fcmToken) return null;

    const payload = buildSocialPayload(notif);

    await getMessaging().send({
      token: fcmToken,
      notification: payload,
      data: {
        type: notif.type,
        referenceId: notif.referenceId || '',
        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
      },
    });

    return null;
  });

// ============================================================================
// NOTIFICATION PROXIMITÉ (GEOHASH)
// ============================================================================

export const notifyNearbyEvents = functions.firestore
  .document('events/{eventId}')
  .onCreate(async (snap, context) => {
    const event = snap.data();
    
    // Trouver les utilisateurs proches (simplifié - utiliser GeoFire en production)
    const nearbyUsers = await db
      .collection('users')
      .where('location.commune', '==', event.location?.commune)
      .where('preferences.nearbyNotifications', '==', true)
      .limit(100)
      .get();

    const notificationPromises = nearbyUsers.docs.map(async (userDoc) => {
      const user = userDoc.data();
      if (!user.fcmToken) return null;

      return getMessaging().send({
        token: user.fcmToken,
        notification: {
          title: '🎉 Nouvel événement près de vous !',
          body: `${event.title} à ${event.location?.name || 'proximité'}`,
        },
        data: {
          type: 'nearby_event',
          eventId: context.params.eventId,
        },
      });
    });

    await Promise.all(notificationPromises);
    console.log(`📍 ${nearbyUsers.size} utilisateurs notifiés de l'événement`);

    return null;
  });

// ============================================================================
// HELPERS
// ============================================================================

function buildMessagePayload(message: any, conversation: any, recipientData: any) {
  const senderName = conversation.participants[message.senderId]?.name || 'Quelqu\'un';
  const isEphemeral = message.ephemeral?.enabled;
  
  let body = message.content?.text || '';
  if (isEphemeral) body = '🔒 Message éphémère';
  if (message.type === 'image') body = '📷 Photo';
  if (message.type === 'video') body = '🎥 Vidéo';
  if (message.type === 'audio') body = '🎵 Message vocal';

  return {
    notification: {
      title: senderName,
      body: body.substring(0, 100), // Limite 100 caractères
    },
    data: {
      type: 'chat_message',
      conversationId: conversation.id,
      messageId: message.id,
      senderId: message.senderId,
      ephemeral: isEphemeral ? 'true' : 'false',
    },
  };
}

function buildSocialPayload(notif: any) {
  const templates: Record<string, { title: string; emoji: string }> = {
    like: { title: 'Nouveau J\'aime', emoji: '❤️' },
    comment: { title: 'Nouveau commentaire', emoji: '💬' },
    follow: { title: 'Nouveau follower', emoji: '👤' },
    mention: { title: 'Vous êtes mentionné', emoji: '@️' },
    story_view: { title: 'Story vue', emoji: '👁️' },
  };

  const template = templates[notif.type] || { title: 'Notification', emoji: '🔔' };

  return {
    title: `${template.emoji} ${template.title}`,
    body: notif.message || 'Nouvelle activité',
  };
}
