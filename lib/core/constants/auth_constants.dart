/// 🔐 Constantes d'autorisation et de permissions pour Bōken
/// 
/// Ce fichier centralise toutes les constantes liées aux rôles, permissions,
/// et règles d'accès de l'application.

library;

// ============================================
// 🎭 RÔLES UTILISATEUR
// ============================================

/// Clé du champ rôle dans Firestore
const String kRoleField = 'role';

/// Valeurs des rôles dans Firestore
class UserRoles {
  /// Utilisateur standard (inscrit)
  static const String user = 'user';
  
  /// Organisateur professionnel
  static const String organizer = 'organizer';
  
  /// Administrateur (futur)
  static const String admin = 'admin';
  
  /// Liste de tous les rôles valides
  static const List<String> all = [user, organizer, admin];
  
  /// Rôles qui peuvent interagir (pas guest)
  static const List<String> canInteract = [user, organizer, admin];
  
  /// Rôles qui peuvent publier des offres
  static const List<String> canPublishOffers = [organizer, admin];
}

// ============================================
// 📝 MESSAGES D'ERREUR
// ============================================

class AuthMessages {
  /// Message pour action nécessitant une authentification
  static const String requireAuth = 'Vous devez être connecté pour effectuer cette action.';
  
  /// Message pour action nécessitant un compte utilisateur
  static const String requireUser = 'Inscrivez-vous pour accéder aux fonctionnalités sociales de Bōken.';
  
  /// Message pour action nécessitant un compte organisateur
  static const String requireOrganizer = 'Seuls les organisateurs peuvent effectuer cette action.';
  
  /// Messages spécifiques par action
  static const String requireAuthToLike = 'Connectez-vous pour liker.';
  static const String requireAuthToComment = 'Inscrivez-vous pour commenter.';
  static const String requireAuthToReview = 'Inscrivez-vous pour publier un avis.';
  static const String requireAuthToRate = 'Inscrivez-vous pour noter ce lieu.';
  static const String requireAuthToMessage = 'Inscrivez-vous pour envoyer des messages.';
  static const String requireAuthToFavorite = 'Inscrivez-vous pour sauvegarder vos lieux favoris.';
  static const String requireAuthToShare = 'Inscrivez-vous pour partager.';
  static const String requireAuthToBook = 'Inscrivez-vous pour réserver une expérience.';
  
  /// Message d'upgrade vers organisateur
  static const String upgradeToOrganizer = 'Passez en compte Organisateur pour publier des offres.';
}

// ============================================
// 🔐 COLLECTIONS FIRESTORE
// ============================================

class FirestoreCollections {
  static const String users = 'users';
  static const String places = 'places';
  static const String ratings = 'ratings';
  static const String reviews = 'reviews';
  static const String messages = 'messages';
  static const String likes = 'likes';
  static const String comments = 'comments';
  static const String shares = 'shares';
  static const String favorites = 'favorites';
  static const String offers = 'offers';
  static const String bookings = 'bookings';
  static const String notifications = 'notifications';
}

// ============================================
// 📊 CHAMPS FIRESTORE COMMUNS
// ============================================

class FirestoreFields {
  // Champs d'identification
  static const String uid = 'uid';
  static const String userId = 'userId';
  static const String placeId = 'placeId';
  static const String offerId = 'offerId';
  static const String organizerId = 'organizerId';
  
  // Champs de métadonnées
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String publishedAt = 'publishedAt';
  
  // Champs de publication
  static const String isPublished = 'isPublished';
  static const String isFeatured = 'isFeatured';
  
  // Champs de modération
  static const String moderationStatus = 'moderationStatus';
  static const String verificationStatus = 'verificationStatus';
  
  // Champs de statistiques
  static const String averageRating = 'averageRating';
  static const String ratingCount = 'ratingCount';
  static const String reviewsCount = 'reviewsCount';
  static const String likesCount = 'likes';
  static const String commentsCount = 'commentsCount';
  static const String sharesCount = 'sharesCount';
  static const String favoritesCount = 'favoritesCount';
  static const String viewsCount = 'viewsCount';
  static const String bookingsCount = 'bookingsCount';
  
  // Champs de messagerie
  static const String senderId = 'senderId';
  static const String receiverId = 'receiverId';
  static const String isRead = 'isRead';
  static const String readAt = 'readAt';
  
  // Champs de likes/shares/comments
  static const String targetType = 'targetType';
  static const String targetId = 'targetId';
  
  // Champs de réservation
  static const String status = 'status';
  static const String paymentStatus = 'paymentStatus';
}

// ============================================
// 📌 TYPES DE CIBLES (pour likes, comments, shares)
// ============================================

class TargetTypes {
  static const String review = 'review';
  static const String comment = 'comment';
  static const String post = 'post';
  static const String place = 'place';
  static const String offer = 'offer';
  
  static const List<String> all = [review, comment, post, place, offer];
}

// ============================================
// 🏷️ TYPES DE LIEUX
// ============================================

class PlaceTypes {
  static const String museum = 'museum';
  static const String dating = 'dating';
  static const String activity = 'activity';
  static const String lodging = 'lodging';
  static const String restaurant = 'restaurant';
  static const String attraction = 'attraction';
  
  static const List<String> all = [
    museum,
    dating,
    activity,
    lodging,
    restaurant,
    attraction,
  ];
  
  /// Retourne le nom d'affichage d'un type de lieu
  static String getDisplayName(String type) {
    switch (type) {
      case museum:
        return 'Musée';
      case dating:
        return 'Spot Dating';
      case activity:
        return 'Activité';
      case lodging:
        return 'Hébergement';
      case restaurant:
        return 'Restaurant';
      case attraction:
        return 'Attraction';
      default:
        return type;
    }
  }
}

// ============================================
// 🎫 TYPES D'OFFRES
// ============================================

class OfferTypes {
  static const String experience = 'experience';
  static const String tour = 'tour';
  static const String activity = 'activity';
  static const String accommodation = 'accommodation';
  static const String event = 'event';
  
  static const List<String> all = [
    experience,
    tour,
    activity,
    accommodation,
    event,
  ];
  
  /// Retourne le nom d'affichage d'un type d'offre
  static String getDisplayName(String type) {
    switch (type) {
      case experience:
        return 'Expérience';
      case tour:
        return 'Tour';
      case activity:
        return 'Activité';
      case accommodation:
        return 'Hébergement';
      case event:
        return 'Événement';
      default:
        return type;
    }
  }
}

// ============================================
// 📋 STATUTS DE RÉSERVATION
// ============================================

class BookingStatus {
  static const String pending = 'pending';
  static const String confirmed = 'confirmed';
  static const String cancelled = 'cancelled';
  static const String completed = 'completed';
  static const String refunded = 'refunded';
  
  static const List<String> all = [
    pending,
    confirmed,
    cancelled,
    completed,
    refunded,
  ];
  
  /// Retourne le nom d'affichage d'un statut
  static String getDisplayName(String status) {
    switch (status) {
      case pending:
        return 'En attente';
      case confirmed:
        return 'Confirmé';
      case cancelled:
        return 'Annulé';
      case completed:
        return 'Terminé';
      case refunded:
        return 'Remboursé';
      default:
        return status;
    }
  }
}

// ============================================
// 💳 STATUTS DE PAIEMENT
// ============================================

class PaymentStatus {
  static const String pending = 'pending';
  static const String paid = 'paid';
  static const String refunded = 'refunded';
  static const String failed = 'failed';
  
  static const List<String> all = [
    pending,
    paid,
    refunded,
    failed,
  ];
  
  /// Retourne le nom d'affichage d'un statut de paiement
  static String getDisplayName(String status) {
    switch (status) {
      case pending:
        return 'En attente';
      case paid:
        return 'Payé';
      case refunded:
        return 'Remboursé';
      case failed:
        return 'Échec';
      default:
        return status;
    }
  }
}

// ============================================
// 🔍 STATUTS DE MODÉRATION
// ============================================

class ModerationStatus {
  static const String pending = 'pending';
  static const String approved = 'approved';
  static const String rejected = 'rejected';
  
  static const List<String> all = [
    pending,
    approved,
    rejected,
  ];
}

// ============================================
// ✅ STATUTS DE VÉRIFICATION
// ============================================

class VerificationStatus {
  static const String pending = 'pending';
  static const String verified = 'verified';
  static const String rejected = 'rejected';
  
  static const List<String> all = [
    pending,
    verified,
    rejected,
  ];
}

// ============================================
// 💰 DEVISES
// ============================================

class Currencies {
  static const String xof = 'XOF'; // Franc CFA
  static const String eur = 'EUR'; // Euro
  static const String usd = 'USD'; // Dollar
  
  static const List<String> all = [xof, eur, usd];
  
  /// Retourne le symbole d'une devise
  static String getSymbol(String currency) {
    switch (currency) {
      case xof:
        return 'FCFA';
      case eur:
        return '€';
      case usd:
        return '\$';
      default:
        return currency;
    }
  }
}

// ============================================
// 📏 LIMITES ET CONTRAINTES
// ============================================

class Limits {
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Ratings
  static const int minRating = 1;
  static const int maxRating = 5;
  
  // Reviews
  static const int minReviewLength = 10;
  static const int maxReviewLength = 2000;
  static const int maxReviewImages = 5;
  
  // Comments
  static const int minCommentLength = 1;
  static const int maxCommentLength = 500;
  
  // Messages
  static const int minMessageLength = 1;
  static const int maxMessageLength = 1000;
  
  // Places
  static const int minPlaceNameLength = 3;
  static const int maxPlaceNameLength = 100;
  static const int maxPlaceImages = 10;
  
  // Offers
  static const int minOfferTitleLength = 3;
  static const int maxOfferTitleLength = 100;
  static const int maxOfferImages = 10;
}

// ============================================
// 🌍 COORDONNÉES GÉOGRAPHIQUES
// ============================================

class GeoConstraints {
  static const double minLatitude = -90.0;
  static const double maxLatitude = 90.0;
  static const double minLongitude = -180.0;
  static const double maxLongitude = 180.0;
  
  /// Vérifie si des coordonnées sont valides
  static bool isValidCoordinate(double lat, double lng) {
    return lat >= minLatitude &&
        lat <= maxLatitude &&
        lng >= minLongitude &&
        lng <= maxLongitude;
  }
}

// ============================================
// ⏰ DURÉES DE CACHE
// ============================================

class CacheDurations {
  static const Duration places = Duration(hours: 1);
  static const Duration reviews = Duration(minutes: 30);
  static const Duration offers = Duration(hours: 1);
  static const Duration userProfile = Duration(minutes: 15);
  static const Duration ratings = Duration(minutes: 30);
}
