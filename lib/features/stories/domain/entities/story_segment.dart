import 'package:equatable/equatable.dart';

/// Segment d'une story (photo ou vidéo)
class StorySegment extends Equatable {
  final String id;
  final StorySegmentType type;
  final String mediaUrl;
  final String? thumbnailUrl;
  final Duration duration;
  final int order;

  const StorySegment({
    required this.id,
    required this.type,
    required this.mediaUrl,
    this.thumbnailUrl,
    required this.duration,
    required this.order,
  });

  @override
  List<Object?> get props => [id, type, mediaUrl, order];
}

/// Type de segment
enum StorySegmentType {
  image,
  video,
}

/// Extension pour conversion facile
extension StorySegmentTypeX on StorySegmentType {
  String toFirestoreString() {
    switch (this) {
      case StorySegmentType.image:
        return 'image';
      case StorySegmentType.video:
        return 'video';
    }
  }

  static StorySegmentType fromString(String value) {
    switch (value) {
      case 'image':
        return StorySegmentType.image;
      case 'video':
        return StorySegmentType.video;
      default:
        return StorySegmentType.image;
    }
  }
}
