class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final MessageType type;
  final String? text;
  final String? mediaUrl;
  final String? thumbnailUrl; // Pour vidéos
  final int? duration; // Durée pour vidéos/audio éphémères (secondes)
  final DateTime createdAt;
  final DateTime? expiresAt; // Null = permanent, sinon éphémère
  final bool isRead;
  final DateTime? readAt;
  final List<String> viewedBy; // Pour les messages de groupe
  
  // Réactions aux messages
  final List<MessageReaction> reactions;
  
  // Réponse à un message
  final String? replyToMessageId;
  final String? replyToText;
  
  // Transfert
  final bool isForwarded;
  final String? originalSenderId;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.type,
    this.text,
    this.mediaUrl,
    this.thumbnailUrl,
    this.duration,
    required this.createdAt,
    this.expiresAt,
    this.isRead = false,
    this.readAt,
    this.viewedBy = const [],
    this.reactions = const [],
    this.replyToMessageId,
    this.replyToText,
    this.isForwarded = false,
    this.originalSenderId,
  });
}

enum MessageType {
  text,
  image,
  video,
  audio,
  ephemeralImage, // Disparaît après visionnage
  ephemeralVideo,
  location,
  contact,
  postShare, // Partage d'un post du feed
  storyReply // Réponse à une story
}

class MessageReaction {
  final String userId;
  final String emoji;
  final DateTime timestamp;

  MessageReaction({
    required this.userId,
    required this.emoji,
    required this.timestamp,
  });
}

