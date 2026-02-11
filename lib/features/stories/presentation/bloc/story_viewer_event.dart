import 'package:equatable/equatable.dart';
import '../../domain/entities/story.dart';

/// Événements BLoC pour le viewer de story
abstract class StoryViewerEvent extends Equatable {
  const StoryViewerEvent();

  @override
  List<Object?> get props => [];
}

/// Initialiser le viewer avec une story
class InitializeStoryViewer extends StoryViewerEvent {
  final Story story;
  final String viewerId;

  const InitializeStoryViewer({
    required this.story,
    required this.viewerId,
  });

  @override
  List<Object?> get props => [story, viewerId];
}

/// Lancer lecture segment
class PlaySegment extends StoryViewerEvent {
  const PlaySegment();
}

/// Mettre en pause
class PauseSegment extends StoryViewerEvent {
  const PauseSegment();
}

/// Segment suivant
class NextSegment extends StoryViewerEvent {
  const NextSegment();
}

/// Segment précédent
class PreviousSegment extends StoryViewerEvent {
  const PreviousSegment();
}

/// Aller à un segment spécifique
class SeekToSegment extends StoryViewerEvent {
  final int index;

  const SeekToSegment(this.index);

  @override
  List<Object?> get props => [index];
}

/// Story terminée
class CompleteStory extends StoryViewerEvent {
  const CompleteStory();
}

/// Enregistrer vue segment
class RecordSegmentView extends StoryViewerEvent {
  final int segmentIndex;

  const RecordSegmentView(this.segmentIndex);

  @override
  List<Object?> get props => [segmentIndex];
}
