import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'story_segment.dart';
import 'story_cta.dart';

/// Entité Story - Version domain pure
class Story extends Equatable {
  final String id;
  final String userId;
  final String userDisplayName;
  final String userPhotoUrl;
  final DateTime createdAt;
  final DateTime expiresAt;
  
  /// Type de story
  final StoryType type;
  
  /// Liens optionnels
  final String? eventId;
  final String? eventTitle;
  final String? ticketId;
  final double? ticketPrice;
  final String ticketCurrency;
  
  /// Segments (photos/vidéos)
  final List<StorySegment> segments;
  
  /// Call-to-Action optionnel
  final StoryCTA? cta;
  
  /// Analytics
  final int viewsCount;
  final int completionCount;
  final int interactionsCount;
  
  /// Géolocalisation
  final GeoPoint? location;
  final String? locationCity;
  
  /// Statut
  final StoryStatus status;
  
  /// Sécurité
  final bool isVerified;
  final bool isFlagged;

  const Story({
    required this.id,
    required this.userId,
    required this.userDisplayName,
    required this.userPhotoUrl,
    required this.createdAt,
    required this.expiresAt,
    required this.type,
    this.eventId,
    this.eventTitle,
    this.ticketId,
    this.ticketPrice,
    this.ticketCurrency = 'XOF',
    required this.segments,
    this.cta,
    this.viewsCount = 0,
    this.completionCount = 0,
    this.interactionsCount = 0,
    this.location,
    this.locationCity,
    this.status = StoryStatus.active,
    this.isVerified = false,
    this.isFlagged = false,
  });

  /// Durée totale de la story (somme des segments)
  Duration get totalDuration {
    return segments.fold(
      Duration.zero,
      (total, segment) => total + segment.duration,
    );
  }

  /// Vérifier si la story est expirée
  bool get isExpired {
    return DateTime.now().isAfter(expiresAt) || status == StoryStatus.expired;
  }

  /// Temps restant avant expiration
  Duration get timeRemaining {
    if (isExpired) return Duration.zero;
    return expiresAt.difference(DateTime.now());
  }

  /// Taux de complétion (% de viewers allant jusqu'au bout)
  double get completionRate {
    if (viewsCount == 0) return 0.0;
    return (completionCount / viewsCount) * 100;
  }

  /// Taux d'interaction (% de viewers cliquant CTA)
  double get interactionRate {
    if (viewsCount == 0) return 0.0;
    return (interactionsCount / viewsCount) * 100;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        createdAt,
        expiresAt,
        type,
        segments,
        viewsCount,
        status,
      ];
}

/// Type de story
enum StoryType {
  standard,      // Story classique (photo/vidéo)
  eventPromo,    // Promotion d'événement
  ticketSale,    // Vente de billet
}

/// Statut story
enum StoryStatus {
  active,   // Visible et non expirée
  expired,  // Expirée (>24h)
  deleted,  // Supprimée par l'utilisateur
}
