import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/story.dart';
import '../../domain/entities/story_analytics.dart';
import '../../domain/entities/story_cta.dart';
import '../../domain/repositories/stories_repository.dart';
import '../datasources/stories_remote_datasource.dart';

class StoriesRepositoryImpl implements StoriesRepository {
  final StoriesRemoteDataSource remoteDataSource;

  StoriesRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<Either<Failure, List<Story>>> getFollowingStories(
    String userId,
  ) async* {
    try {
      await for (final stories in remoteDataSource.getFollowingStories(userId)) {
        yield Right(stories);
      }
    } on ServerException catch (e) {
      yield Left(ServerFailure(e.message));
    } catch (e) {
      yield Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Story>>> getUserStories(String userId) async {
    try {
      final stories = await remoteDataSource.getUserStories(userId);
      return Right(stories);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Story>> getStoryById(String storyId) async {
    try {
      final story = await remoteDataSource.getStoryById(storyId);
      return Right(story);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createStory({
    required String userId,
    required List<StorySegmentUpload> segments,
    required StoryType type,
    String? eventId,
    String? ticketId,
    StoryCTA? cta,
  }) async {
    try {
      final storyId = await remoteDataSource.createStory(
        userId: userId,
        segments: segments,
        type: type,
        eventId: eventId,
        ticketId: ticketId,
        cta: cta,
      );
      return Right(storyId);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> recordView({
    required String storyId,
    required String viewerId,
    required int segmentIndex,
    required bool completed,
  }) async {
    try {
      await remoteDataSource.recordView(
        storyId: storyId,
        viewerId: viewerId,
        segmentIndex: segmentIndex,
        completed: completed,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> recordInteraction({
    required String storyId,
    required String userId,
    required StoryCTAType ctaType,
  }) async {
    try {
      await remoteDataSource.recordInteraction(
        storyId: storyId,
        userId: userId,
        ctaType: ctaType,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStory(
    String storyId,
    String userId,
  ) async {
    try {
      await remoteDataSource.deleteStory(storyId, userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, StoryAnalytics>> getStoryAnalytics(
    String storyId,
  ) async {
    // TODO: Implémenter récupération analytics depuis viewers subcollection
    return const Left(
      ServerFailure('Analytics non implémentés - Phase 2'),
    );
  }

  @override
  Stream<Either<Failure, List<Story>>> getActiveStoriesNearby({
    required GeoPoint location,
    double radiusKm = 50,
  }) async* {
    try {
      await for (final stories in remoteDataSource.getActiveStoriesNearby(
        location: location,
        radiusKm: radiusKm,
      )) {
        yield Right(stories);
      }
    } on ServerException catch (e) {
      yield Left(ServerFailure(e.message));
    } catch (e) {
      yield Left(UnexpectedFailure(e.toString()));
    }
  }
}
