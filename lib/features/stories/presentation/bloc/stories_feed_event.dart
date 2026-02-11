import 'package:equatable/equatable.dart';

/// Événements BLoC pour le feed stories
abstract class StoriesFeedEvent extends Equatable {
  const StoriesFeedEvent();

  @override
  List<Object?> get props => [];
}

/// Charger le feed stories
class LoadStoriesFeed extends StoriesFeedEvent {
  final String userId;

  const LoadStoriesFeed(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Rafraîchir le feed
class RefreshStoriesFeed extends StoriesFeedEvent {}
