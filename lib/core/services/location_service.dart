import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// Service de localisation pour obtenir la position de l'utilisateur
/// Utilisé pour filtrer les offres par distance
class LocationService {
  Position? _currentPosition;
  bool _isPermissionGranted = false;

  Position? get currentPosition => _currentPosition;
  bool get isPermissionGranted => _isPermissionGranted;

  /// Vérifie les permissions de localisation
  Future<bool> checkPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test si service localisation activé
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('⚠️ Service de localisation désactivé');
      return false;
    }

    // Vérification des permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('❌ Permission de localisation refusée');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('❌ Permission de localisation refusée définitivement');
      return false;
    }

    _isPermissionGranted = true;
    debugPrint('✅ Permission de localisation accordée');
    return true;
  }

  /// Obtient la position actuelle de l'utilisateur
  Future<Position?> getCurrentPosition() async {
    try {
      if (!_isPermissionGranted) {
        final hasPermission = await checkPermissions();
        if (!hasPermission) return null;
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      debugPrint('📍 Position obtenue: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
      return _currentPosition;
    } catch (e) {
      debugPrint('❌ Erreur obtention position: $e');
      return null;
    }
  }

  /// Calcule la distance entre deux points (en km)
  double calculateDistance({
    required double startLat,
    required double startLon,
    required double endLat,
    required double endLon,
  }) {
    return Geolocator.distanceBetween(
      startLat,
      startLon,
      endLat,
      endLon,
    ) / 1000; // Convertir mètres en km
  }

  /// Calcule la distance depuis la position actuelle (en km)
  double? distanceFromCurrent({
    required double targetLat,
    required double targetLon,
  }) {
    if (_currentPosition == null) return null;

    return calculateDistance(
      startLat: _currentPosition!.latitude,
      startLon: _currentPosition!.longitude,
      endLat: targetLat,
      endLon: targetLon,
    );
  }
}
