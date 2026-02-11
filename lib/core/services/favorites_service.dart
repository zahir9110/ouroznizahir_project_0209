import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service de gestion des favoris (wishlist)
/// Utilise SharedPreferences pour la persistance locale
/// Alternative: Firestore pour sync multi-device (TODO)
class FavoritesService extends ChangeNotifier {
  static const String _favoritesKey = 'user_favorites';
  
  Set<String> _favoriteIds = {};
  bool _isInitialized = false;

  /// IDs des offres en favoris (read-only)
  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  /// Nombre de favoris
  int get count => _favoriteIds.length;

  /// Vérifie si une offre est en favoris
  bool isFavorite(String offerId) => _favoriteIds.contains(offerId);

  /// Initialise le service (charge depuis SharedPreferences)
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedFavorites = prefs.getStringList(_favoritesKey) ?? [];
      _favoriteIds = Set.from(savedFavorites);
      _isInitialized = true;
      debugPrint('✅ FavoritesService: ${_favoriteIds.length} favoris chargés');
    } catch (e) {
      debugPrint('❌ Erreur chargement favoris: $e');
      _favoriteIds = {};
      _isInitialized = true;
    }
    notifyListeners();
  }

  /// Ajoute une offre aux favoris
  Future<bool> addFavorite(String offerId) async {
    if (_favoriteIds.contains(offerId)) {
      debugPrint('⚠️ Offre $offerId déjà en favoris');
      return false;
    }

    _favoriteIds.add(offerId);
    await _saveFavorites();
    notifyListeners();
    debugPrint('❤️ Ajouté aux favoris: $offerId');
    return true;
  }

  /// Retire une offre des favoris
  Future<bool> removeFavorite(String offerId) async {
    if (!_favoriteIds.contains(offerId)) {
      debugPrint('⚠️ Offre $offerId pas en favoris');
      return false;
    }

    _favoriteIds.remove(offerId);
    await _saveFavorites();
    notifyListeners();
    debugPrint('💔 Retiré des favoris: $offerId');
    return true;
  }

  /// Toggle favoris (ajouter ou retirer)
  Future<bool> toggleFavorite(String offerId) async {
    if (isFavorite(offerId)) {
      return await removeFavorite(offerId);
    } else {
      return await addFavorite(offerId);
    }
  }

  /// Retire tous les favoris
  Future<void> clearFavorites() async {
    _favoriteIds.clear();
    await _saveFavorites();
    notifyListeners();
    debugPrint('🗑️ Tous les favoris supprimés');
  }

  /// Sauvegarde les favoris dans SharedPreferences
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, _favoriteIds.toList());
    } catch (e) {
      debugPrint('❌ Erreur sauvegarde favoris: $e');
    }
  }

  // TODO: Méthode pour sync avec Firestore (multi-device)
  // Future<void> syncWithFirestore(String userId) async {
  //   final doc = FirebaseFirestore.instance.collection('users').doc(userId);
  //   await doc.update({'favorites': _favoriteIds.toList()});
  // }
}
