import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

/// Cercle story avec gradient (style Instagram)
class StoryRing extends StatelessWidget {
  final String userId;
  final String displayName;
  final String photoUrl;
  final bool hasNewContent;
  final VoidCallback onTap;

  const StoryRing({
    super.key,
    required this.userId,
    required this.displayName,
    required this.photoUrl,
    this.hasNewContent = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            // Cercle avec gradient
            Container(
              width: 68.w,
              height: 68.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: hasNewContent
                    ? const LinearGradient(
                        colors: [
                          AppColors.primaryRed,
                          AppColors.primaryOchre,
                          AppColors.primaryYellow,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: hasNewContent ? null : AppColors.divider,
              ),
              padding: EdgeInsets.all(3.w),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background,
                ),
                padding: EdgeInsets.all(3.w),
                child: CircleAvatar(
                  backgroundImage:
                      photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                  child: photoUrl.isEmpty
                      ? Icon(Icons.person, size: 24.sp)
                      : null,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            // Nom
            SizedBox(
              width: 68.w,
              child: Text(
                displayName,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
