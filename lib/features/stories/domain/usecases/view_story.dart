import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/stories_repository.dart';

/// Use case: Enregistrer une vue de story
class ViewStory {
  final StoriesRepository repository;

  ViewStory(this.repository);

  Future<Either<Failure, void>> call(ViewStoryParams params) async {
    return repository.recordView(
      storyId: params.storyId,
      viewerId: params.viewerId,
      segmentIndex: params.segmentIndex,
      completed: params.completed,
    );
  }
}

/// Paramètres vue story
class ViewStoryParams {
  final String storyId;
  final String viewerId;
  final int segmentIndex;
  final bool completed;

  const ViewStoryParams({
    required this.storyId,
    required this.viewerId,
    required this.segmentIndex,
    this.completed = false,
  });
}
