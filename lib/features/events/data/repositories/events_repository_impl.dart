import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/enriched_event.dart';
import '../../domain/repositories/events_repository.dart';
import '../datasources/events_remote_datasource.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDataSource remoteDataSource;

  EventsRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<Either<Failure, List<EnrichedEvent>>> getPersonalizedFeed({
    required String userId,
    required GeoPoint userLocation,
    int limit = 20,
  }) async* {
    try {
      await for (final events in remoteDataSource.getPersonalizedFeed(
        userId: userId,
        userLocation: userLocation,
        limit: limit,
      )) {
        yield Right(events);
      }
    } on ServerException catch (e) {
      yield Left(ServerFailure(e.message));
    } catch (e) {
      yield Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<EnrichedEvent>>> getCulturalGems(
    String userId,
  ) async* {
    try {
      await for (final events in remoteDataSource.getCulturalGems()) {
        yield Right(events);
      }
    } on ServerException catch (e) {
      yield Left(ServerFailure(e.message));
    } catch (e) {
      yield Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<EnrichedEvent>>> getSpontaneousEvents(
    GeoPoint location,
  ) async* {
    try {
      await for (final events
          in remoteDataSource.getSpontaneousEvents(location)) {
        yield Right(events);
      }
    } on ServerException catch (e) {
      yield Left(ServerFailure(e.message));
    } catch (e) {
      yield Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EnrichedEvent>>> searchEventsSemantic(
    String query,
    GeoPoint? userLocation,
  ) async {
    // TODO: Phase 2 - Implémenter avec Algolia
    return const Left(ServerFailure('Recherche sémantique non implémentée'));
  }

  @override
  Future<Either<Failure, EnrichedEvent>> getEventById(String eventId) async {
    try {
      final event = await remoteDataSource.getEventById(eventId);
      return Right(event);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
