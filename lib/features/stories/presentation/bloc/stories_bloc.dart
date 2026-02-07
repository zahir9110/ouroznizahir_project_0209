import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/story_model.dart';

abstract class StoriesState extends Equatable {
  const StoriesState();

  @override
  List<Object> get props => [];
}

class StoriesInitial extends StoriesState {}

class StoriesLoading extends StoriesState {}

class StoriesLoaded extends StoriesState {
  final List<StoryModel> stories;

  const StoriesLoaded(this.stories);

  @override
  List<Object> get props => [stories];
}

class StoriesError extends StoriesState {
  final String message;

  const StoriesError(this.message);

  @override
  List<Object> get props => [message];
}

abstract class StoriesEvent extends Equatable {
  const StoriesEvent();

  @override
  List<Object> get props => [];
}

class LoadStories extends StoriesEvent {}

class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  StoriesBloc() : super(StoriesInitial()) {
    on<LoadStories>(_onLoadStories);
  }

  Future<void> _onLoadStories(LoadStories event, Emitter<StoriesState> emit) async {
    emit(StoriesLoading());
    try {
      // TODO: Implement actual data loading
      await Future.delayed(const Duration(seconds: 1));
      emit(const StoriesLoaded([]));
    } catch (e) {
      emit(StoriesError(e.toString()));
    }
  }
}
