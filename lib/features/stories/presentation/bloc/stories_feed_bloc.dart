import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/story.dart';
import '../../domain/usecases/get_following_stories.dart';
import 'stories_feed_event.dart';
import 'stories_feed_state.dart';

/// BLoC gérant le feed de stories (barre horizontale)
class StoriesFeedBloc extends Bloc<StoriesFeedEvent, StoriesFeedState> {
  final GetFollowingStories getFollowingStories;

  StoriesFeedBloc({
    required this.getFollowingStories,
  }) : super(const StoriesFeedState()) {
    on<LoadStoriesFeed>(_onLoadStoriesFeed);
    on<RefreshStoriesFeed>(_onRefreshStoriesFeed);
  }

  /// Charger le feed stories des comptes suivis
  Future<void> _onLoadStoriesFeed(
    LoadStoriesFeed event,
    Emitter<StoriesFeedState> emit,
  ) async {
    emit(state.copyWith(status: StoriesFeedStatus.loading));

    await emit.forEach(
      getFollowingStories(event.userId),
      onData: (result) => result.fold(
        (failure) => state.copyWith(
          status: StoriesFeedStatus.failure,
          errorMessage: failure.message,
        ),
        (stories) {
          // Grouper par utilisateur + trier par non vues
          final groupedStories = _groupStoriesByUser(stories);
          
          return state.copyWith(
            status: StoriesFeedStatus.success,
            allStories: stories,
            groupedStories: groupedStories,
          );
        },
      ),
    );
  }

  /// Rafraîchir le feed
  Future<void> _onRefreshStoriesFeed(
    RefreshStoriesFeed event,
    Emitter<StoriesFeedState> emit,
  ) async {
    emit(const StoriesFeedState());
  }

  /// Grouper stories par utilisateur (pour affichage cercles)
  Map<String, List<Story>> _groupStoriesByUser(List<Story> stories) {
    final Map<String, List<Story>> grouped = {};

    for (final story in stories) {
      if (!grouped.containsKey(story.userId)) {
        grouped[story.userId] = [];
      }
      grouped[story.userId]!.add(story);
    }

    // Trier chaque groupe par date
    for (final entry in grouped.entries) {
      entry.value.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    return grouped;
  }
}
