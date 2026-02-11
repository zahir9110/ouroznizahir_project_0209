import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:benin_experience/core/theme/be_colors.dart';
import 'package:benin_experience/core/theme/be_typography.dart';
import 'package:benin_experience/core/theme/be_spacing.dart';

/// Benin Experience Design System - Theme
/// Instagram-like minimal theme
class BETheme {
  BETheme._();

  // ===================================
  // LIGHT THEME (Principal)
  // ===================================
  
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      
      // Colors
      colorScheme: BEColors.lightScheme,
      scaffoldBackgroundColor: BEColors.background,
      
      // Typography
      textTheme: BETypography.textTheme,
      
      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: BEColors.background,
        foregroundColor: BEColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: BEColors.textPrimary,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      
      // Bottom Navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: BEColors.background,
        selectedItemColor: BEColors.action,
        unselectedItemColor: BEColors.textSecondary,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: true,
      ),
      
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: BEColors.action,
          foregroundColor: BEColors.textOnAccent,
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(BESpacing.buttonMedium),
          padding: const EdgeInsets.symmetric(
            horizontal: BESpacing.xl,
            vertical: BESpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BESpacing.radiusMd),
          ),
          textStyle: BETypography.label(),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: BEColors.textPrimary,
          side: const BorderSide(color: BEColors.border, width: 1),
          elevation: 0,
          minimumSize: const Size.fromHeight(BESpacing.buttonMedium),
          padding: const EdgeInsets.symmetric(
            horizontal: BESpacing.xl,
            vertical: BESpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BESpacing.radiusMd),
          ),
          textStyle: BETypography.label(color: BEColors.textPrimary),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BEColors.action,
          padding: const EdgeInsets.symmetric(
            horizontal: BESpacing.lg,
            vertical: BESpacing.sm,
          ),
          textStyle: BETypography.label(color: BEColors.action),
        ),
      ),
      
      // Cards
      cardTheme: CardThemeData(
        color: BEColors.surfaceElevated,
        elevation: 2,
        shadowColor: BEColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BESpacing.radiusLg),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: BESpacing.screenHorizontal,
          vertical: BESpacing.cardGap,
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BEColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BESpacing.radiusMd),
          borderSide: const BorderSide(color: BEColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BESpacing.radiusMd),
          borderSide: const BorderSide(color: BEColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BESpacing.radiusMd),
          borderSide: const BorderSide(color: BEColors.borderActive, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BESpacing.radiusMd),
          borderSide: const BorderSide(color: BEColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: BESpacing.lg,
          vertical: BESpacing.md,
        ),
        hintStyle: BETypography.body(color: BEColors.textTertiary),
      ),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: BEColors.divider,
        thickness: 1,
        space: 1,
      ),
      
      // Icon
      iconTheme: const IconThemeData(
        color: BEColors.textSecondary,
        size: BESpacing.iconLg,
      ),
      
      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: BEColors.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(BESpacing.radiusXl),
          ),
        ),
        elevation: 16,
      ),
      
      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: BEColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BESpacing.radiusLg),
        ),
        elevation: 16,
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: BEColors.surface,
        labelStyle: BETypography.caption(),
        padding: const EdgeInsets.symmetric(
          horizontal: BESpacing.md,
          vertical: BESpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BESpacing.radiusSm),
        ),
      ),
      
      // Tab Bar
      tabBarTheme: TabBarThemeData(
        labelColor: BEColors.action,
        unselectedLabelColor: BEColors.textSecondary,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: BEColors.action, width: 2),
        ),
        labelStyle: BETypography.bodySemibold(),
        unselectedLabelStyle: BETypography.body(),
      ),
      
      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: BEColors.action,
        linearTrackColor: BEColors.surface,
        circularTrackColor: BEColors.surface,
      ),
      
      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: BEColors.textPrimary,
        contentTextStyle: BETypography.body(color: BEColors.textOnDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BESpacing.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  // ===================================
  // DARK THEME (Future)
  // ===================================
  
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      colorScheme: BEColors.darkScheme,
      scaffoldBackgroundColor: BEColors.backgroundDark,
      textTheme: BETypography.textTheme,
      // ... À compléter pour dark mode
    );
  }
  
  // ===================================
  // SHADOWS
  // ===================================
  
  /// Ombre subtile pour cards
  static List<BoxShadow> get cardShadow {
    return [
      BoxShadow(
        color: BEColors.shadow,
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }
  
  /// Ombre élevée pour modals
  static List<BoxShadow> get elevatedShadow {
    return [
      BoxShadow(
        color: BEColors.shadow,
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ];
  }
  
  /// Ombre bottom navigation
  static List<BoxShadow> get bottomNavShadow {
    return [
      BoxShadow(
        color: BEColors.shadow,
        blurRadius: 12,
        offset: const Offset(0, -2),
      ),
    ];
  }
}
