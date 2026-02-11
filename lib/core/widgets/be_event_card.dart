import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:benin_experience/core/theme/be_colors.dart';
import 'package:benin_experience/core/theme/be_typography.dart';
import 'package:benin_experience/core/theme/be_spacing.dart';
import 'package:benin_experience/core/theme/be_theme.dart';

/// Benin Experience - Event Card Component
/// Card événement Instagram-like
class BEEventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final DateTime date;
  final int likes;
  final int comments;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final bool isLiked;
  final String? organizerName;
  final String? organizerAvatar;

  const BEEventCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.date,
    this.likes = 0,
    this.comments = 0,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onShare,
    this.isLiked = false,
    this.organizerName,
    this.organizerAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: BESpacing.screenHorizontal,
          vertical: BESpacing.cardGap,
        ),
        decoration: BoxDecoration(
          color: BEColors.surfaceElevated,
          borderRadius: BorderRadius.circular(BESpacing.radiusLg),
          boxShadow: BETheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec avatar organisateur
            if (organizerName != null)
              Padding(
                padding: const EdgeInsets.all(BESpacing.md),
                child: Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: organizerAvatar != null
                          ? CachedNetworkImageProvider(organizerAvatar!)
                          : null,
                      backgroundColor: BEColors.surface,
                      child: organizerAvatar == null
                          ? const Icon(Icons.person, size: 16)
                          : null,
                    ),
                    const SizedBox(width: BESpacing.sm),
                    // Nom organisateur
                    Text(
                      organizerName!,
                      style: BETypography.bodySemibold(),
                    ),
                  ],
                ),
              ),
            
            // Image événement (16:9)
            AspectRatio(
              aspectRatio: BESpacing.eventImageAspectRatio,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: organizerName == null
                      ? const Radius.circular(BESpacing.radiusLg)
                      : Radius.zero,
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: BEColors.surface,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: BEColors.surface,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: BEColors.textTertiary,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
            
            // Actions row (like, comment, share)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: BESpacing.lg,
                vertical: BESpacing.md,
              ),
              child: Row(
                children: [
                  // Like
                  _ActionButton(
                    icon: isLiked ? Icons.favorite : Icons.favorite_border,
                    label: _formatCount(likes),
                    color: isLiked ? BEColors.error : null,
                    onTap: onLike,
                  ),
                  const SizedBox(width: BESpacing.lg),
                  
                  // Comment
                  _ActionButton(
                    icon: Icons.chat_bubble_outline,
                    label: _formatCount(comments),
                    onTap: onComment,
                  ),
                  
                  const Spacer(),
                  
                  // Share
                  _ActionButton(
                    icon: Icons.share_outlined,
                    onTap: onShare,
                  ),
                ],
              ),
            ),
            
            // Infos événement
            Padding(
              padding: const EdgeInsets.fromLTRB(
                BESpacing.lg,
                0,
                BESpacing.lg,
                BESpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  Text(
                    title,
                    style: BETypography.title(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: BESpacing.xs),
                  
                  // Metadata (lieu + date)
                  Row(
                    children: [
                      // Lieu
                      const Icon(
                        Icons.location_on_outlined,
                        size: BESpacing.iconSm,
                        color: BEColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: BETypography.caption(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: BESpacing.sm),
                      
                      // Date
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: BESpacing.iconSm,
                        color: BEColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(date),
                        style: BETypography.caption(),
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

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
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
      // Format: "15 mars"
      const months = [
        'janv', 'févr', 'mars', 'avr', 'mai', 'juin',
        'juil', 'août', 'sept', 'oct', 'nov', 'déc'
      ];
      return '${date.day} ${months[date.month - 1]}';
    }
  }
}

/// Widget interne pour bouton d'action
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final Color? color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    this.label,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: BESpacing.iconLg,
            color: color ?? BEColors.textSecondary,
          ),
          if (label != null) ...[
            const SizedBox(width: 4),
            Text(
              label!,
              style: BETypography.caption(
                color: color ?? BEColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
