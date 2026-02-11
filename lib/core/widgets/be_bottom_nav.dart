import 'package:flutter/material.dart';
import 'package:benin_experience/core/theme/be_colors.dart';
import 'package:benin_experience/core/theme/be_typography.dart';
import 'package:benin_experience/core/theme/be_spacing.dart';
import 'package:benin_experience/core/theme/be_theme.dart';

/// Benin Experience - Bottom Navigation
/// Navigation minimale Instagram-like
class BEBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BEBottomNavItem> items;

  const BEBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: BESpacing.bottomNavHeight,
      decoration: BoxDecoration(
        color: BEColors.background,
        boxShadow: BETheme.bottomNavShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (index) => _BEBottomNavButton(
            item: items[index],
            isActive: currentIndex == index,
            onTap: () => onTap(index),
          ),
        ),
      ),
    );
  }
}

/// Item de navigation
class BEBottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final int? badgeCount;

  BEBottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.badgeCount,
  });
}

/// Bouton interne de navigation
class _BEBottomNavButton extends StatelessWidget {
  final BEBottomNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _BEBottomNavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: BESpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge + Icône
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isActive ? (item.activeIcon ?? item.icon) : item.icon,
                  size: BESpacing.iconLg,
                  color: isActive ? BEColors.action : BEColors.textSecondary,
                ),
                
                // Badge notification
                if (item.badgeCount != null && item.badgeCount! > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: BEColors.notification,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        item.badgeCount! > 99 ? '99+' : '${item.badgeCount}',
                        style: BETypography.overline(
                          color: BEColors.textOnAccent,
                        ).copyWith(fontSize: 8),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 4),
            
            // Label (visible uniquement si actif)
            if (isActive)
              Text(
                item.label,
                style: BETypography.caption(color: BEColors.action),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
