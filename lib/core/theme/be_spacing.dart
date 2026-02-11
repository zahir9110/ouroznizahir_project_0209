/// Benin Experience Design System - Spacing
/// Système 8pt pour cohérence
class BESpacing {
  BESpacing._();

  // ===================================
  // SPACING SCALE (8pt system)
  // ===================================
  
  /// 4px - Spacing très serré
  static const double xs = 4.0;
  
  /// 8px - Spacing serré
  static const double sm = 8.0;
  
  /// 12px - Spacing standard
  static const double md = 12.0;
  
  /// 16px - Padding cards
  static const double lg = 16.0;
  
  /// 24px - Sections
  static const double xl = 24.0;
  
  /// 32px - Grandes séparations
  static const double xxl = 32.0;
  
  /// 48px - Très grandes séparations
  static const double xxxl = 48.0;
  
  // ===================================
  // EDGE INSETS PRESETS
  // ===================================
  
  /// Padding écran standard (16px horizontal)
  static const double screenHorizontal = lg;
  
  /// Padding écran vertical
  static const double screenVertical = xl;
  
  /// Padding card standard
  static const double cardPadding = lg;
  
  /// Gap entre cards dans liste
  static const double cardGap = md;
  
  /// Gap dans rows/columns
  static const double itemGap = sm;
  
  // ===================================
  // BORDER RADIUS
  // ===================================
  
  /// Radius petit (boutons, inputs)
  static const double radiusSm = 8.0;
  
  /// Radius standard (cards)
  static const double radiusMd = 12.0;
  
  /// Radius large (modals, images)
  static const double radiusLg = 16.0;
  
  /// Radius très large
  static const double radiusXl = 24.0;
  
  /// Radius cercle (stories, avatars)
  static const double radiusFull = 9999.0;
  
  // ===================================
  // ICON SIZES
  // ===================================
  
  /// Icône petite (inline text)
  static const double iconSm = 16.0;
  
  /// Icône standard (UI)
  static const double iconMd = 20.0;
  
  /// Icône large (bottom nav)
  static const double iconLg = 24.0;
  
  /// Icône très large
  static const double iconXl = 32.0;
  
  // ===================================
  // AVATAR SIZES
  // ===================================
  
  /// Avatar petit (commentaires)
  static const double avatarSm = 32.0;
  
  /// Avatar standard (feed)
  static const double avatarMd = 40.0;
  
  /// Avatar large (profil)
  static const double avatarLg = 64.0;
  
  /// Avatar très large (profil header)
  static const double avatarXl = 96.0;
  
  // ===================================
  // STORY SIZES
  // ===================================
  
  /// Story circle diameter
  static const double storySize = 64.0;
  
  /// Story border width
  static const double storyBorder = 2.0;
  
  /// Story inner circle (image)
  static const double storyInner = storySize - (storyBorder * 2);
  
  // ===================================
  // BUTTON HEIGHTS
  // ===================================
  
  /// Bouton small
  static const double buttonSmall = 36.0;
  
  /// Bouton standard
  static const double buttonMedium = 44.0;
  
  /// Bouton large
  static const double buttonLarge = 48.0;
  
  // ===================================
  // BOTTOM NAV
  // ===================================
  
  /// Hauteur bottom navigation
  static const double bottomNavHeight = 64.0;
  
  /// Hauteur app bar
  static const double appBarHeight = 56.0;
  
  // ===================================
  // CARD DIMENSIONS
  // ===================================
  
  /// Hauteur minimale card événement
  static const double eventCardMinHeight = 280.0;
  
  /// Aspect ratio image événement (16:9)
  static const double eventImageAspectRatio = 16 / 9;
  
  /// Aspect ratio image billet (4:3)
  static const double ticketImageAspectRatio = 4 / 3;
}
