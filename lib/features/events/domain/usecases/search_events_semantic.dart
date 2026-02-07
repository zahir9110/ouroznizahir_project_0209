import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/failures.dart';
import '../entities/enriched_event.dart';
import '../repositories/events_repository.dart';

class SearchEventsSemantic {
  final EventsRepository repository;

  SearchEventsSemantic(this.repository);

  Future<Either<Failure, List<EnrichedEvent>>> call(
    String query,
    GeoPoint? userLocation,
  ) {
    return repository.searchEventsSemantic(query, userLocation);
  }
}
