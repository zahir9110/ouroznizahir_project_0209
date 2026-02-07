import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/failures.dart';
import '../entities/enriched_event.dart';
import '../repositories/events_repository.dart';

class GetSpontaneousEvents {
  final EventsRepository repository;

  GetSpontaneousEvents(this.repository);

  Stream<Either<Failure, List<EnrichedEvent>>> call(GeoPoint location) {
    return repository.getSpontaneousEvents(location);
  }
}
