import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

/// Header contextuel qui change selon l'heure (Bonjour / Bonsoir)
class ContextualHeader extends StatelessWidget {
  const ContextualHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting = 'Bonjour !';
    String insight = 'Découvrez les événements culturels près de vous';

    if (hour >= 18) {
      greeting = 'Bonsoir !';
      insight = 'Il se passe des choses ce soir à Cotonou...';
    } else if (hour >= 12) {
      greeting = 'Bon après-midi !';
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              insight,
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
