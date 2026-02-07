import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/main_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
      // REDIRECTION VERS LE MENU PRINCIPAL
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScaffold()));
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
              Text("Benin Experience", style: TextStyle(fontSize: 32.sp, color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 10.h),
              Text("L'Afrique à portée de main", style: TextStyle(fontSize: 16.sp, color: AppColors.primaryYellow)),
            ],
          ),
        ),
      ),
    );
  }
}
