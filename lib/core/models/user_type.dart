/// User Type Enum
enum UserType {
  traveler,
  organizer,
  admin;

  String get displayName {
    switch (this) {
      case UserType.traveler:
        return 'Voyageur';
      case UserType.organizer:
        return 'Organisateur';
      case UserType.admin:
        return 'Administrateur';
    }
  }

  bool get isOrganizer => this == UserType.organizer;
  bool get isTraveler => this == UserType.traveler;
  bool get isAdmin => this == UserType.admin;
}

/// Organizer Badge Level
enum BadgeLevel {
  standard,
  verified,
  premium,
  enterprise;

  String get displayName {
    switch (this) {
      case BadgeLevel.standard:
        return 'Standard';
      case BadgeLevel.verified:
        return 'Vérifié';
      case BadgeLevel.premium:
        return 'Premium';
      case BadgeLevel.enterprise:
        return 'Enterprise';
    }
  }

  String get icon {
    switch (this) {
      case BadgeLevel.standard:
        return '⚪';
      case BadgeLevel.verified:
        return '✓';
      case BadgeLevel.premium:
        return '⭐';
      case BadgeLevel.enterprise:
        return '👑';
    }
  }
}

/// Subscription Tier
enum SubscriptionTier {
  free,
  plus,
  enterprise;

  String get displayName {
    switch (this) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.plus:
        return 'Plus';
      case SubscriptionTier.enterprise:
        return 'Enterprise';
    }
  }

  double get commissionRate {
    switch (this) {
      case SubscriptionTier.free:
        return 8.0; // 8%
      case SubscriptionTier.plus:
        return 5.0; // 5%
      case SubscriptionTier.enterprise:
        return 3.0; // 3%
    }
  }

  int get monthlyPrice {
    switch (this) {
      case SubscriptionTier.free:
        return 0;
      case SubscriptionTier.plus:
        return 15000; // XOF
      case SubscriptionTier.enterprise:
        return 0; // Sur devis
    }
  }
}

/// Offer Category
enum OfferCategory {
  event,
  tour,
  accommodation,
  transport,
  site;

  String get displayName {
    switch (this) {
      case OfferCategory.event:
        return 'Événement';
      case OfferCategory.tour:
        return 'Visite guidée';
      case OfferCategory.accommodation:
        return 'Hébergement';
      case OfferCategory.transport:
        return 'Transport';
      case OfferCategory.site:
        return 'Site touristique';
    }
  }

  String get icon {
    switch (this) {
      case OfferCategory.event:
        return '🎉';
      case OfferCategory.tour:
        return '🗺️';
      case OfferCategory.accommodation:
        return '🏨';
      case OfferCategory.transport:
        return '🚗';
      case OfferCategory.site:
        return '🏛️';
    }
  }
}

/// Booking Status
enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
  refunded;

  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'En attente';
      case BookingStatus.confirmed:
        return 'Confirmé';
      case BookingStatus.cancelled:
        return 'Annulé';
      case BookingStatus.completed:
        return 'Terminé';
      case BookingStatus.refunded:
        return 'Remboursé';
    }
  }

  bool get canCancel =>
      this == BookingStatus.pending || this == BookingStatus.confirmed;
  bool get canReview => this == BookingStatus.completed;
}

/// Payment Status
enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded;

  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'En attente';
      case PaymentStatus.paid:
        return 'Payé';
      case PaymentStatus.failed:
        return 'Échoué';
      case PaymentStatus.refunded:
        return 'Remboursé';
    }
  }

  bool get isSuccess => this == PaymentStatus.paid;
  bool get isPending => this == PaymentStatus.pending;
}

/// Verification Status
enum VerificationStatus {
  pending,
  approved,
  rejected;

  String get displayName {
    switch (this) {
      case VerificationStatus.pending:
        return 'En attente';
      case VerificationStatus.approved:
        return 'Approuvé';
      case VerificationStatus.rejected:
        return 'Rejeté';
    }
  }

  bool get isApproved => this == VerificationStatus.approved;
  bool get isPending => this == VerificationStatus.pending;
}
