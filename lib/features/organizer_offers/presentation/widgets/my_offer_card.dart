import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/offer.dart';

/// Carte d'offre pour la liste "Mes Offres" de l'organisateur
class MyOfferCard extends StatelessWidget {
  final Offer offer;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onBoost;
  final VoidCallback? onToggleStatus;

  const MyOfferCard({
    super.key,
    required this.offer,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.onBoost,
    this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final isPublished = offer.status == 'published';
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📷 Image + Badges
            Stack(
              children: [
                // Image principale
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: offer.mediaUrls.isNotEmpty
                        ? Image.network(
                            offer.mediaUrls.first,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: AppColors.surfaceGray,
                              child: Icon(
                                Icons.image_not_supported,
                                size: 48.r,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          )
                        : Container(
                            color: AppColors.surfaceGray,
                            child: Icon(
                              Icons.add_photo_alternate,
                              size: 48.r,
                              color: AppColors.textTertiary,
                            ),
                          ),
                  ),
                ),

                // Status badge (coin supérieur gauche)
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: _getStatusColor(offer.status),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(offer.status),
                          size: 14.r,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          _getStatusLabel(offer.status),
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

                // Boost badge (si boostée)
                if (offer.isBoosted)
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFFF59E0B)],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '⚡',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Boost',
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
              ],
            ),

            // 📝 Contenu
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Catégorie + Prix
                  Row(
                    children: [
                      // Category badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              offer.categoryIcon,
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              offer.category.displayName,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Prix
                      Text(
                        offer.displayPrice,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Titre
                  Text(
                    offer.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 8.h),

                  // Stats (vues, likes, bookings)
                  Row(
                    children: [
                      _StatItem(
                        icon: Icons.visibility_outlined,
                        value: offer.viewsCount.toString(),
                        label: 'vues',
                      ),
                      SizedBox(width: 16.w),
                      _StatItem(
                        icon: Icons.favorite_border,
                        value: offer.likesCount.toString(),
                        label: 'likes',
                      ),
                      SizedBox(width: 16.w),
                      _StatItem(
                        icon: Icons.confirmation_number_outlined,
                        value: offer.bookingsCount.toString(),
                        label: 'réservations',
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Actions
                  Row(
                    children: [
                      // Bouton Éditer
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onEdit,
                          icon: Icon(Icons.edit_outlined, size: 18.r),
                          label: Text('Éditer'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                        ),
                      ),

                      SizedBox(width: 8.w),

                      // Bouton Toggle Status
                      if (onToggleStatus != null)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onToggleStatus,
                            icon: Icon(
                              isPublished ? Icons.pause : Icons.play_arrow,
                              size: 18.r,
                            ),
                            label: Text(isPublished ? 'Pause' : 'Publier'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isPublished ? AppColors.textSecondary : AppColors.primaryGreen,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                            ),
                          ),
                        ),

                      SizedBox(width: 8.w),

                      // Menu options
                      IconButton(
                        onPressed: () => _showOptionsMenu(context),
                        icon: Icon(
                          Icons.more_vert,
                          color: AppColors.textSecondary,
                          size: 24.r,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),

            if (onBoost != null && offer.status == 'published')
              _OptionTile(
                icon: Icons.bolt,
                title: 'Booster l\'offre',
                subtitle: 'Augmenter la visibilité',
                color: AppColors.accent,
                onTap: () {
                  Navigator.pop(context);
                  onBoost!();
                },
              ),

            _OptionTile(
              icon: Icons.analytics_outlined,
              title: 'Voir les statistiques',
              subtitle: 'Performance détaillée',
              onTap: () {
                Navigator.pop(context);
                debugPrint('📊 Analytics pour ${offer.title}');
              },
            ),

            _OptionTile(
              icon: Icons.content_copy,
              title: 'Dupliquer l\'offre',
              subtitle: 'Créer une copie',
              onTap: () {
                Navigator.pop(context);
                debugPrint('📋 Dupliquer ${offer.title}');
              },
            ),

            _OptionTile(
              icon: Icons.delete_outline,
              title: 'Supprimer',
              subtitle: 'Action irréversible',
              color: AppColors.error,
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'offre ?'),
        content: Text(
          'Cette action est irréversible. L\'offre "${offer.title}" sera définitivement supprimée.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'published':
        return AppColors.primaryGreen;
      case 'draft':
        return AppColors.textSecondary;
      case 'paused':
        return AppColors.accent;
      case 'sold_out':
        return AppColors.error;
      default:
        return AppColors.textTertiary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'published':
        return Icons.check_circle;
      case 'draft':
        return Icons.edit_note;
      case 'paused':
        return Icons.pause_circle;
      case 'sold_out':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'published':
        return 'Publiée';
      case 'draft':
        return 'Brouillon';
      case 'paused':
        return 'En pause';
      case 'sold_out':
        return 'Complet';
      default:
        return 'Inconnu';
    }
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.r, color: AppColors.textTertiary),
        SizedBox(width: 4.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: (color ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          color: color ?? AppColors.primary,
          size: 24.r,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: color ?? AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textTertiary,
              ),
            )
          : null,
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.r,
        color: AppColors.textTertiary,
      ),
    );
  }
}
