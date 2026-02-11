import 'package:equatable/equatable.dart';

/// Analytics d'une story (côté créateur)
class StoryAnalytics extends Equatable {
  final String storyId;
  final int viewsCount;
  final int completionCount;
  final int interactionsCount;
  final int sharesCount;
  final DateTime lastViewedAt;
  
  /// Détail des viewers
  final List<StoryViewer> viewers;

  const StoryAnalytics({
    required this.storyId,
    required this.viewsCount,
    required this.completionCount,
    required this.interactionsCount,
    this.sharesCount = 0,
    required this.lastViewedAt,
    this.viewers = const [],
  });

  /// Taux de complétion
  double get completionRate {
    if (viewsCount == 0) return 0.0;
    return (completionCount / viewsCount) * 100;
  }

  /// Taux d'interaction
  double get interactionRate {
    if (viewsCount == 0) return 0.0;
    return (interactionsCount / viewsCount) * 100;
  }

  @override
  List<Object?> get props => [
        storyId,
        viewsCount,
        completionCount,
        interactionsCount,
        lastViewedAt,
      ];
}

/// Détail d'un viewer
class StoryViewer extends Equatable {
  final String userId;
  final String displayName;
  final String? photoUrl;
  final DateTime viewedAt;
  final List<int> viewedSegments;
  final bool completedFully;
  final bool interacted;

  const StoryViewer({
    required this.userId,
    required this.displayName,
    this.photoUrl,
    required this.viewedAt,
    required this.viewedSegments,
    this.completedFully = false,
    this.interacted = false,
  });

  @override
  List<Object?> get props => [userId, viewedAt, completedFully];
}
