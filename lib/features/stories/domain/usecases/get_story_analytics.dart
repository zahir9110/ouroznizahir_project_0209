import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/story_analytics.dart';
import '../repositories/stories_repository.dart';

/// Use case: Récupérer les analytics d'une story
class GetStoryAnalytics {
  final StoriesRepository repository;

  GetStoryAnalytics(this.repository);

  Future<Either<Failure, StoryAnalytics>> call(String storyId) {
    return repository.getStoryAnalytics(storyId);
  }
}
