import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'core/di/locator.dart';
import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'core/services/favorites_service.dart';
import 'features/splash/presentation/pages/splash_screen.dart';

// 🔔 Handler notifications background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase est déjà initialisé dans main()
  debugPrint('📩 Notification reçue en arrière-plan: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ Initialiser Firebase (vérification si déjà initialisé)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      debugPrint('✅ Firebase déjà initialisé');
    } else {
      rethrow;
    }
  }
  
  // ✅ Configurer notifications push
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  // ✅ Initialiser DI
  await setupLocator();
  await setupServiceLocator();
  
  // ✅ Initialiser service favoris
  final favoritesService = FavoritesService();
  await favoritesService.initialize();
  
  runApp(BokenApp(favoritesService: favoritesService));
}

class BokenApp extends StatelessWidget {
  final FavoritesService favoritesService;
  
  const BokenApp({super.key, required this.favoritesService});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Benin Experience',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: SplashScreen(favoritesService: favoritesService),
        );
      },
    );
  }
}