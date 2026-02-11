import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:benin_experience/core/theme/be_colors.dart';
import 'package:benin_experience/core/theme/be_typography.dart';
import 'package:benin_experience/core/theme/be_spacing.dart';
import 'package:benin_experience/core/theme/be_theme.dart';

/// Benin Experience - Ticket Card Component
/// Card billet à vendre
class BETicketCard extends StatelessWidget {
  final String eventTitle;
  final String location;
  final DateTime date;
  final String? imageUrl;
  final double price;
  final String currency;
  final bool isForSale;
  final bool isSold;
  final String? qrCodeUrl;
  final VoidCallback? onBuyTap;
  final VoidCallback? onContactTap;
  final VoidCallback? onTap;
  final String? sellerName;
  final String? category;

  const BETicketCard({
    super.key,
    required this.eventTitle,
    required this.location,
    required this.date,
    this.imageUrl,
    required this.price,
    this.currency = 'FCFA',
    this.isForSale = true,
    this.isSold = false,
    this.qrCodeUrl,
    this.onBuyTap,
    this.onContactTap,
    this.onTap,
    this.sellerName,
    this.category,
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
          border: Border.all(color: BEColors.border),
          boxShadow: BETheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec badge statut
            Container(
              padding: const EdgeInsets.all(BESpacing.md),
              decoration: BoxDecoration(
                color: _getStatusColor(),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(BESpacing.radiusLg),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(),
                    size: BESpacing.iconSm,
                    color: BEColors.textOnAccent,
                  ),
                  const SizedBox(width: BESpacing.xs),
                  Text(
                    _getStatusLabel(),
                    style: BETypography.overline(color: BEColors.textOnAccent),
                  ),
                  const Spacer(),
                  if (category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: BESpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: BEColors.textOnAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(BESpacing.radiusSm),
                      ),
                      child: Text(
                        category!,
                        style: BETypography.overline(
                          color: BEColors.textOnAccent,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(BESpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre événement
                  Text(
                    eventTitle,
                    style: BETypography.title(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: BESpacing.sm),
                  
                  // Metadata (date + lieu)
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: BESpacing.iconSm,
                        color: BEColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(date),
                        style: BETypography.caption(),
                      ),
                      const SizedBox(width: BESpacing.md),
                      Icon(
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
                    ],
                  ),
                  
                  const SizedBox(height: BESpacing.lg),
                  const Divider(height: 1),
                  const SizedBox(height: BESpacing.lg),
                  
                  // QR Code + Prix
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // QR Code miniature
                      if (qrCodeUrl != null)
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: BEColors.surface,
                            borderRadius: BorderRadius.circular(
                              BESpacing.radiusSm,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              BESpacing.radiusSm,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: qrCodeUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: Icon(
                                  Icons.qr_code,
                                  color: BEColors.textTertiary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      
                      if (qrCodeUrl != null) const SizedBox(width: BESpacing.lg),
                      
                      // Prix
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Prix',
                              style: BETypography.caption(),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_formatPrice(price)} $currency',
                              style: BETypography.title(color: BEColors.accent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Vendeur
                  if (sellerName != null) ...[
                    const SizedBox(height: BESpacing.md),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: BESpacing.iconSm,
                          color: BEColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Vendu par $sellerName',
                          style: BETypography.caption(),
                        ),
                      ],
                    ),
                  ],
                  
                  // Boutons d'action
                  if (isForSale && !isSold) ...[
                    const SizedBox(height: BESpacing.lg),
                    Row(
                      children: [
                        // Bouton Acheter (primary)
                        Expanded(
                          flex: 2,
                          child: _PrimaryButton(
                            label: 'Acheter',
                            onTap: onBuyTap,
                          ),
                        ),
                        const SizedBox(width: BESpacing.sm),
                        
                        // Bouton Contact (secondary)
                        Expanded(
                          child: _SecondaryButton(
                            label: 'Contact',
                            onTap: onContactTap,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (isSold) return BEColors.statusSold;
    if (isForSale) return BEColors.statusForSale;
    return BEColors.success;
  }

  IconData _getStatusIcon() {
    if (isSold) return Icons.check_circle_outline;
    if (isForSale) return Icons.sell_outlined;
    return Icons.confirmation_number_outlined;
  }

  String _getStatusLabel() {
    if (isSold) return 'VENDU';
    if (isForSale) return 'À VENDRE';
    return 'BILLET ACTIF';
  }

  String _formatDate(DateTime date) {
    const months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatPrice(double price) {
    if (price % 1 == 0) {
      return price.toInt().toString();
    }
    return price.toStringAsFixed(2);
  }
}

/// Bouton primary interne
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _PrimaryButton({
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: BESpacing.buttonMedium,
        decoration: BoxDecoration(
          color: BEColors.action,
          borderRadius: BorderRadius.circular(BESpacing.radiusMd),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: BETypography.label(color: BEColors.textOnAccent),
        ),
      ),
    );
  }
}

/// Bouton secondary interne
class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _SecondaryButton({
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: BESpacing.buttonMedium,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: BEColors.border),
          borderRadius: BorderRadius.circular(BESpacing.radiusMd),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: BETypography.label(color: BEColors.textPrimary),
        ),
      ),
    );
  }
}
