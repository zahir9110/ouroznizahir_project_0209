import 'package:equatable/equatable.dart';
import '../../domain/entities/story.dart';

/// État du BLoC viewer de story
class StoryViewerState extends Equatable {
  final Story? story;
  final int currentSegmentIndex;
  final bool isPlaying;
  final bool isCompleted;
  final String? viewerId;
  final List<int> viewedSegments;

  const StoryViewerState({
    this.story,
    this.currentSegmentIndex = 0,
    this.isPlaying = false,
    this.isCompleted = false,
    this.viewerId,
    this.viewedSegments = const [],
  });

  StoryViewerState copyWith({
    Story? story,
    int? currentSegmentIndex,
    bool? isPlaying,
    bool? isCompleted,
    String? viewerId,
    List<int>? viewedSegments,
  }) {
    return StoryViewerState(
      story: story ?? this.story,
      currentSegmentIndex: currentSegmentIndex ?? this.currentSegmentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      isCompleted: isCompleted ?? this.isCompleted,
      viewerId: viewerId ?? this.viewerId,
      viewedSegments: viewedSegments ?? this.viewedSegments,
    );
  }

  @override
  List<Object?> get props => [
        story,
        currentSegmentIndex,
        isPlaying,
        isCompleted,
        viewerId,
        viewedSegments,
      ];
}
