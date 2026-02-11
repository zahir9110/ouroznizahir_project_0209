import 'package:flutter/material.dart';

/// Benin Experience Design System - Colors
/// Instagram-like minimal color palette
class BEColors {
  BEColors._();

  // ===================================
  // PRIMARY / BRAND
  // ===================================
  
  /// Bleu nuit profond - Texte principal, headers
  static const Color primary = Color(0xFF0F172A);
  
  /// Bleu vivant - CTA, actions, liens
  static const Color action = Color(0xFF2563EB);
  
  // ===================================
  // SECONDARY / ACCENT
  // ===================================
  
  /// Or chaud - Culture, billets, événements premium
  static const Color accent = Color(0xFFF59E0B);
  
  /// Vert validation - Billets actifs, success
  static const Color success = Color(0xFF16A34A);
  
  /// Rouge erreur - Alertes, erreurs
  static const Color error = Color(0xFFDC2626);
  
  // ===================================
  // BACKGROUND / SURFACE
  // ===================================
  
  /// Fond principal - Blanc pur
  static const Color background = Color(0xFFFFFFFF);
  
  /// Fond secondaire - Gris très clair (cards, sections)
  static const Color surface = Color(0xFFF8FAFC);
  
  /// Surface élevée - Cards avec ombre
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  
  // ===================================
  // TEXT
  // ===================================
  
  /// Texte principal - Presque noir
  static const Color textPrimary = Color(0xFF020617);
  
  /// Texte secondaire - Gris moyen
  static const Color textSecondary = Color(0xFF475569);
  
  /// Texte faible - Gris clair (metadata, timestamps)
  static const Color textTertiary = Color(0xFF94A3B8);
  
  /// Texte sur fond sombre
  static const Color textOnDark = Color(0xFFFFFFFF);
  
  /// Texte sur fond accent
  static const Color textOnAccent = Color(0xFFFFFFFF);
  
  // ===================================
  // BORDERS / DIVIDERS
  // ===================================
  
  /// Bordure standard
  static const Color border = Color(0xFFE2E8F0);
  
  /// Bordure focus/active
  static const Color borderActive = Color(0xFF2563EB);
  
  /// Divider subtil
  static const Color divider = Color(0xFFF1F5F9);
  
  // ===================================
  // OVERLAY / SHADOW
  // ===================================
  
  /// Overlay sombre pour modals
  static const Color overlay = Color(0x80000000); // 50% opacity
  
  /// Overlay léger pour images
  static const Color overlayLight = Color(0x40000000); // 25% opacity
  
  /// Shadow couleur
  static const Color shadow = Color(0x0F000000); // ~6% opacity
  
  // ===================================
  // STATUS / STATES
  // ===================================
  
  /// Badge "nouveau"
  static const Color statusNew = Color(0xFF2563EB);
  
  /// Badge "à vendre"
  static const Color statusForSale = Color(0xFFF59E0B);
  
  /// Badge "vendu"
  static const Color statusSold = Color(0xFF94A3B8);
  
  /// Badge "premium"
  static const Color statusPremium = Color(0xFF8B5CF6);
  
  /// Notification badge
  static const Color notification = Color(0xFFDC2626);
  
  // ===================================
  // STORY GRADIENT
  // ===================================
  
  /// Gradient pour cercle story (bleu → or)
  static const Gradient storyGradient = LinearGradient(
    colors: [action, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Gradient pour story premium
  static const Gradient storyPremiumGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // ===================================
  // DARK MODE (Future)
  // ===================================
  
  /// Background dark mode
  static const Color backgroundDark = Color(0xFF020617);
  
  /// Surface dark mode
  static const Color surfaceDark = Color(0xFF0F172A);
  
  /// Texte sur fond dark (pour dark mode)
  static const Color textOnDarkMode = Color(0xFFF8FAFC);
  
  // ===================================
  // SEMANTIC COLORS (Material)
  // ===================================
  
  /// ColorScheme light pour Material
  static const ColorScheme lightScheme = ColorScheme.light(
    primary: action,
    secondary: accent,
    error: error,
    surface: surface,
    onPrimary: textOnAccent,
    onSecondary: textOnAccent,
    onError: textOnAccent,
    onSurface: textPrimary,
  );
  
  /// ColorScheme dark pour Material (future)
  static const ColorScheme darkScheme = ColorScheme.dark(
    primary: action,
    secondary: accent,
    error: error,
    surface: surfaceDark,
    onPrimary: textOnAccent,
    onSecondary: textOnAccent,
    onError: textOnAccent,
    onSurface: textOnDarkMode,
  );
}
