
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum StoryType { image, video }

class StoryModel extends Equatable {
  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final bool isProfessional;
  final StoryType type;
  final String mediaUrl;
  final String? thumbnailUrl;
  final String? caption;
  final String? locationName;
  final GeoPoint? coordinates;
  final DateTime createdAt;
  final DateTime expiresAt;
  final List<String> viewedBy;
  final int viewCount;

  const StoryModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    this.isProfessional = false,
    required this.type,
    required this.mediaUrl,
    this.thumbnailUrl,
    this.caption,
    this.locationName,
    this.coordinates,
    required this.createdAt,
    required this.expiresAt,
    this.viewedBy = const [],
    this.viewCount = 0,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  
  Duration get remainingTime => expiresAt.difference(DateTime.now());

  @override
  List<Object?> get props => [id, authorId, mediaUrl, createdAt];

  factory StoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StoryModel(
      id: doc.id,
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      authorAvatar: data['authorAvatar'] ?? '',
      isProfessional: data['isProfessional'] ?? false,
      type: StoryType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => StoryType.image,
      ),
      mediaUrl: data['mediaUrl'] ?? '',
      thumbnailUrl: data['thumbnailUrl'],
      caption: data['caption'],
      locationName: data['locationName'],
      coordinates: data['coordinates'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      viewedBy: List<String>.from(data['viewedBy'] ?? []),
      viewCount: data['viewCount'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'isProfessional': isProfessional,
      'type': type.name,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
      'caption': caption,
      'locationName': locationName,
      'coordinates': coordinates,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'viewedBy': viewedBy,
      'viewCount': viewCount,
    };
  }
}