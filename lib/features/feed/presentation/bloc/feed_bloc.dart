
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/post_model.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedInitial()) {
    on<FeedStarted>((event, emit) {
      // TODO: Implémenter le chargement initial
    });
    on<FeedRefreshed>((event, emit) {
      // TODO: Implémenter le rafraîchissement
    });
    on<FeedLoadedMore>((event, emit) {
      // TODO: Implémenter le chargement supplémentaire
    });
    on<PostLiked>((event, emit) {
      // TODO: Implémenter le like
    });
    on<PostUnliked>((event, emit) {
      // TODO: Implémenter l'unlike
    });
    on<PostSaved>((event, emit) {
      // TODO: Implémenter la sauvegarde
    });
    on<PostShared>((event, emit) {
      // TODO: Implémenter le partage
    });
    on<FilterChanged>((event, emit) {
      // TODO: Implémenter le filtrage
    });
  }
}
