

part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class FeedStarted extends FeedEvent {}

class FeedRefreshed extends FeedEvent {}

class FeedLoadedMore extends FeedEvent {}

class PostLiked extends FeedEvent {
  final String postId;
  
  const PostLiked(this.postId);
  
  @override
  List<Object?> get props => [postId];
}

class PostUnliked extends FeedEvent {
  final String postId;
  
  const PostUnliked(this.postId);
  
  @override
  List<Object?> get props => [postId];
}

class PostSaved extends FeedEvent {
  final String postId;
  
  const PostSaved(this.postId);
  
  @override
  List<Object?> get props => [postId];
}

class PostShared extends FeedEvent {
  final String postId;
  final String? recipientId;
  
  const PostShared(this.postId, {this.recipientId});
  
  @override
  List<Object?> get props => [postId, recipientId];
}

class FilterChanged extends FeedEvent {
  final FeedFilter filter;
  
  const FilterChanged(this.filter);
  
  @override
  List<Object?> get props => [filter];
}
