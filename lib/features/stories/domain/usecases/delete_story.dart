import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/stories_repository.dart';

/// Use case: Supprimer une story
class DeleteStory {
  final StoriesRepository repository;

  DeleteStory(this.repository);

  Future<Either<Failure, void>> call({
    required String storyId,
    required String userId,
  }) {
    return repository.deleteStory(storyId, userId);
  }
}
