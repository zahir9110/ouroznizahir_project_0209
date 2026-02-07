import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_personalized_feed.dart';
import '../../domain/usecases/get_cultural_gems.dart';
import '../../domain/usecases/get_spontaneous_events.dart';
import 'events_feed_event.dart';
import 'events_feed_state.dart';

/// BLoC gérant le feed d'événements enrichis par IA
class EventsFeedBloc extends Bloc<EventsFeedEvent, EventsFeedState> {
  final GetPersonalizedFeed getPersonalizedFeed;
  final GetCulturalGems getCulturalGems;
  final GetSpontaneousEvents getSpontaneousEvents;

  EventsFeedBloc({
    required this.getPersonalizedFeed,
    required this.getCulturalGems,
    required this.getSpontaneousEvents,
  }) : super(const EventsFeedState()) {
    on<LoadPersonalizedFeed>(_onLoadPersonalizedFeed);
    on<LoadCulturalGems>(_onLoadCulturalGems);
    on<LoadSpontaneousEvents>(_onLoadSpontaneousEvents);
    on<RefreshFeed>(_onRefreshFeed);
  }

  /// Charger le feed personnalisé (7 jours à venir)
  Future<void> _onLoadPersonalizedFeed(
    LoadPersonalizedFeed event,
    Emitter<EventsFeedState> emit,
  ) async {
    emit(state.copyWith(status: EventsFeedStatus.loading));

    await emit.forEach(
      getPersonalizedFeed(
        userId: event.userId,
        userLocation: event.userLocation,
      ),
      onData: (result) => result.fold(
        (failure) => state.copyWith(
          status: EventsFeedStatus.failure,
          errorMessage: failure.message,
        ),
        (events) => state.copyWith(
          status: EventsFeedStatus.success,
          personalizedEvents: events,
        ),
      ),
    );
  }

  /// Charger les coups de cœur culturels
  Future<void> _onLoadCulturalGems(
    LoadCulturalGems event,
    Emitter<EventsFeedState> emit,
  ) async {
    await emit.forEach(
      getCulturalGems(event.userId),
      onData: (result) => result.fold(
        (failure) => state.copyWith(errorMessage: failure.message),
        (events) => state.copyWith(culturalGems: events),
      ),
    );
  }

  /// Charger les événements spontanés (aujourd'hui)
  Future<void> _onLoadSpontaneousEvents(
    LoadSpontaneousEvents event,
    Emitter<EventsFeedState> emit,
  ) async {
    await emit.forEach(
      getSpontaneousEvents(event.location),
      onData: (result) => result.fold(
        (failure) => state.copyWith(errorMessage: failure.message),
        (events) => state.copyWith(spontaneousEvents: events),
      ),
    );
  }

  /// Rafraîchir le feed (reset state)
  Future<void> _onRefreshFeed(
    RefreshFeed event,
    Emitter<EventsFeedState> emit,
  ) async {
    emit(state.copyWith(status: EventsFeedStatus.initial));
  }
}
