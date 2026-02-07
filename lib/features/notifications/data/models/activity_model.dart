
import 'package:equatable/equatable.dart';

enum ActivityType {
  like,
  comment,
  follow,
  storyView,
  mention,
  eventReminder,
  nearbyRecommendation,
  professionalVerification,
  bookingConfirmed,
  messageReceived,
}

class ActivityModel extends Equatable {
  final String id;
  final ActivityType type;
  final String actorId;
  final String actorName;
  final String? actorAvatar;
  final String? targetId;
  final String? targetPreview;
  final DateTime timestamp;
  final bool isRead;

  const ActivityModel({
    required this.id,
    required this.type,
    required this.actorId,
    required this.actorName,
    this.actorAvatar,
    this.targetId,
    this.targetPreview,
    required this.timestamp,
    this.isRead = false,
  });

  String get description {
    return switch (type) {
      ActivityType.like => 'a aimé votre publication',
      ActivityType.comment => 'a commenté votre publication',
      ActivityType.follow => 'a commencé à vous suivre',
      ActivityType.storyView => 'a vu votre story',
      ActivityType.mention => 'vous a mentionné',
      ActivityType.eventReminder => 'Rappel: Événement dans 24h',
      ActivityType.nearbyRecommendation => 'Nouveau lieu près de vous',
      ActivityType.professionalVerification => 'Compte vérifié',
      ActivityType.bookingConfirmed => 'Réservation confirmée',
      ActivityType.messageReceived => 'Nouveau message',
    };
  }

  @override
  List<Object?> get props => [id, type, actorId, timestamp];
}