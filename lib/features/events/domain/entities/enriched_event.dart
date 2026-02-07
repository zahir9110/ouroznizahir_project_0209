import 'dart:math' as math;
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ai_enrichment.dart';

/// Événement enrichi par IA avec données géolocalisées
class EnrichedEvent extends Equatable {
  final String id;
  final String rawTitle;
  final String rawDescription;
  final DateTime startDate;
  final DateTime endDate;
  final GeoPoint location;
  final String locationCity;

/// Formule Haversine pour distance géo
double _calculateDistance(GeoPoint a, GeoPoint b) {
  const double earthRadiusKm = 6371;
  final dLat = _toRadians(b.latitude - a.latitude);
  final dLon = _toRadians(b.longitude - a.longitude);
    
  final lat1 = _toRadians(a.latitude);
  final lat2 = _toRadians(b.latitude);
    
  final a1 = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.sin(dLon / 2) * math.sin(dLon / 2) * math.cos(lat1) * math.cos(lat2);
  final c = 2 * math.asin(math.sqrt(a1));
    
  return earthRadiusKm * c;
  }

  double _toRadians(double degrees) => degrees * (math.pi / 180);

  /// Source: 'allevents', 'user_submitted', 'scraping'
  final String source;

  /// Données enrichissement IA
  final AIEnrichment aiData;

  /// État fraîcheur: live, curated, expired, archived
  final EventFreshness freshness;

  final DateTime lastUpdated;
  final DateTime createdAt;

  const EnrichedEvent({
    required this.id,
    required this.rawTitle,
    required this.rawDescription,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.locationCity,
    required this.source,
    required this.aiData,
    this.freshness = EventFreshness.live,
    required this.lastUpdated,
    required this.createdAt,
  });

  /// Calcul du score de pertinence personnalisé
  /// Basé sur: distance (30%), intérêts (40%), fraîcheur (20%), qualité IA (10%)
  double calculateRelevanceScore(UserProfile user) {
    double score = 0;

    // 1. Distance géographique (30%)
    final distanceKm = _calculateDistance(user.location, location);
    final geoScore = distanceKm < 5 ? 1.0 : (50 / distanceKm).clamp(0, 1);
    score += geoScore * 0.3;

    // 2. Matching intérêts utilisateur (40%)
    final interestMatches =
        aiData.culturalTags.where((tag) => user.interests.contains(tag)).length;
    final interestScore = aiData.culturalTags.isEmpty
        ? 0.5
        : interestMatches / aiData.culturalTags.length;
    score += interestScore * 0.4;

    // 3. Fraîcheur/contemporain (20%)
    final daysUntilEvent = startDate.difference(DateTime.now()).inDays;
    final freshnessScore = daysUntilEvent <= 7 ? 1.0 : 0.5;
    score += freshnessScore * 0.2;

    // 4. Qualité IA (10%)
    score += (aiData.attractivenessScore / 100) * 0.1;

    return score;
  }

  @override
  List<Object?> get props => [
        id,
        rawTitle,
        startDate,
        endDate,
        location,
        freshness,
        lastUpdated,
      ];
}

enum EventFreshness { live, curated, expired, archived }

/// Profil utilisateur (placeholder - à implémenter dans lib/features/profile/)
class UserProfile {
  final String id;
  final GeoPoint location;
  final List<String> interests;
  final String language;

  UserProfile({
    required this.id,
    required this.location,
    required this.interests,
    this.language = 'fr',
  });
}
