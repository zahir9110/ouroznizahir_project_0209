import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/enriched_event.dart';
import '../repositories/events_repository.dart';

class GetCulturalGems {
  final EventsRepository repository;

  GetCulturalGems(this.repository);

  Stream<Either<Failure, List<EnrichedEvent>>> call(String userId) {
    return repository.getCulturalGems(userId);
  }
}
