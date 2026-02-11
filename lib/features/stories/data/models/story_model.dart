
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/story.dart';
import '../../domain/entities/story_segment.dart';
import '../../domain/entities/story_cta.dart';

/// Model Firestore pour Story
class StoryModel extends Story {
  const StoryModel({
    required super.id,
    required super.userId,
    required super.userDisplayName,
    required super.userPhotoUrl,
    required super.createdAt,
    required super.expiresAt,
    required super.type,
    super.eventId,
    super.eventTitle,
    super.ticketId,
    super.ticketPrice,
    super.ticketCurrency,
    required super.segments,
    super.cta,
    super.viewsCount,
    super.completionCount,
    super.interactionsCount,
    super.location,
    super.locationCity,
    super.status,
    super.isVerified,
    super.isFlagged,
  });

  /// Depuis Firestore
  factory StoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return StoryModel(
      id: doc.id,
      userId: data['userId'] as String,
      userDisplayName: data['userDisplayName'] as String,
      userPhotoUrl: data['userPhotoUrl'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      type: _storyTypeFromString(data['type'] as String),
      eventId: data['eventId'] as String?,
      eventTitle: data['eventTitle'] as String?,
      ticketId: data['ticketId'] as String?,
      ticketPrice: (data['ticketPrice'] as num?)?.toDouble(),
      ticketCurrency: data['ticketCurrency'] as String? ?? 'XOF',
      segments: (data['segments'] as List<dynamic>)
          .map((s) => _segmentFromMap(s as Map<String, dynamic>))
          .toList(),
      cta: data['cta'] != null
          ? _ctaFromMap(data['cta'] as Map<String, dynamic>)
          : null,
      viewsCount: data['viewsCount'] as int? ?? 0,
      completionCount: data['completionCount'] as int? ?? 0,
      interactionsCount: data['interactionsCount'] as int? ?? 0,
      location: data['location'] as GeoPoint?,
      locationCity: data['locationCity'] as String?,
      status: _statusFromString(data['status'] as String? ?? 'active'),
      isVerified: data['isVerified'] as bool? ?? false,
      isFlagged: data['isFlagged'] as bool? ?? false,
    );
  }

  /// Vers Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userDisplayName': userDisplayName,
      'userPhotoUrl': userPhotoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'type': _storyTypeToString(type),
      'eventId': eventId,
      'eventTitle': eventTitle,
      'ticketId': ticketId,
      'ticketPrice': ticketPrice,
      'ticketCurrency': ticketCurrency,
      'segments': segments.map((s) => _segmentToMap(s)).toList(),
      'cta': cta != null ? _ctaToMap(cta!) : null,
      'viewsCount': viewsCount,
      'completionCount': completionCount,
      'interactionsCount': interactionsCount,
      'location': location,
      'locationCity': locationCity,
      'status': _statusToString(status),
      'isVerified': isVerified,
      'isFlagged': isFlagged,
    };
  }

  // Helpers conversion
  static StoryType _storyTypeFromString(String value) {
    switch (value) {
      case 'standard':
        return StoryType.standard;
      case 'event_promo':
        return StoryType.eventPromo;
      case 'ticket_sale':
        return StoryType.ticketSale;
      default:
        return StoryType.standard;
    }
  }

  static String _storyTypeToString(StoryType type) {
    switch (type) {
      case StoryType.standard:
        return 'standard';
      case StoryType.eventPromo:
        return 'event_promo';
      case StoryType.ticketSale:
        return 'ticket_sale';
    }
  }

  static StoryStatus _statusFromString(String value) {
    switch (value) {
      case 'active':
        return StoryStatus.active;
      case 'expired':
        return StoryStatus.expired;
      case 'deleted':
        return StoryStatus.deleted;
      default:
        return StoryStatus.active;
    }
  }

  static String _statusToString(StoryStatus status) {
    switch (status) {
      case StoryStatus.active:
        return 'active';
      case StoryStatus.expired:
        return 'expired';
      case StoryStatus.deleted:
        return 'deleted';
    }
  }

  static StorySegment _segmentFromMap(Map<String, dynamic> data) {
    return StorySegment(
      id: data['id'] as String,
      type: StorySegmentTypeX.fromString(data['type'] as String),
      mediaUrl: data['mediaUrl'] as String,
      thumbnailUrl: data['thumbnailUrl'] as String?,
      duration: Duration(seconds: data['duration'] as int),
      order: data['order'] as int,
    );
  }

  static Map<String, dynamic> _segmentToMap(StorySegment segment) {
    return {
      'id': segment.id,
      'type': segment.type.toFirestoreString(),
      'mediaUrl': segment.mediaUrl,
      'thumbnailUrl': segment.thumbnailUrl,
      'duration': segment.duration.inSeconds,
      'order': segment.order,
    };
  }

  static StoryCTA _ctaFromMap(Map<String, dynamic> data) {
    return StoryCTA(
      type: StoryCTATypeX.fromString(data['type'] as String),
      text: data['text'] as String,
      targetId: data['targetId'] as String,
    );
  }

  static Map<String, dynamic> _ctaToMap(StoryCTA cta) {
    return {
      'type': cta.type.toFirestoreString(),
      'text': cta.text,
      'targetId': cta.targetId,
    };
  }
}
