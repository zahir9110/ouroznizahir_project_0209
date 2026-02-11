import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../services/favorites_service.dart';

/// Bouton de favori avec animation (cœur)
/// Affiche un cœur vide si pas favori, plein si favori
/// Animation scale + color lors du toggle
class FavoriteButton extends StatefulWidget {
  final String offerId;
  final FavoritesService favoritesService;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showBackground;

  const FavoriteButton({
    super.key,
    required this.offerId,
    required this.favoritesService,
    this.size = 24.0,
    this.activeColor,
    this.inactiveColor,
    this.showBackground = true,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.3),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.3, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    // Animation
    await _animationController.forward();
    _animationController.reset();

    // Toggle favoris
    final wasAdded = await widget.favoritesService.toggleFavorite(widget.offerId);

    // Feedback visuel
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                wasAdded ? Icons.favorite : Icons.heart_broken,
                color: Colors.white,
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              Text(
                wasAdded ? 'Ajouté aux favoris' : 'Retiré des favoris',
                style: TextStyle(fontSize: 14.sp),
              ),
            ],
          ),
          backgroundColor: wasAdded ? const Color(0xFFEF4444) : AppColors.textSecondary,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.favoritesService,
      builder: (context, child) {
        final isFavorite = widget.favoritesService.isFavorite(widget.offerId);

        return GestureDetector(
          onTap: _handleTap,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Container(
                    width: widget.size * 1.8,
                    height: widget.size * 1.8,
                    decoration: widget.showBackground
                        ? BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          )
                        : null,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: widget.size,
                      color: isFavorite
                          ? (widget.activeColor ?? const Color(0xFFEF4444))
                          : (widget.inactiveColor ?? AppColors.textTertiary),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// Version compacte du bouton favoris (pour les listes)
class CompactFavoriteButton extends StatelessWidget {
  final String offerId;
  final FavoritesService favoritesService;

  const CompactFavoriteButton({
    super.key,
    required this.offerId,
    required this.favoritesService,
  });

  @override
  Widget build(BuildContext context) {
    return FavoriteButton(
      offerId: offerId,
      favoritesService: favoritesService,
      size: 20.r,
      showBackground: false,
    );
  }
}
