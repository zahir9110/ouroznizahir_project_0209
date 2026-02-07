
part of 'feed_bloc.dart';

abstract class FeedState extends Equatable {
  const FeedState();
  
  @override
  List<Object?> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<FeedPost> posts;
  final bool hasReachedMax;
  final FeedFilter? activeFilter;

  const FeedLoaded({
    required this.posts,
    this.hasReachedMax = false,
    this.activeFilter,
  });

  FeedLoaded copyWith({
    List<FeedPost>? posts,
    bool? hasReachedMax,
    FeedFilter? activeFilter,
  }) {
    return FeedLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }

  @override
  List<Object?> get props => [posts, hasReachedMax, activeFilter];
}

class FeedError extends FeedState {
  final String message;

  const FeedError(this.message);

  @override
  List<Object?> get props => [message];
}
