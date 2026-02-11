
import 'package:flutter/material.dart';

class AppColors {
  // 🎨 Palette principale (Instagram-like minimal)
  static const Color primary = Color(0xFF2563EB);        // Bleu vivide
  static const Color accent = Color(0xFFF59E0B);         // Or/Ambre
  static const Color error = Color(0xFFDC2626);          // Rouge
  
  // 🖤 Textes (hiérarchie claire)
  static const Color textPrimary = Color(0xFF020617);    // Presque noir
  static const Color textSecondary = Color(0xFF475569);  // Gris moyen
  static const Color textTertiary = Color(0xFF94A3B8);   // Gris clair
  static const Color textHint = Color(0xFF94A3B8);       // Alias
  
  // ⚪ Backgrounds (air et espace)
  static const Color background = Color(0xFFFFFFFF);     // Blanc pur
  static const Color surface = Color(0xFFF8FAFC);        // Gris très pâle
  static const Color surfaceGray = Color(0xFFF1F5F9);    // Gris clair pour widgets
  static const Color divider = Color(0xFFE2E8F0);        // Bordures subtiles
  
  // 🎭 Stories gradient
  static const List<Color> storyGradient = [
    Color(0xFF2563EB), // Bleu
    Color(0xFFF59E0B), // Or
  ];
  
  // 🎟️ Billets (badge doré)
  static const Color ticketBadge = Color(0xFFFBBF24);
  
  // 💚 Actions positives (legacy compatibility)
  static const Color primaryGreen = Color(0xFF10B981);
  static const Color primaryRed = Color(0xFFDC2626);
  static const Color primaryYellow = Color(0xFFF59E0B);
  static const Color primaryOchre = Color(0xFFF59E0B);
  static const Color secondary = Color(0xFFF59E0B);
  
  // Ombres
  static const Color shadow = Color(0x0A000000);
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color earth = Color(0xFF78716C);
  static const Color sand = Color(0xFFFEF3C7);
  
  // États
  static const Color online = Color(0xFF2ECC71);
  static const Color away = Color(0xFFF1C40F);
  static const Color busy = Color(0xFFE74C3C);
}