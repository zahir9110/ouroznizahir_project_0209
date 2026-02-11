import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/view_story.dart';
import 'story_viewer_event.dart';
import 'story_viewer_state.dart';

/// BLoC gérant la navigation entre segments d'une story
class StoryViewerBloc extends Bloc<StoryViewerEvent, StoryViewerState> {
  final ViewStory viewStory;
  Timer? _segmentTimer;

  StoryViewerBloc({
    required this.viewStory,
  }) : super(const StoryViewerState()) {
    on<InitializeStoryViewer>(_onInitialize);
    on<PlaySegment>(_onPlaySegment);
    on<PauseSegment>(_onPauseSegment);
    on<NextSegment>(_onNextSegment);
    on<PreviousSegment>(_onPreviousSegment);
    on<SeekToSegment>(_onSeekToSegment);
    on<CompleteStory>(_onCompleteStory);
    on<RecordSegmentView>(_onRecordSegmentView);
  }

  /// Initialiser le viewer avec une story
  void _onInitialize(
    InitializeStoryViewer event,
    Emitter<StoryViewerState> emit,
  ) {
    emit(StoryViewerState(
      story: event.story,
      currentSegmentIndex: 0,
      isPlaying: true,
      viewerId: event.viewerId,
    ));

    // Démarrer lecture automatique
    add(const PlaySegment());
  }

  /// Lancer lecture segment
  void _onPlaySegment(
    PlaySegment event,
    Emitter<StoryViewerState> emit,
  ) {
    if (state.story == null) return;

    final currentSegment =
        state.story!.segments[state.currentSegmentIndex];

    emit(state.copyWith(isPlaying: true));

    // Timer auto-avance
    _segmentTimer?.cancel();
    _segmentTimer = Timer(currentSegment.duration, () {
      add(const NextSegment());
    });

    // Enregistrer vue
    add(RecordSegmentView(state.currentSegmentIndex));
  }

  /// Pause segment
  void _onPauseSegment(
    PauseSegment event,
    Emitter<StoryViewerState> emit,
  ) {
    _segmentTimer?.cancel();
    emit(state.copyWith(isPlaying: false));
  }

  /// Segment suivant
  void _onNextSegment(
    NextSegment event,
    Emitter<StoryViewerState> emit,
  ) async {
    if (state.story == null) return;

    _segmentTimer?.cancel();

    final nextIndex = state.currentSegmentIndex + 1;

    if (nextIndex >= state.story!.segments.length) {
      // Fin de la story
      add(const CompleteStory());
      return;
    }

    emit(state.copyWith(currentSegmentIndex: nextIndex));
    add(const PlaySegment());
  }

  /// Segment précédent
  void _onPreviousSegment(
    PreviousSegment event,
    Emitter<StoryViewerState> emit,
  ) {
    if (state.story == null || state.currentSegmentIndex == 0) return;

    _segmentTimer?.cancel();

    final prevIndex = state.currentSegmentIndex - 1;
    emit(state.copyWith(currentSegmentIndex: prevIndex));
    add(const PlaySegment());
  }

  /// Aller à un segment spécifique
  void _onSeekToSegment(
    SeekToSegment event,
    Emitter<StoryViewerState> emit,
  ) {
    if (state.story == null ||
        event.index < 0 ||
        event.index >= state.story!.segments.length) {
      return;
    }

    _segmentTimer?.cancel();
    emit(state.copyWith(currentSegmentIndex: event.index));
    add(const PlaySegment());
  }

  /// Story terminée
  void _onCompleteStory(
    CompleteStory event,
    Emitter<StoryViewerState> emit,
  ) async {
    _segmentTimer?.cancel();
    emit(state.copyWith(isCompleted: true, isPlaying: false));

    // Enregistrer complétion
    if (state.story != null && state.viewerId != null) {
      await viewStory(ViewStoryParams(
        storyId: state.story!.id,
        viewerId: state.viewerId!,
        segmentIndex: state.currentSegmentIndex,
        completed: true,
      ));
    }
  }

  /// Enregistrer vue segment
  Future<void> _onRecordSegmentView(
    RecordSegmentView event,
    Emitter<StoryViewerState> emit,
  ) async {
    if (state.story == null || state.viewerId == null) return;

    final viewedSegments = Set<int>.from(state.viewedSegments);
    viewedSegments.add(event.segmentIndex);

    emit(state.copyWith(viewedSegments: viewedSegments.toList()));

    // Enregistrer dans Firestore
    await viewStory(ViewStoryParams(
      storyId: state.story!.id,
      viewerId: state.viewerId!,
      segmentIndex: event.segmentIndex,
      completed: false,
    ));
  }

  @override
  Future<void> close() {
    _segmentTimer?.cancel();
    return super.close();
  }
}
