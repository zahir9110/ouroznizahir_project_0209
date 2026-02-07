import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/failures.dart';
import '../entities/enriched_event.dart';

/// Contract abstrait du repository événements
/// Implémenté dans la data layer
abstract class EventsRepository {
  /// Feed personnalisé basé sur géoloc + intérêts
  Stream<Either<Failure, List<EnrichedEvent>>> getPersonalizedFeed({
    required String userId,
    required GeoPoint userLocation,
    int limit = 20,
  });

  /// Événements haute valeur culturelle (score IA > 80)
  Stream<Either<Failure, List<EnrichedEvent>>> getCulturalGems(String userId);

  /// Événements spontanés (aujourd'hui + proximité)
  Stream<Either<Failure, List<EnrichedEvent>>> getSpontaneousEvents(
    GeoPoint location,
  );

  /// Recherche sémantique (vector search - phase future)
  Future<Either<Failure, List<EnrichedEvent>>> searchEventsSemantic(
    String query,
    GeoPoint? userLocation,
  );

  /// Détail événement par ID
  Future<Either<Failure, EnrichedEvent>> getEventById(String eventId);
}
