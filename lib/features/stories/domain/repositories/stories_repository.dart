import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/failures.dart';
import '../entities/story.dart';
import '../entities/story_segment.dart';
import '../entities/story_cta.dart';
import '../entities/story_analytics.dart';

/// Contract abstrait du repository stories
abstract class StoriesRepository {
  /// Récupérer les stories actives des utilisateurs suivis
  Stream<Either<Failure, List<Story>>> getFollowingStories(String userId);

  /// Récupérer les stories d'un utilisateur spécifique
  Future<Either<Failure, List<Story>>> getUserStories(String userId);

  /// Récupérer une story par ID
  Future<Either<Failure, Story>> getStoryById(String storyId);

  /// Créer une nouvelle story
  Future<Either<Failure, String>> createStory({
    required String userId,
    required List<StorySegmentUpload> segments,
    required StoryType type,
    String? eventId,
    String? ticketId,
    StoryCTA? cta,
  });

  /// Enregistrer une vue de story
  Future<Either<Failure, void>> recordView({
    required String storyId,
    required String viewerId,
    required int segmentIndex,
    required bool completed,
  });

  /// Enregistrer une interaction CTA
  Future<Either<Failure, void>> recordInteraction({
    required String storyId,
    required String userId,
    required StoryCTAType ctaType,
  });

  /// Supprimer une story
  Future<Either<Failure, void>> deleteStory(String storyId, String userId);

  /// Récupérer les analytics d'une story
  Future<Either<Failure, StoryAnalytics>> getStoryAnalytics(String storyId);

  /// Récupérer toutes les stories actives (discovery)
  Stream<Either<Failure, List<Story>>> getActiveStoriesNearby({
    required GeoPoint location,
    double radiusKm = 50,
  });
}

/// Helper pour upload de segment
class StorySegmentUpload {
  final String localPath;
  final StorySegmentType type;
  final Duration duration;

  const StorySegmentUpload({
    required this.localPath,
    required this.type,
    required this.duration,
  });
}
