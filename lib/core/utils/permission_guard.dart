import 'package:benin_experience/core/services/auth_service.dart';

/// Guard de permissions pour contrôler l'accès aux fonctionnalités
/// selon le rôle de l'utilisateur (Guest, User, Organizer)
class PermissionGuard {
  final AuthService _authService;
  
  PermissionGuard(this._authService);
  
  /// Vérifie que l'utilisateur est authentifié
  /// 
  /// Retourne true si authentifié, false sinon
  /// Si [onUnauthorized] est fourni, il sera appelé en cas d'échec
  Future<bool> requireAuth({
    String? message,
    VoidCallback? onUnauthorized,
  }) async {
    if (_authService.currentUser == null) {
      if (onUnauthorized != null) {
        onUnauthorized();
      }
      return false;
    }
    return true;
  }
  
  /// Vérifie que l'utilisateur a le rôle User ou Organizer (pas Guest)
  /// 
  /// Cette vérification est nécessaire pour toutes les interactions sociales:
  /// - Messagerie
  /// - Likes, commentaires, partages
  /// - Notation et avis
  /// - Sauvegarde de favoris
  /// 
  /// Si [onUnauthorized] est fourni, il sera appelé en cas d'échec
  Future<bool> requireUserRole({
    String? message,
    VoidCallback? onUnauthorized,
  }) async {
    if (!await requireAuth(
      message: message,
      onUnauthorized: onUnauthorized,
    )) {
      return false;
    }
    
    final canInteract = await _authService.canInteract();
    if (!canInteract) {
      if (onUnauthorized != null) {
        onUnauthorized();
      }
      return false;
    }
    return true;
  }
  
  /// Vérifie que l'utilisateur a le rôle Organizer
  /// 
  /// Cette vérification est nécessaire pour:
  /// - Publication d'offres
  /// - Accès au dashboard organisateur
  /// - Gestion des réservations
  /// 
  /// Si [onUnauthorized] est fourni, il sera appelé en cas d'échec
  Future<bool> requireOrganizerRole({
    String? message,
    VoidCallback? onUnauthorized,
  }) async {
    if (!await requireAuth(
      message: message,
      onUnauthorized: onUnauthorized,
    )) {
      return false;
    }
    
    final canPublish = await _authService.canPublishOffers();
    if (!canPublish) {
      if (onUnauthorized != null) {
        onUnauthorized();
      }
      return false;
    }
    return true;
  }
  
  /// Vérifie si l'utilisateur peut liker
  Future<bool> canLike() async {
    final role = await _authService.getUserRole();
    return role.canLike;
  }
  
  /// Vérifie si l'utilisateur peut commenter
  Future<bool> canComment() async {
    final role = await _authService.getUserRole();
    return role.canComment;
  }
  
  /// Vérifie si l'utilisateur peut noter un lieu
  Future<bool> canRate() async {
    final role = await _authService.getUserRole();
    return role.canRate;
  }
  
  /// Vérifie si l'utilisateur peut publier un avis
  Future<bool> canReview() async {
    final role = await _authService.getUserRole();
    return role.canReview;
  }
  
  /// Vérifie si l'utilisateur peut envoyer des messages
  Future<bool> canSendMessages() async {
    final role = await _authService.getUserRole();
    return role.canSendMessages;
  }
  
  /// Vérifie si l'utilisateur peut sauvegarder des favoris
  Future<bool> canSaveFavorites() async {
    final role = await _authService.getUserRole();
    return role.canSaveFavorites;
  }
  
  /// Vérifie si l'utilisateur peut publier des offres
  Future<bool> canPublishOffers() async {
    final role = await _authService.getUserRole();
    return role.canPublishOffers;
  }
  
  /// Vérifie si l'utilisateur peut accéder au dashboard organizer
  Future<bool> canAccessDashboard() async {
    final role = await _authService.getUserRole();
    return role.canAccessDashboard;
  }
}

/// Callback utilisé pour les actions non autorisées
typedef VoidCallback = void Function();
