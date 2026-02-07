import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// ============================================================================
// COLLECTION: feed_posts/{postId}
// ============================================================================

class FeedPost extends Equatable {
  final String id;
  final String authorId;
  final AuthorInfo author;
  final PostContent content;
  final PostContext context;        // Géo + culture
  final Engagement engagement;
  final PostType type;
  final DateTime createdAt;
  final bool isSponsored;
  final List<String> badges;        // ["verified", "cultural_heritage"]

  const FeedPost({
    required this.id,
    required this.authorId,
    required this.author,
    required this.content,
    required this.context,
    required this.engagement,
    required this.type,
    required this.createdAt,
    this.isSponsored = false,
    this.badges = const [],
  });

  @override
  List<Object?> get props => [id, authorId, type, createdAt];

  // Factory from Firestore
  factory FeedPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return FeedPost(
      id: doc.id,
      authorId: data['authorId'] ?? '',
      author: AuthorInfo.fromMap(data['author'] ?? {}),
      content: PostContent.fromMap(data['content'] ?? {}),
      context: PostContext.fromMap(data['context'] ?? {}),
      engagement: Engagement.fromMap(data['engagement'] ?? {}),
      type: PostType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => PostType.experience,
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isSponsored: data['isSponsored'] ?? false,
      badges: List<String>.from(data['badges'] ?? []),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'author': author.toMap(),
      'content': content.toMap(),
      'context': context.toMap(),
      'engagement': engagement.toMap(),
      'type': type.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'isSponsored': isSponsored,
      'badges': badges,
    };
  }

  // Copy with
  FeedPost copyWith({
    String? id,
    String? authorId,
    AuthorInfo? author,
    PostContent? content,
    PostContext? context,
    Engagement? engagement,
    PostType? type,
    DateTime? createdAt,
    bool? isSponsored,
    List<String>? badges,
  }) {
    return FeedPost(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      author: author ?? this.author,
      content: content ?? this.content,
      context: context ?? this.context,
      engagement: engagement ?? this.engagement,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isSponsored: isSponsored ?? this.isSponsored,
      badges: badges ?? this.badges,
    );
  }
}

// ============================================================================
// SOUS-TYPES
// ============================================================================

class AuthorInfo extends Equatable {
  final String name;
  final String avatar;
  final AuthorType type;           // professional, user, official
  final String? commune;
  final bool isVerified;
  final List<String> badges;

  const AuthorInfo({
    required this.name,
    required this.avatar,
    this.type = AuthorType.user,
    this.commune,
    this.isVerified = false,
    this.badges = const [],
  });

  @override
  List<Object?> get props => [name, type, isVerified];

  factory AuthorInfo.fromMap(Map<String, dynamic> map) {
    return AuthorInfo(
      name: map['name'] ?? '',
      avatar: map['avatar'] ?? '',
      type: AuthorType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => AuthorType.user,
      ),
      commune: map['commune'],
      isVerified: map['isVerified'] ?? false,
      badges: List<String>.from(map['badges'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'avatar': avatar,
      'type': type.name,
      'commune': commune,
      'isVerified': isVerified,
      'badges': badges,
    };
  }
}

enum AuthorType {
  professional,    // Compte vérifié (hôtel, guide, etc.)
  user,            // Utilisateur standard
  official,        // Compte institution (OTB, mairie...)
}

class PostContent extends Equatable {
  final String text;
  final List<MediaItem> media;
  final DateTime? eventDate;       // Si événement
  final String? locationName;
  final GeoPoint? coordinates;
  final List<String> mentions;
  final List<String> hashtags;     // #Vodoun #Cotonou #Gastronomie

  const PostContent({
    this.text = '',
    this.media = const [],
    this.eventDate,
    this.locationName,
    this.coordinates,
    this.mentions = const [],
    this.hashtags = const [],
  });

  @override
  List<Object?> get props => [text, media.length, locationName];

  factory PostContent.fromMap(Map<String, dynamic> map) {
    return PostContent(
      text: map['text'] ?? '',
      media: (map['media'] as List?)
          ?.map((m) => MediaItem.fromMap(m))
          .toList() ?? [],
      eventDate: (map['eventDate'] as Timestamp?)?.toDate(),
      locationName: map['locationName'],
      coordinates: map['coordinates'],
      mentions: List<String>.from(map['mentions'] ?? []),
      hashtags: List<String>.from(map['hashtags'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'media': media.map((m) => m.toMap()).toList(),
      'eventDate': eventDate != null ? Timestamp.fromDate(eventDate!) : null,
      'locationName': locationName,
      'coordinates': coordinates,
      'mentions': mentions,
      'hashtags': hashtags,
    };
  }
}

class MediaItem extends Equatable {
  final String id;
  final MediaType type;            // image, video
  final String url;
  final String? thumbnailUrl;      // Pour vidéos
  final double? aspectRatio;       // 9/16, 4/5, etc.
  final int? duration;             // Secondes pour vidéo
  final String? description;

  const MediaItem({
    required this.id,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    this.aspectRatio,
    this.duration,
    this.description,
  });

  @override
  List<Object?> get props => [id, type, url];

  factory MediaItem.fromMap(Map<String, dynamic> map) {
    return MediaItem(
      id: map['id'] ?? '',
      type: MediaType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => MediaType.image,
      ),
      url: map['url'] ?? '',
      thumbnailUrl: map['thumbnailUrl'],
      aspectRatio: map['aspectRatio']?.toDouble(),
      duration: map['duration'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'aspectRatio': aspectRatio,
      'duration': duration,
      'description': description,
    };
  }
}

enum MediaType {
  image,
  video,
}

class PostContext extends Equatable {
  final String commune;            // Pour filtrage rapide
  final String department;
  final List<String> culturalTags; // Auto-extraits par IA
  final double? distanceFromUser;  // Calculé à la volée

  const PostContext({
    required this.commune,
    required this.department,
    this.culturalTags = const [],
    this.distanceFromUser,
  });

  @override
  List<Object?> get props => [commune, department, culturalTags];

  factory PostContext.fromMap(Map<String, dynamic> map) {
    return PostContext(
      commune: map['commune'] ?? '',
      department: map['department'] ?? '',
      culturalTags: List<String>.from(map['culturalTags'] ?? []),
      distanceFromUser: map['distanceFromUser']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commune': commune,
      'department': department,
      'culturalTags': culturalTags,
      'distanceFromUser': distanceFromUser,
    };
  }
}

class Engagement extends Equatable {
  final int likes;
  final int comments;
  final int shares;
  final int saves;
  final int views;
  final bool isLikedByMe;
  final bool isSavedByMe;

  const Engagement({
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.saves = 0,
    this.views = 0,
    this.isLikedByMe = false,
    this.isSavedByMe = false,
  });

  @override
  List<Object?> get props => [likes, comments, shares, saves];

  factory Engagement.fromMap(Map<String, dynamic> map) {
    return Engagement(
      likes: map['likes'] ?? 0,
      comments: map['comments'] ?? 0,
      shares: map['shares'] ?? 0,
      saves: map['saves'] ?? 0,
      views: map['views'] ?? 0,
      isLikedByMe: map['isLikedByMe'] ?? false,
      isSavedByMe: map['isSavedByMe'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'saves': saves,
      'views': views,
      'isLikedByMe': isLikedByMe,
      'isSavedByMe': isSavedByMe,
    };
  }

  // Helpers pour updates locaux
  Engagement copyWith({
    int? likes,
    int? comments,
    int? shares,
    int? saves,
    int? views,
    bool? isLikedByMe,
    bool? isSavedByMe,
  }) {
    return Engagement(
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      saves: saves ?? this.saves,
      views: views ?? this.views,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      isSavedByMe: isSavedByMe ?? this.isSavedByMe,
    );
  }

  Engagement incrementLikes({bool isNowLiked = true}) => copyWith(
    likes: isNowLiked ? likes + 1 : likes - 1,
    isLikedByMe: isNowLiked,
  );
}

enum PostType {
  event,        // Événement daté (festival, concert...)
  experience,   // Expérience touristique (guide, atelier...)
  place,        // Lieu permanent (hôtel, restaurant, site...)
  storyReply,   // Réponse à une story
  moment,       // Publication spontanée utilisateur
  guide,        // Guide/Recommandation
  sponsored,    // Contenu sponsorisé
}

// ============================================================================
// MODÈLES DE REQUÊTE (POUR RÉCUPÉRATION)
// ============================================================================

class FeedQuery {
  final FeedFilter filter;
  final String? lastDocumentId;    // Pagination
  final int limit;                 // 10-20 posts

  const FeedQuery({
    this.filter = const FeedFilter(),
    this.lastDocumentId,
    this.limit = 15,
  });
}

class FeedFilter extends Equatable {
  final String? commune;           // Filtrer par commune
  final String? department;
  final PostType? type;
  final List<String>? hashtags;
  final bool onlyVerified;         // Seulement comptes pros
  final bool onlyEvents;           // Seulement événements futurs
  final GeoPoint? nearLocation;    // Pour tri par distance
  final double? maxDistanceKm;

  const FeedFilter({
    this.commune,
    this.department,
    this.type,
    this.hashtags,
    this.onlyVerified = false,
    this.onlyEvents = false,
    this.nearLocation,
    this.maxDistanceKm,
  });

  @override
  List<Object?> get props => [commune, type, onlyVerified, hashtags];

  bool get hasActiveFilters => 
      commune != null || 
      type != null || 
      hashtags != null ||
      onlyVerified ||
      onlyEvents;

  FeedFilter copyWith({
    String? commune,
    String? department,
    PostType? type,
    List<String>? hashtags,
    bool? onlyVerified,
    bool? onlyEvents,
    GeoPoint? nearLocation,
    double? maxDistanceKm,
  }) {
    return FeedFilter(
      commune: commune ?? this.commune,
      department: department ?? this.department,
      type: type ?? this.type,
      hashtags: hashtags ?? this.hashtags,
      onlyVerified: onlyVerified ?? this.onlyVerified,
      onlyEvents: onlyEvents ?? this.onlyEvents,
      nearLocation: nearLocation ?? this.nearLocation,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
    );
  }

  Map<String, dynamic> toFirestoreQuery() {
    final conditions = <Map<String, dynamic>>[];
    
    if (commune != null) {
      conditions.add({
        'field': 'context.commune',
        'operator': '==',
        'value': commune,
      });
    }
    
    if (department != null) {
      conditions.add({
        'field': 'context.department',
        'operator': '==',
        'value': department,
      });
    }
    
    if (type != null) {
      conditions.add({
        'field': 'type',
        'operator': '==',
        'value': type!.name,
      });
    }
    
    if (onlyEvents) {
      conditions.add({
        'field': 'content.eventDate',
        'operator': '>=',
        'value': Timestamp.now(),
      });
    }
    
    return {
      'conditions': conditions,
      'limit': 15,
      'orderBy': 'createdAt',
      'descending': true,
    };
  }
}
