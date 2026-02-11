import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

/// Carousel média pour afficher plusieurs photos d'une offre
/// Swipeable avec indicateur de position
class MediaCarousel extends StatefulWidget {
  final List<String> mediaUrls;
  final double aspectRatio;
  final Widget? overlayWidget;

  const MediaCarousel({
    super.key,
    required this.mediaUrls,
    this.aspectRatio = 4 / 5,
    this.overlayWidget,
  });

  @override
  State<MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaUrls.isEmpty) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Container(
          color: AppColors.surfaceGray,
          child: Icon(
            Icons.image_outlined,
            size: 48.r,
            color: AppColors.textTertiary,
          ),
        ),
      );
    }

    if (widget.mediaUrls.length == 1) {
      return Stack(
        children: [
          AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: Image.network(
              widget.mediaUrls.first,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.surfaceGray,
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 48.r,
                    color: AppColors.textTertiary,
                  ),
                );
              },
            ),
          ),
          if (widget.overlayWidget != null) widget.overlayWidget!,
        ],
      );
    }

    return Stack(
      children: [
        // PageView pour swiper les images
        AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.mediaUrls.length,
            itemBuilder: (context, index) {
              return Image.network(
                widget.mediaUrls[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.surfaceGray,
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 48.r,
                      color: AppColors.textTertiary,
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Indicateur de position (dots)
        if (widget.mediaUrls.length > 1)
          Positioned(
            bottom: 12.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    widget.mediaUrls.length,
                    (index) => Container(
                      width: index == _currentPage ? 8.w : 6.w,
                      height: index == _currentPage ? 8.h : 6.h,
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        color: index == _currentPage
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

        // Compteur de photos (top-left)
        if (widget.mediaUrls.length > 1)
          Positioned(
            top: 12.h,
            right: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.photo_library,
                    size: 12.r,
                    color: Colors.white,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${_currentPage + 1}/${widget.mediaUrls.length}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Overlay widget (badges, price, etc.)
        if (widget.overlayWidget != null) widget.overlayWidget!,
      ],
    );
  }
}
