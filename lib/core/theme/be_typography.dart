import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:benin_experience/core/theme/be_colors.dart';

/// Benin Experience Design System - Typography
/// Inter font family with clear hierarchy
class BETypography {
  BETypography._();

  // ===================================
  // DISPLAY (Titres majeurs)
  // ===================================
  
  /// Display Bold - 24/28 - Headers principaux
  static TextStyle display({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 24,
      height: 28 / 24, // line-height 28
      fontWeight: FontWeight.w700, // Bold
      color: color ?? BEColors.textPrimary,
      letterSpacing: -0.5, // Tracking légèrement serré
    );
  }
  
  // ===================================
  // TITLE (Sous-titres, cards)
  // ===================================
  
  /// Title SemiBold - 18/20 - Titres de cards
  static TextStyle title({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 18,
      height: 20 / 18,
      fontWeight: FontWeight.w600, // SemiBold
      color: color ?? BEColors.textPrimary,
      letterSpacing: -0.3,
    );
  }
  
  /// Title Medium - 16/18 - Sous-sections
  static TextStyle titleMedium({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 16,
      height: 18 / 16,
      fontWeight: FontWeight.w600,
      color: color ?? BEColors.textPrimary,
    );
  }
  
  // ===================================
  // BODY (Contenu principal)
  // ===================================
  
  /// Body Regular - 14/16 - Texte principal
  static TextStyle body({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 14,
      height: 16 / 14,
      fontWeight: FontWeight.w400, // Regular
      color: color ?? BEColors.textPrimary,
    );
  }
  
  /// Body Medium - 14/16 - Texte accentué
  static TextStyle bodyMedium({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 14,
      height: 16 / 14,
      fontWeight: FontWeight.w500,
      color: color ?? BEColors.textPrimary,
    );
  }
  
  /// Body SemiBold - 14/16 - Emphasis
  static TextStyle bodySemibold({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 14,
      height: 16 / 14,
      fontWeight: FontWeight.w600,
      color: color ?? BEColors.textPrimary,
    );
  }
  
  // ===================================
  // CAPTION (Metadata, timestamps)
  // ===================================
  
  /// Caption Regular - 12/14 - Metadata
  static TextStyle caption({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 12,
      height: 14 / 12,
      fontWeight: FontWeight.w400,
      color: color ?? BEColors.textSecondary,
    );
  }
  
  /// Caption Medium - 12/14 - Metadata accentuée
  static TextStyle captionMedium({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 12,
      height: 14 / 12,
      fontWeight: FontWeight.w500,
      color: color ?? BEColors.textSecondary,
    );
  }
  
  // ===================================
  // LABEL (Boutons)
  // ===================================
  
  /// Label SemiBold - 14 - Boutons
  static TextStyle label({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color ?? BEColors.textOnAccent,
      letterSpacing: 0.1,
    );
  }
  
  /// Label Small - 12 - Petits boutons
  static TextStyle labelSmall({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: color ?? BEColors.textOnAccent,
      letterSpacing: 0.1,
    );
  }
  
  // ===================================
  // OVERLINE (Tags, badges)
  // ===================================
  
  /// Overline - 10 - Tags uppercase
  static TextStyle overline({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: color ?? BEColors.textSecondary,
      letterSpacing: 1.2, // Très espacé
      height: 1.2,
    );
  }
  
  // ===================================
  // MATERIAL TEXT THEME
  // ===================================
  
  /// TextTheme complet pour Material
  static TextTheme get textTheme {
    return TextTheme(
      // Display
      displayLarge: display(),
      displayMedium: display(),
      displaySmall: display(),
      
      // Headline
      headlineLarge: display(),
      headlineMedium: title(),
      headlineSmall: titleMedium(),
      
      // Title
      titleLarge: title(),
      titleMedium: titleMedium(),
      titleSmall: bodySemibold(),
      
      // Body
      bodyLarge: body(),
      bodyMedium: body(),
      bodySmall: caption(),
      
      // Label
      labelLarge: label(),
      labelMedium: label(),
      labelSmall: labelSmall(),
    );
  }
}
