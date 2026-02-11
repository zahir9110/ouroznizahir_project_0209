import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/main_scaffold.dart';
import '../../../../core/models/user.dart';
import '../../../../core/models/user_type.dart';
import '../../../../core/models/organizer.dart';
import '../../../../core/services/favorites_service.dart';

class SplashScreen extends StatefulWidget {
  final FavoritesService favoritesService;
  
  const SplashScreen({super.key, required this.favoritesService});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      // 🎯 MODE VOYAGEUR PAR DÉFAUT
      // Expérience découverte locale avec carte et événements
      final demoUser = User(
        id: 'user_demo_001',
        firebaseUid: 'firebase_demo_001',
        email: 'voyageur@boken.app',
        phone: '+22997123456',
        fullName: 'Marie Kossou',
        avatarUrl: 'https://ui-avatars.com/api/?name=Marie+Kossou&background=10B981&color=fff',
        bio: 'Passionnée de découvertes culturelles 🌍',
        userType: UserType.traveler, // 🔑 MODE VOYAGEUR
        isVerified: false,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        updatedAt: DateTime.now(),
      );

      final demoOrganizer = Organizer(
        id: 'org_demo_001',
        userId: 'user_demo_001',
        businessName: 'Culture Porto',
        businessType: 'Association culturelle',
        verificationStatus: VerificationStatus.approved,
        verificationDocuments: ['doc1.pdf', 'doc2.pdf'],
        badgeLevel: BadgeLevel.verified,
        commissionRate: 8.0,
        totalRevenue: 1245000, // 1.2M XOF
        totalBookings: 156,
        ratingAverage: 4.8,
        ratingCount: 124,
        bankAccount: {
          'accountNumber': 'BJ06 BN 0123 4567 8901 2345 67',
          'accountName': 'Culture Porto SARL',
          'bankName': 'Bank of Africa Bénin',
        },
        subscriptionTier: SubscriptionTier.free,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        updatedAt: DateTime.now(),
      );

      // REDIRECTION VERS LE MENU PRINCIPAL
      // Mode voyageur: pas de organizerProfile
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainScaffold(
            currentUser: demoUser,
            organizerProfile: null, // Pas de profil pro par défaut
            favoritesService: widget.favoritesService,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryOchre,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.flight_takeoff, size: 100.w, color: Colors.white),
              SizedBox(height: 20.h),
              Text(
                "bōken",
                style: TextStyle(
                  fontSize: 32.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Votre business, notre mission",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.primaryYellow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
