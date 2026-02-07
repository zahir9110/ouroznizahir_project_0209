import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/failures.dart';
import '../entities/enriched_event.dart';
import '../repositories/events_repository.dart';

class GetPersonalizedFeed {
  final EventsRepository repository;

  GetPersonalizedFeed(this.repository);

  Stream<Either<Failure, List<EnrichedEvent>>> call({
    required String userId,
    required GeoPoint userLocation,
    int limit = 20,
  }) {
    return repository.getPersonalizedFeed(
      userId: userId,
      userLocation: userLocation,
      limit: limit,
    );
  }
}
