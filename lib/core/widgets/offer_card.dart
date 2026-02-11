import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:benin_experience/core/theme/app_colors.dart';
import 'package:benin_experience/core/models/offer.dart';
import 'package:benin_experience/core/models/user_type.dart';
import 'package:benin_experience/core/widgets/media_carousel.dart';
import 'package:benin_experience/core/widgets/popularity_gauge.dart';
import 'package:benin_experience/core/widgets/favorite_button.dart';
import 'package:benin_experience/core/services/favorites_service.dart';

/// Offer Card Widget - Carte d'offre avec CTA d'achat/réservation
/// Utilisée dans le feed pour afficher les offres des organisateurs
class OfferCard extends StatelessWidget {
  final Offer offer;
  final VoidCallback? onTap;
  final VoidCallback? onBookingPressed;
  final VoidCallback? onLike;
  final VoidCallback? onSave;
  final bool isLiked;
  final bool isSaved;
  final FavoritesService? favoritesService;

  const OfferCard({
    super.key,
    required this.offer,
    this.onTap,
    this.onBookingPressed,
    this.onLike,
    this.onSave,
    this.isLiked = false,
    this.isSaved = false,
    this.favoritesService,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Organizer info
            _buildOrganizerHeader(),

            // Image principale (ratio 4:5 Instagram-like)
            _buildMainImage(),

            // Actions row (like, comment, save)
            _buildActionsRow(),

            // Content: Title, location, date, price
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
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

                  // Metadata row
                  _buildMetadataRow(),

                  SizedBox(height: 12.h),

                  // CTA Button
                  _buildCTAButton(),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizerHeader() {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 16.r,
            backgroundImage: offer.organizerAvatar != null
                ? NetworkImage(offer.organizerAvatar!)
                : null,
            child: offer.organizerAvatar == null
                ? Text(
                    offer.organizerName?[0].toUpperCase() ?? 'O',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null,
          ),

          SizedBox(width: 10.w),

          // Name + Badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      offer.organizerName ?? 'Organisateur',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (offer.organizerBadge != null &&
                        offer.organizerBadge != BadgeLevel.standard) ...[
                      SizedBox(width: 4.w),
                      Text(
                        offer.organizerBadge!.icon,
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ],
                ),
                // Rating + Jauge popularité
                Row(
                  children: [
                    if (offer.organizerRating != null) ...[
                      Icon(
                        Icons.star,
                        size: 12.r,
                        color: AppColors.accent,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        offer.organizerRating!.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ],
                    PopularityGauge(
                      bookingsCount: offer.bookingsCount ?? 0,
                      rating: offer.organizerRating ?? 0,
                      showLabel: false,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Category badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.r),
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
                  offer.categoryName,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainImage() {
    return MediaCarousel(
      mediaUrls: offer.mediaUrls,
      aspectRatio: 4 / 5,
      overlayWidget: Stack(
        children: [
          // Bouton favoris (top-right)
          if (favoritesService != null)
            Positioned(
              top: 12.h,
              right: 12.w,
              child: FavoriteButton(
                offerId: offer.id,
                favoritesService: favoritesService!,
                size: 24.r,
              ),
            ),

          // Price badge (top-left après compteur photos)
          if (offer.hasPrice)
            Positioned(
              top: 12.h,
              left: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  offer.displayPrice,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          // Boost indicator (top-left sous price)
          if (offer.isBoosted)
            Positioned(
              top: offer.hasPrice ? 50.h : 12.h,
              left: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFFF59E0B)],
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bolt,
                      size: 12.r,
                      color: Colors.white,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Boost',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Badge popularité (top-left sous boost)
          Positioned(
            top: offer.isBoosted && offer.hasPrice
                ? 88.h
                : offer.isBoosted || offer.hasPrice
                    ? 50.h
                    : 12.h,
            left: 12.w,
            child: PopularityBadge(
              bookingsCount: offer.bookingsCount ?? 0,
              rating: offer.organizerRating ?? 0,
            ),
          ),

          // Sold out overlay
          if (offer.isSoldOut)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'COMPLET',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionsRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // Like
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : AppColors.textPrimary,
            ),
            iconSize: 24.r,
            onPressed: onLike,
          ),

          SizedBox(width: 4.w),

          // View count
          Text(
            '${offer.viewsCount}',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
            ),
          ),

          const Spacer(),

          // Save
          IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: isSaved ? AppColors.primary : AppColors.textPrimary,
            ),
            iconSize: 24.r,
            onPressed: onSave,
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataRow() {
    return Row(
      children: [
        // Location
        if (offer.hasLocation) ...[
          Icon(
            Icons.location_on_outlined,
            size: 14.r,
            color: AppColors.textTertiary,
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              offer.locationName,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textTertiary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],

        // Date (pour événements)
        if (offer.eventDate != null) ...[
          SizedBox(width: 12.w),
          Icon(
            Icons.calendar_today_outlined,
            size: 14.r,
            color: AppColors.textTertiary,
          ),
          SizedBox(width: 4.w),
          Text(
            _formatDate(offer.eventDate!),
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCTAButton() {
    if (offer.isSoldOut) {
      return SizedBox(
        width: double.infinity,
        height: 44.h,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.textTertiary,
            disabledBackgroundColor: AppColors.textTertiary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            elevation: 0,
          ),
          child: Text(
            'Complet',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    final buttonText = _getButtonText();
    final urgencyMessage = _getUrgencyMessage();
    final showUrgency = urgencyMessage != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Message d'urgence (si applicable)
        if (showUrgency)
          Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFF59E0B)],
              ),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_fire_department,
                  size: 14.r,
                  color: Colors.white,
                ),
                SizedBox(width: 6.w),
                Text(
                  urgencyMessage,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

        // Bouton CTA
        SizedBox(
          height: 44.h,
          child: ElevatedButton(
            onPressed: onBookingPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                // Compteur vues temps réel
                if (offer.viewsCount > 50) ...[
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 12.r,
                          color: Colors.white,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${offer.viewsCount}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Génère un message d'urgence si nécessaire
  /// Ex: "3 billets restants", "Plus que 5 places"
  String? _getUrgencyMessage() {
    final capacity = offer.capacity;
    final bookingsCount = offer.bookingsCount ?? 0;

    if (capacity == null) return null;

    final remainingSpots = capacity - bookingsCount;

    if (remainingSpots <= 0) return null;
    if (remainingSpots <= 3) {
      return remainingSpots == 1
          ? 'Dernière place !'
          : '$remainingSpots places restantes';
    }
    if (remainingSpots <= 10) {
      return 'Plus que $remainingSpots places';
    }

    // Haute demande si > 80% de remplissage
    final fillRate = bookingsCount / capacity;
    if (fillRate > 0.8) {
      return '${(fillRate * 100).toInt()}% réservé';
    }

    return null;
  }

  String _getButtonText() {
    switch (offer.category) {
      case OfferCategory.accommodation:
        return 'Réserver';
      case OfferCategory.transport:
        return 'Réserver';
      case OfferCategory.tour:
        return 'Réserver la visite';
      case OfferCategory.event:
        return 'Acheter le billet';
      case OfferCategory.site:
        return 'Voir les détails';
      default:
        return 'Réserver';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) {
      return "Aujourd'hui";
    } else if (difference.inDays == 1) {
      return 'Demain';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}j';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}
