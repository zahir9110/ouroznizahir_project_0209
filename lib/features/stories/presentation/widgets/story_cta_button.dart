import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/story_cta.dart';

/// Bouton CTA en bas de la story (style Instagram)
class StoryCTAButton extends StatelessWidget {
  final StoryCTA cta;
  final VoidCallback onTap;

  const StoryCTAButton({
    super.key,
    required this.cta,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            color: _getButtonColor(),
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getButtonIcon(),
                color: Colors.white,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                cta.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Couleur selon type CTA
  Color _getButtonColor() {
    switch (cta.type) {
      case StoryCTAType.buyTicket:
        return AppColors.primaryGreen;
      case StoryCTAType.chat:
        return AppColors.primaryOchre;
      case StoryCTAType.viewEvent:
        return AppColors.primaryRed;
      case StoryCTAType.visitProfile:
        return AppColors.primaryYellow.withOpacity(0.9);
    }
  }

  /// Icône selon type CTA
  IconData _getButtonIcon() {
    switch (cta.type) {
      case StoryCTAType.buyTicket:
        return Icons.shopping_bag;
      case StoryCTAType.chat:
        return Icons.chat_bubble;
      case StoryCTAType.viewEvent:
        return Icons.event;
      case StoryCTAType.visitProfile:
        return Icons.person;
    }
  }
}
