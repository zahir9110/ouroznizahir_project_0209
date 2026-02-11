import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:benin_experience/features/stories/domain/entities/story.dart';
import 'package:benin_experience/features/stories/domain/entities/story_segment.dart';
import 'package:benin_experience/features/stories/domain/repositories/stories_repository.dart';
import 'package:benin_experience/features/stories/domain/usecases/get_following_stories.dart';
import 'package:benin_experience/core/error/failures.dart';

// Mock repository
class MockStoriesRepository extends Mock implements StoriesRepository {}

void main() {
  late GetFollowingStories usecase;
  late MockStoriesRepository mockRepository;

  setUp(() {
    mockRepository = MockStoriesRepository();
    usecase = GetFollowingStories(mockRepository);
  });

  const testUserId = 'test_user_123';
  
  final testStory = Story(
    id: 'story_1',
    userId: 'user_456',
    userDisplayName: 'John Doe',
    userPhotoUrl: 'https://example.com/photo.jpg',
    createdAt: DateTime(2026, 2, 8, 10, 0),
    expiresAt: DateTime(2026, 2, 9, 10, 0),
    type: StoryType.standard,
    segments: const [
      StorySegment(
        id: 'seg_1',
        type: StorySegmentType.image,
        mediaUrl: 'https://example.com/image.jpg',
        duration: Duration(seconds: 5),
        order: 0,
      ),
    ],
  );

  group('GetFollowingStories', () {
    test('devrait retourner une liste de stories depuis le repository', () async {
      // arrange
      when(() => mockRepository.getFollowingStories(testUserId))
          .thenAnswer((_) => Stream.value(Right([testStory])));

      // act
      final result = usecase(testUserId);

      // assert
      await expectLater(
        result,
        emits(Right<Failure, List<Story>>([testStory])),
      );
      verify(() => mockRepository.getFollowingStories(testUserId)).called(1);
    });

    test('devrait retourner ServerFailure en cas d\'erreur serveur', () async {
      // arrange
      const failure = ServerFailure('Erreur connexion');
      when(() => mockRepository.getFollowingStories(testUserId))
          .thenAnswer((_) => Stream.value(const Left(failure)));

      // act
      final result = usecase(testUserId);

      // assert
      await expectLater(
        result,
        emits(const Left<Failure, List<Story>>(failure)),
      );
    });

    test('devrait filtrer les stories expirées', () {
      // arrange
      final expiredStory = Story(
        id: 'expired_story',
        userId: 'user_123',
        userDisplayName: 'User',
        userPhotoUrl: '',
        createdAt: DateTime(2026, 2, 7, 10, 0),
        expiresAt: DateTime(2026, 2, 7, 11, 0), // Expirée
        type: StoryType.standard,
        segments: const [],
      );

      // assert
      expect(expiredStory.isExpired, true);
      expect(testStory.isExpired, false);
    });
  });

  group('Story Entity', () {
    test('devrait calculer correctement la durée totale', () {
      final story = Story(
        id: 'story_1',
        userId: 'user_1',
        userDisplayName: 'User',
        userPhotoUrl: '',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
        type: StoryType.standard,
        segments: const [
          StorySegment(
            id: 's1',
            type: StorySegmentType.image,
            mediaUrl: 'url1',
            duration: Duration(seconds: 5),
            order: 0,
          ),
          StorySegment(
            id: 's2',
            type: StorySegmentType.video,
            mediaUrl: 'url2',
            duration: Duration(seconds: 15),
            order: 1,
          ),
        ],
      );

      expect(story.totalDuration, const Duration(seconds: 20));
    });

    test('devrait calculer le taux de complétion correctement', () {
      final story = Story(
        id: 'story_1',
        userId: 'user_1',
        userDisplayName: 'User',
        userPhotoUrl: '',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
        type: StoryType.standard,
        segments: const [],
        viewsCount: 100,
        completionCount: 75,
      );

      expect(story.completionRate, 75.0);
    });

    test('devrait calculer le taux d\'interaction correctement', () {
      final story = Story(
        id: 'story_1',
        userId: 'user_1',
        userDisplayName: 'User',
        userPhotoUrl: '',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
        type: StoryType.standard,
        segments: const [],
        viewsCount: 200,
        interactionsCount: 50,
      );

      expect(story.interactionRate, 25.0);
    });
  });
}
