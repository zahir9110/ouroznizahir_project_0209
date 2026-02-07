
import 'package:flutter/material.dart';

class AppColors {
  // Palette principale - Inspiration Afrique/Bénin
  static const Color primaryGreen = Color(0xFF27AE60);
  static const Color primaryYellow = Color(0xFFF39C12);
  static const Color primaryOchre = Color(0xFFD35400);
  static const Color primaryRed = Color(0xFFE74C3C);
  static const Color shadow = Color(0x33000000);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color primary = Color(0xFFE67E22);      // Orange terre
  static const Color primaryDark = Color(0xFFD35400);  // Orange foncé
  static const Color primaryLight = Color(0xFFF39C12); // Jaune doré
  
  // Couleurs secondaires
  static const Color secondary = Color(0xFF8E44AD);    // Violet culture
  static const Color accent = Color(0xFF27AE60);       // Vert nature
  static const Color earth = Color(0xFF795548);        // Terre d'ocre
  static const Color sand = Color(0xFFE5D4A1);         // Sable
  
  // Neutres
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFE74C3C);
  
  // Texte
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textHint = Color(0xFFBDC3C7);
  
  // États
  static const Color online = Color(0xFF2ECC71);
  static const Color away = Color(0xFFF1C40F);
  static const Color busy = Color(0xFFE74C3C);
  
  // Gradient principal
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF7B00), Color(0xFFFF006E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}