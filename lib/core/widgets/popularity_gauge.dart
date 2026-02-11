import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

/// Jauge de popularité basée sur les bookings et avis
/// Affiche un score visuel de 1 à 5 étoiles
class PopularityGauge extends StatelessWidget {
  final int bookingsCount;
  final double rating;
  final bool showLabel;

  const PopularityGauge({
    super.key,
    required this.bookingsCount,
    required this.rating,
    this.showLabel = true,
  });

  /// Calcule le niveau de popularité (1-5)
  /// Basé sur bookings et rating
  int get popularityLevel {
    double score = 0;
    
    // 50% basé sur le rating (0-2.5)
    score += (rating / 5) * 2.5;
    
    // 50% basé sur les bookings (0-2.5)
    // Échelle: 0-10 bookings = 0-1, 11-50 = 1-2, 51-100 = 2-2.5, 100+ = 2.5
    if (bookingsCount <= 10) {
      score += (bookingsCount / 10) * 1.0;
    } else if (bookingsCount <= 50) {
      score += 1.0 + ((bookingsCount - 10) / 40) * 1.0;
    } else if (bookingsCount <= 100) {
      score += 2.0 + ((bookingsCount - 50) / 50) * 0.5;
    } else {
      score += 2.5;
    }
    
    return score.ceil().clamp(1, 5);
  }

  String get popularityLabel {
    switch (popularityLevel) {
      case 5:
        return '🔥 Très populaire';
      case 4:
        return '⭐ Populaire';
      case 3:
        return '✨ Apprécié';
      case 2:
        return '👍 Bien noté';
      default:
        return '🌱 Nouveau';
    }
  }

  Color get gaugeColor {
    switch (popularityLevel) {
      case 5:
        return const Color(0xFFEF4444); // Red
      case 4:
        return const Color(0xFFF59E0B); // Amber
      case 3:
        return AppColors.primary; // Blue
      case 2:
        return const Color(0xFF10B981); // Green
      default:
        return AppColors.textTertiary; // Gray
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Barre de popularité
        Container(
          width: 60.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: AppColors.surfaceGray,
            borderRadius: BorderRadius.circular(3.r),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: popularityLevel / 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: gaugeColor,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        if (showLabel) ...[
          SizedBox(width: 6.w),
          Text(
            popularityLabel,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: gaugeColor,
            ),
          ),
        ],
      ],
    );
  }
}

/// Badge mini pour afficher la popularité de manière compacte
class PopularityBadge extends StatelessWidget {
  final int bookingsCount;
  final double rating;

  const PopularityBadge({
    super.key,
    required this.bookingsCount,
    required this.rating,
  });

  int get popularityLevel {
    final gauge = PopularityGauge(
      bookingsCount: bookingsCount,
      rating: rating,
      showLabel: false,
    );
    return gauge.popularityLevel;
  }

  String get emoji {
    switch (popularityLevel) {
      case 5:
        return '🔥';
      case 4:
        return '⭐';
      case 3:
        return '✨';
      case 2:
        return '👍';
      default:
        return '🌱';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (popularityLevel < 3) return const SizedBox.shrink();
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: popularityLevel >= 4
            ? const LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFF59E0B)],
              )
            : null,
        color: popularityLevel == 3 ? AppColors.primary : null,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        emoji,
        style: TextStyle(fontSize: 10.sp),
      ),
    );
  }
}
