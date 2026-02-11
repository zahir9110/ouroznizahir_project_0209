import 'package:benin_experience/core/models/user_type.dart';

/// Organizer Profile Model
class Organizer {
  final String id;
  final String userId;
  final String businessName;
  final String? businessType;
  final String? businessRegistration;
  final String? taxId;
  final VerificationStatus verificationStatus;
  final List<String>? verificationDocuments;
  final BadgeLevel badgeLevel;
  final double commissionRate;
  final double totalRevenue;
  final int totalBookings;
  final double ratingAverage;
  final int ratingCount;
  final Map<String, dynamic>? bankAccount;
  final SubscriptionTier subscriptionTier;
  final DateTime? subscriptionExpiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Organizer({
    required this.id,
    required this.userId,
    required this.businessName,
    this.businessType,
    this.businessRegistration,
    this.taxId,
    required this.verificationStatus,
    this.verificationDocuments,
    required this.badgeLevel,
    required this.commissionRate,
    required this.totalRevenue,
    required this.totalBookings,
    required this.ratingAverage,
    required this.ratingCount,
    this.bankAccount,
    required this.subscriptionTier,
    this.subscriptionExpiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isVerified => verificationStatus == VerificationStatus.approved;
  bool get hasPremium => subscriptionTier != SubscriptionTier.free;
  bool get hasActiveSubscription {
    if (subscriptionExpiresAt == null) return false;
    return subscriptionExpiresAt!.isAfter(DateTime.now());
  }

  String get displayRating => ratingAverage.toStringAsFixed(1);
  String get badgeIcon => badgeLevel.icon;

  Organizer copyWith({
    String? id,
    String? userId,
    String? businessName,
    String? businessType,
    String? businessRegistration,
    String? taxId,
    VerificationStatus? verificationStatus,
    List<String>? verificationDocuments,
    BadgeLevel? badgeLevel,
    double? commissionRate,
    double? totalRevenue,
    int? totalBookings,
    double? ratingAverage,
    int? ratingCount,
    Map<String, dynamic>? bankAccount,
    SubscriptionTier? subscriptionTier,
    DateTime? subscriptionExpiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Organizer(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      businessRegistration: businessRegistration ?? this.businessRegistration,
      taxId: taxId ?? this.taxId,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      verificationDocuments:
          verificationDocuments ?? this.verificationDocuments,
      badgeLevel: badgeLevel ?? this.badgeLevel,
      commissionRate: commissionRate ?? this.commissionRate,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalBookings: totalBookings ?? this.totalBookings,
      ratingAverage: ratingAverage ?? this.ratingAverage,
      ratingCount: ratingCount ?? this.ratingCount,
      bankAccount: bankAccount ?? this.bankAccount,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      subscriptionExpiresAt:
          subscriptionExpiresAt ?? this.subscriptionExpiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'businessName': businessName,
      'businessType': businessType,
      'businessRegistration': businessRegistration,
      'taxId': taxId,
      'verificationStatus': verificationStatus.name,
      'verificationDocuments': verificationDocuments,
      'badgeLevel': badgeLevel.name,
      'commissionRate': commissionRate,
      'totalRevenue': totalRevenue,
      'totalBookings': totalBookings,
      'ratingAverage': ratingAverage,
      'ratingCount': ratingCount,
      'bankAccount': bankAccount,
      'subscriptionTier': subscriptionTier.name,
      'subscriptionExpiresAt': subscriptionExpiresAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
      id: json['id'] as String,
      userId: json['userId'] as String,
      businessName: json['businessName'] as String,
      businessType: json['businessType'] as String?,
      businessRegistration: json['businessRegistration'] as String?,
      taxId: json['taxId'] as String?,
      verificationStatus: VerificationStatus.values.firstWhere(
        (e) => e.name == json['verificationStatus'],
        orElse: () => VerificationStatus.pending,
      ),
      verificationDocuments: (json['verificationDocuments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      badgeLevel: BadgeLevel.values.firstWhere(
        (e) => e.name == json['badgeLevel'],
        orElse: () => BadgeLevel.standard,
      ),
      commissionRate: (json['commissionRate'] as num).toDouble(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalBookings: json['totalBookings'] as int,
      ratingAverage: (json['ratingAverage'] as num).toDouble(),
      ratingCount: json['ratingCount'] as int,
      bankAccount: json['bankAccount'] as Map<String, dynamic>?,
      subscriptionTier: SubscriptionTier.values.firstWhere(
        (e) => e.name == json['subscriptionTier'],
        orElse: () => SubscriptionTier.free,
      ),
      subscriptionExpiresAt: json['subscriptionExpiresAt'] != null
          ? DateTime.parse(json['subscriptionExpiresAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

/// Dashboard Statistics
class DashboardStats {
  final double monthlyRevenue;
  final int monthlyBookings;
  final double confirmationRate;
  final double averageRating;
  final List<OfferPerformance> topOffers;
  final Map<String, int> bookingsByRegion;
  final DateTime? nextPayoutDate;
  final double nextPayoutAmount;

  const DashboardStats({
    required this.monthlyRevenue,
    required this.monthlyBookings,
    required this.confirmationRate,
    required this.averageRating,
    required this.topOffers,
    required this.bookingsByRegion,
    this.nextPayoutDate,
    required this.nextPayoutAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'monthlyRevenue': monthlyRevenue,
      'monthlyBookings': monthlyBookings,
      'confirmationRate': confirmationRate,
      'averageRating': averageRating,
      'topOffers': topOffers.map((e) => e.toJson()).toList(),
      'bookingsByRegion': bookingsByRegion,
      'nextPayoutDate': nextPayoutDate?.toIso8601String(),
      'nextPayoutAmount': nextPayoutAmount,
    };
  }

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      monthlyRevenue: (json['monthlyRevenue'] as num).toDouble(),
      monthlyBookings: json['monthlyBookings'] as int,
      confirmationRate: (json['confirmationRate'] as num).toDouble(),
      averageRating: (json['averageRating'] as num).toDouble(),
      topOffers: (json['topOffers'] as List<dynamic>)
          .map((e) => OfferPerformance.fromJson(e as Map<String, dynamic>))
          .toList(),
      bookingsByRegion: Map<String, int>.from(json['bookingsByRegion']),
      nextPayoutDate: json['nextPayoutDate'] != null
          ? DateTime.parse(json['nextPayoutDate'] as String)
          : null,
      nextPayoutAmount: (json['nextPayoutAmount'] as num).toDouble(),
    );
  }
}

/// Offer Performance
class OfferPerformance {
  final String offerId;
  final String offerTitle;
  final double revenue;
  final int bookingsCount;
  final double conversionRate;

  const OfferPerformance({
    required this.offerId,
    required this.offerTitle,
    required this.revenue,
    required this.bookingsCount,
    required this.conversionRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'offerId': offerId,
      'offerTitle': offerTitle,
      'revenue': revenue,
      'bookingsCount': bookingsCount,
      'conversionRate': conversionRate,
    };
  }

  factory OfferPerformance.fromJson(Map<String, dynamic> json) {
    return OfferPerformance(
      offerId: json['offerId'] as String,
      offerTitle: json['offerTitle'] as String,
      revenue: (json['revenue'] as num).toDouble(),
      bookingsCount: json['bookingsCount'] as int,
      conversionRate: (json['conversionRate'] as num).toDouble(),
    );
  }
}
