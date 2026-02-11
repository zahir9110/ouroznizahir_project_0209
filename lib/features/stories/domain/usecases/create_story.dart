import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/story.dart';
import '../entities/story_cta.dart';
import '../repositories/stories_repository.dart';

/// Use case: Créer une nouvelle story
class CreateStory {
  final StoriesRepository repository;

  CreateStory(this.repository);

  Future<Either<Failure, String>> call(CreateStoryParams params) async {
    // Validation
    if (params.segments.isEmpty) {
      return const Left(ValidationFailure('Au moins un segment requis'));
    }

    if (params.segments.length > 10) {
      return const Left(ValidationFailure('Maximum 10 segments par story'));
    }

    // Validation type spécifique
    if (params.type == StoryType.ticketSale && params.ticketId == null) {
      return const Left(
        ValidationFailure('ticketId requis pour story vente billet'),
      );
    }

    if (params.type == StoryType.eventPromo && params.eventId == null) {
      return const Left(
        ValidationFailure('eventId requis pour story promo événement'),
      );
    }

    return repository.createStory(
      userId: params.userId,
      segments: params.segments,
      type: params.type,
      eventId: params.eventId,
      ticketId: params.ticketId,
      cta: params.cta,
    );
  }
}

/// Paramètres création story
class CreateStoryParams {
  final String userId;
  final List<StorySegmentUpload> segments;
  final StoryType type;
  final String? eventId;
  final String? ticketId;
  final StoryCTA? cta;

  const CreateStoryParams({
    required this.userId,
    required this.segments,
    this.type = StoryType.standard,
    this.eventId,
    this.ticketId,
    this.cta,
  });
}
