import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/story.dart';
import '../repositories/stories_repository.dart';

/// Use case: Récupérer les stories des comptes suivis
class GetFollowingStories {
  final StoriesRepository repository;

  GetFollowingStories(this.repository);

  Stream<Either<Failure, List<Story>>> call(String userId) {
    return repository.getFollowingStories(userId);
  }
}
