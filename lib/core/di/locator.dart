import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/stories/data/datasources/stories_remote_datasource.dart';
import '../../features/stories/data/repositories/stories_repository_impl.dart';
import '../../features/stories/domain/repositories/stories_repository.dart';
import '../../features/stories/domain/usecases/get_following_stories.dart';
import '../../features/stories/domain/usecases/view_story.dart';
import '../../features/stories/domain/usecases/create_story.dart';
import '../../features/stories/domain/usecases/delete_story.dart';
import '../../features/stories/presentation/bloc/stories_feed_bloc.dart';
import '../../features/stories/presentation/bloc/story_viewer_bloc.dart';
// Events Feature
import '../../features/events/data/datasources/events_remote_datasource.dart';
import '../../features/events/data/repositories/events_repository_impl.dart';
import '../../features/events/domain/repositories/events_repository.dart';
import '../../features/events/domain/usecases/get_personalized_feed.dart';
import '../../features/events/domain/usecases/get_cultural_gems.dart';
import '../../features/events/domain/usecases/get_spontaneous_events.dart';
import '../../features/events/domain/usecases/search_events_semantic.dart';
import '../../features/events/presentation/bloc/events_feed_bloc.dart';

final sl = GetIt.instance;

/// Setup global dependency injection
/// Appelez cette fonction dans main() avant runApp()
Future<void> setupLocator() async {
  // ============================================
  // 🔧 CORE SERVICES
  // ============================================
  
  // HTTP Client
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    return dio;
  });
  
  // Firebase instances
  sl.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  sl.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );
  sl.registerLazySingleton<FirebaseStorage>(
    () => FirebaseStorage.instance,
  );
  sl.registerLazySingleton<FirebaseMessaging>(
    () => FirebaseMessaging.instance,
  );
  
  // Shared Preferences (async)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // ============================================
  // 🎫 FEATURE: EVENTS
  // ============================================
  
  // Data sources
  sl.registerLazySingleton<EventsRemoteDataSource>(
    () => EventsRemoteDataSourceImpl(firestore: sl()),
  );
  
  // Repositories
  sl.registerLazySingleton<EventsRepository>(
    () => EventsRepositoryImpl(remoteDataSource: sl()),
  );
  
  // Use cases
  sl.registerLazySingleton(() => GetPersonalizedFeed(sl()));
  sl.registerLazySingleton(() => GetCulturalGems(sl()));
  sl.registerLazySingleton(() => GetSpontaneousEvents(sl()));
  sl.registerLazySingleton(() => SearchEventsSemantic(sl()));
  
  // BLoC (factory pour créer nouvelle instance à chaque injection)
  sl.registerFactory(
    () => EventsFeedBloc(
      getPersonalizedFeed: sl(),
      getCulturalGems: sl(),
      getSpontaneousEvents: sl(),
    ),
  );
   
  // ============================================
  // 🎬 FEATURE: STORIES
  // ============================================
  
  // Data sources
  sl.registerLazySingleton<StoriesRemoteDataSource>(
    () => StoriesRemoteDataSourceImpl(
      firestore: sl(),
      storage: sl(),
    ),
  );
  
  // Repositories
  sl.registerLazySingleton<StoriesRepository>(
    () => StoriesRepositoryImpl(remoteDataSource: sl()),
  );
  
  // Use cases
  sl.registerLazySingleton(() => GetFollowingStories(sl()));
  sl.registerLazySingleton(() => ViewStory(sl()));
  sl.registerLazySingleton(() => CreateStory(sl()));
  sl.registerLazySingleton(() => DeleteStory(sl()));
  
  // BLoCs (factory pour nouvelle instance)
  sl.registerFactory(
    () => StoriesFeedBloc(getFollowingStories: sl()),
  );
  
  sl.registerFactory(
    () => StoryViewerBloc(viewStory: sl()), 
  );
}