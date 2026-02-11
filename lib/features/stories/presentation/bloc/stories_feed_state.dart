import 'package:equatable/equatable.dart';
import '../../domain/entities/story.dart';

/// Status du feed stories
enum StoriesFeedStatus { initial, loading, success, failure }

/// État du BLoC feed stories
class StoriesFeedState extends Equatable {
  final StoriesFeedStatus status;
  final List<Story> allStories;
  final Map<String, List<Story>> groupedStories;
  final String? errorMessage;

  const StoriesFeedState({
    this.status = StoriesFeedStatus.initial,
    this.allStories = const [],
    this.groupedStories = const {},
    this.errorMessage,
  });

  StoriesFeedState copyWith({
    StoriesFeedStatus? status,
    List<Story>? allStories,
    Map<String, List<Story>>? groupedStories,
    String? errorMessage,
  }) {
    return StoriesFeedState(
      status: status ?? this.status,
      allStories: allStories ?? this.allStories,
      groupedStories: groupedStories ?? this.groupedStories,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allStories,
        groupedStories,
        errorMessage,
      ];
}
