import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:benin_experience/core/theme/app_colors.dart';
import 'package:benin_experience/core/services/favorites_service.dart';
import 'package:benin_experience/core/mock/mock_data_b2b2c.dart';
import 'package:benin_experience/core/widgets/offer_card.dart';
import 'package:benin_experience/core/models/user_type.dart';

/// Page dédiée aux offres favorites (wishlist)
/// Affiche la liste des offres mises en favoris par l'utilisateur
class FavoritesPage extends StatelessWidget {
  final FavoritesService favoritesService;

  const FavoritesPage({
    super.key,
    required this.favoritesService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Mes Favoris',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          ListenableBuilder(
            listenable: favoritesService,
            builder: (context, child) {
              if (favoritesService.count == 0) return const SizedBox.shrink();

              return IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _showClearConfirmation(context),
                tooltip: 'Tout supprimer',
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: favoritesService,
        builder: (context, child) {
          // Empty state
          if (favoritesService.count == 0) {
            return _buildEmptyState(context);
          }

          // Filtrer les offres favorites
          final favoriteOffers = MockDataB2B2C.mockOffers
              .where((offer) => favoritesService.isFavorite(offer.id))
              .toList();

          return RefreshIndicator(
            onRefresh: () async {
              // TODO: Refresh depuis API
              await Future.delayed(const Duration(seconds: 1));
            },
            child: CustomScrollView(
              slivers: [
                // Header avec compteur
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEF4444), Color(0xFFF59E0B)],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 24.r,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${favoriteOffers.length} ${favoriteOffers.length > 1 ? "offres" : "offre"}',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Enregistrées pour plus tard',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Liste des offres
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final offer = favoriteOffers[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: OfferCard(
                            offer: offer,
                            favoritesService: favoritesService,
                          ),
                        );
                      },
                      childCount: favoriteOffers.length,
                    ),
                  ),
                ),

                // Bottom padding
                SliverToBoxAdapter(
                  child: SizedBox(height: 80.h),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon animé
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGray,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      size: 64.r,
                      color: AppColors.textTertiary,
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 24.h),

            Text(
              'Aucun favori',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              'Explorez les offres et ajoutez vos coups de cœur\npour les retrouver facilement',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),

            SizedBox(height: 32.h),

            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.explore),
              label: const Text('Explorer les offres'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer tous les favoris ?'),
        content: Text(
          'Cette action supprimera tous vos favoris (${favoritesService.count} offres).',
          style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              favoritesService.clearFavorites();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Tous les favoris ont été supprimés'),
                  backgroundColor: AppColors.textSecondary,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }
}
