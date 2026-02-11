import 'package:flutter/material.dart';
import 'package:benin_experience/core/theme/be_colors.dart';
import 'package:benin_experience/core/theme/be_typography.dart';
import 'package:benin_experience/core/theme/be_spacing.dart';

/// Benin Experience - Button Component
/// Boutons primary et secondary
class BEButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final BEButtonType type;
  final BEButtonSize size;
  final IconData? icon;
  final bool loading;
  final bool fullWidth;

  const BEButton({
    super.key,
    required this.label,
    this.onTap,
    this.type = BEButtonType.primary,
    this.size = BEButtonSize.medium,
    this.icon,
    this.loading = false,
    this.fullWidth = false,
  });

  // Constructeurs nommés pour faciliter l'usage
  const BEButton.primary({
    super.key,
    required this.label,
    this.onTap,
    this.size = BEButtonSize.medium,
    this.icon,
    this.loading = false,
    this.fullWidth = false,
  }) : type = BEButtonType.primary;

  const BEButton.secondary({
    super.key,
    required this.label,
    this.onTap,
    this.size = BEButtonSize.medium,
    this.icon,
    this.loading = false,
    this.fullWidth = false,
  }) : type = BEButtonType.secondary;

  const BEButton.text({
    super.key,
    required this.label,
    this.onTap,
    this.size = BEButtonSize.medium,
    this.icon,
    this.loading = false,
    this.fullWidth = false,
  }) : type = BEButtonType.text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        height: _getHeight(),
        width: fullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          horizontal: _getHorizontalPadding(),
          vertical: _getVerticalPadding(),
        ),
        decoration: _getDecoration(),
        child: loading
            ? _buildLoader()
            : Row(
                mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: _getIconSize(),
                      color: _getTextColor(),
                    ),
                    const SizedBox(width: BESpacing.sm),
                  ],
                  Text(
                    label,
                    style: _getTextStyle(),
                  ),
                ],
              ),
      ),
    );
  }

  double _getHeight() {
    switch (size) {
      case BEButtonSize.small:
        return BESpacing.buttonSmall;
      case BEButtonSize.medium:
        return BESpacing.buttonMedium;
      case BEButtonSize.large:
        return BESpacing.buttonLarge;
    }
  }

  double _getHorizontalPadding() {
    switch (size) {
      case BEButtonSize.small:
        return BESpacing.lg;
      case BEButtonSize.medium:
        return BESpacing.xl;
      case BEButtonSize.large:
        return BESpacing.xl;
    }
  }

  double _getVerticalPadding() {
    return BESpacing.md;
  }

  double _getIconSize() {
    switch (size) {
      case BEButtonSize.small:
        return BESpacing.iconSm;
      case BEButtonSize.medium:
      case BEButtonSize.large:
        return BESpacing.iconMd;
    }
  }

  BoxDecoration _getDecoration() {
    switch (type) {
      case BEButtonType.primary:
        return BoxDecoration(
          color: BEColors.action,
          borderRadius: BorderRadius.circular(BESpacing.radiusMd),
        );
      case BEButtonType.secondary:
        return BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: BEColors.border),
          borderRadius: BorderRadius.circular(BESpacing.radiusMd),
        );
      case BEButtonType.text:
        return const BoxDecoration(
          color: Colors.transparent,
        );
    }
  }

  Color _getTextColor() {
    switch (type) {
      case BEButtonType.primary:
        return BEColors.textOnAccent;
      case BEButtonType.secondary:
      case BEButtonType.text:
        return BEColors.textPrimary;
    }
  }

  TextStyle _getTextStyle() {
    final color = _getTextColor();
    switch (size) {
      case BEButtonSize.small:
        return BETypography.labelSmall(color: color);
      case BEButtonSize.medium:
      case BEButtonSize.large:
        return BETypography.label(color: color);
    }
  }

  Widget _buildLoader() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
      ),
    );
  }
}

enum BEButtonType {
  primary,
  secondary,
  text,
}

enum BEButtonSize {
  small,
  medium,
  large,
}
