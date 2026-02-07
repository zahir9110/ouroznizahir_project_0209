import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Événements BLoC pour le feed d'événements enrichis
abstract class EventsFeedEvent extends Equatable {
  const EventsFeedEvent();

  @override
  List<Object?> get props => [];
}

/// Charger le feed personnalisé basé sur géoloc + profil
class LoadPersonalizedFeed extends EventsFeedEvent {
  final String userId;
  final GeoPoint userLocation;

  const LoadPersonalizedFeed({
    required this.userId,
    required this.userLocation,
  });

  @override
  List<Object?> get props => [userId, userLocation];
}

/// Charger les coups de cœur culturels (score IA > 80)
class LoadCulturalGems extends EventsFeedEvent {
  final String userId;

  const LoadCulturalGems(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Charger les événements spontanés (aujourd'hui + proximité)
class LoadSpontaneousEvents extends EventsFeedEvent {
  final GeoPoint location;

  const LoadSpontaneousEvents(this.location);

  @override
  List<Object?> get props => [location];
}

/// Rafraîchir le feed (pull-to-refresh)
class RefreshFeed extends EventsFeedEvent {}
