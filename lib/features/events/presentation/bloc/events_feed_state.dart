import 'package:equatable/equatable.dart';
import '../../domain/entities/enriched_event.dart';

/// Status du chargement du feed
enum EventsFeedStatus { initial, loading, success, failure }

/// État du BLoC feed événements
class EventsFeedState extends Equatable {
  final EventsFeedStatus status;
  final List<EnrichedEvent> personalizedEvents;
  final List<EnrichedEvent> culturalGems;
  final List<EnrichedEvent> spontaneousEvents;
  final String? errorMessage;

  const EventsFeedState({
    this.status = EventsFeedStatus.initial,
    this.personalizedEvents = const [],
    this.culturalGems = const [],
    this.spontaneousEvents = const [],
    this.errorMessage,
  });

  EventsFeedState copyWith({
    EventsFeedStatus? status,
    List<EnrichedEvent>? personalizedEvents,
    List<EnrichedEvent>? culturalGems,
    List<EnrichedEvent>? spontaneousEvents,
    String? errorMessage,
  }) {
    return EventsFeedState(
      status: status ?? this.status,
      personalizedEvents: personalizedEvents ?? this.personalizedEvents,
      culturalGems: culturalGems ?? this.culturalGems,
      spontaneousEvents: spontaneousEvents ?? this.spontaneousEvents,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        personalizedEvents,
        culturalGems,
        spontaneousEvents,
        errorMessage,
      ];
}
