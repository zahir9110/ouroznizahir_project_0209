import 'package:benin_experience/core/models/user_type.dart';

/// Offer Model
class Offer {
  final String id;
  final String organizerId;
  final OfferCategory category;
  final String title;
  final String description;
  final List<String> mediaUrls;
  final String locationName;
  final double? latitude;
  final double? longitude;
  final double? priceMin;
  final double? priceMax;
  final String currency;

  // Event/Tour specific
  final DateTime? eventDate;
  final DateTime? eventEndDate;
  final int? capacity;
  final int? availableSpots;

  // Accommodation specific
  final String? checkInTime;
  final String? checkOutTime;
  final List<String>? amenities;

  // Transport specific
  final String? vehicleType;
  final String? routeFrom;
  final String? routeTo;

  // Status & visibility
  final String status;
  final bool isFeatured;
  final DateTime? boostExpiresAt;
  final int viewsCount;
  final int likesCount;
  final int bookingsCount;

  final DateTime createdAt;
  final DateTime updatedAt;

  // Organizer info (populated)
  final String? organizerName;
  final String? organizerAvatar;
  final BadgeLevel? organizerBadge;
  final double? organizerRating;

  const Offer({
    required this.id,
    required this.organizerId,
    required this.category,
    required this.title,
    required this.description,
    required this.mediaUrls,
    required this.locationName,
    this.latitude,
    this.longitude,
    this.priceMin,
    this.priceMax,
    required this.currency,
    this.eventDate,
    this.eventEndDate,
    this.capacity,
    this.availableSpots,
    this.checkInTime,
    this.checkOutTime,
    this.amenities,
    this.vehicleType,
    this.routeFrom,
    this.routeTo,
    required this.status,
    required this.isFeatured,
    this.boostExpiresAt,
    required this.viewsCount,
    required this.likesCount,
    required this.bookingsCount,
    required this.createdAt,
    required this.updatedAt,
    this.organizerName,
    this.organizerAvatar,
    this.organizerBadge,
    this.organizerRating,
  });

  bool get isPublished => status == 'published';
  bool get isSoldOut => status == 'sold_out';
  bool get isBoosted =>
      boostExpiresAt != null && boostExpiresAt!.isAfter(DateTime.now());
  bool get hasLocation => latitude != null && longitude != null;
  bool get hasPrice => priceMin != null;

  String get displayPrice {
    if (priceMin == null) return 'Gratuit';
    if (priceMax != null && priceMax != priceMin) {
      return '${priceMin!.toStringAsFixed(0)} - ${priceMax!.toStringAsFixed(0)} $currency';
    }
    return '${priceMin!.toStringAsFixed(0)} $currency';
  }

  String get categoryIcon => category.icon;
  String get categoryName => category.displayName;

  Offer copyWith({
    String? id,
    String? organizerId,
    OfferCategory? category,
    String? title,
    String? description,
    List<String>? mediaUrls,
    String? locationName,
    double? latitude,
    double? longitude,
    double? priceMin,
    double? priceMax,
    String? currency,
    DateTime? eventDate,
    DateTime? eventEndDate,
    int? capacity,
    int? availableSpots,
    String? checkInTime,
    String? checkOutTime,
    List<String>? amenities,
    String? vehicleType,
    String? routeFrom,
    String? routeTo,
    String? status,
    bool? isFeatured,
    DateTime? boostExpiresAt,
    int? viewsCount,
    int? likesCount,
    int? bookingsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? organizerName,
    String? organizerAvatar,
    BadgeLevel? organizerBadge,
    double? organizerRating,
  }) {
    return Offer(
      id: id ?? this.id,
      organizerId: organizerId ?? this.organizerId,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      locationName: locationName ?? this.locationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      currency: currency ?? this.currency,
      eventDate: eventDate ?? this.eventDate,
      eventEndDate: eventEndDate ?? this.eventEndDate,
      capacity: capacity ?? this.capacity,
      availableSpots: availableSpots ?? this.availableSpots,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      amenities: amenities ?? this.amenities,
      vehicleType: vehicleType ?? this.vehicleType,
      routeFrom: routeFrom ?? this.routeFrom,
      routeTo: routeTo ?? this.routeTo,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
      boostExpiresAt: boostExpiresAt ?? this.boostExpiresAt,
      viewsCount: viewsCount ?? this.viewsCount,
      likesCount: likesCount ?? this.likesCount,
      bookingsCount: bookingsCount ?? this.bookingsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      organizerName: organizerName ?? this.organizerName,
      organizerAvatar: organizerAvatar ?? this.organizerAvatar,
      organizerBadge: organizerBadge ?? this.organizerBadge,
      organizerRating: organizerRating ?? this.organizerRating,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organizerId': organizerId,
      'category': category.name,
      'title': title,
      'description': description,
      'mediaUrls': mediaUrls,
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'priceMin': priceMin,
      'priceMax': priceMax,
      'currency': currency,
      'eventDate': eventDate?.toIso8601String(),
      'eventEndDate': eventEndDate?.toIso8601String(),
      'capacity': capacity,
      'availableSpots': availableSpots,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'amenities': amenities,
      'vehicleType': vehicleType,
      'routeFrom': routeFrom,
      'routeTo': routeTo,
      'status': status,
      'isFeatured': isFeatured,
      'boostExpiresAt': boostExpiresAt?.toIso8601String(),
      'viewsCount': viewsCount,
      'likesCount': likesCount,
      'bookingsCount': bookingsCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'organizerName': organizerName,
      'organizerAvatar': organizerAvatar,
      'organizerBadge': organizerBadge?.name,
      'organizerRating': organizerRating,
    };
  }

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] as String,
      organizerId: json['organizerId'] as String,
      category: OfferCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => OfferCategory.event,
      ),
      title: json['title'] as String,
      description: json['description'] as String,
      mediaUrls: (json['mediaUrls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      locationName: json['locationName'] as String,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      priceMin: json['priceMin'] != null
          ? (json['priceMin'] as num).toDouble()
          : null,
      priceMax: json['priceMax'] != null
          ? (json['priceMax'] as num).toDouble()
          : null,
      currency: json['currency'] as String? ?? 'XOF',
      eventDate: json['eventDate'] != null
          ? DateTime.parse(json['eventDate'] as String)
          : null,
      eventEndDate: json['eventEndDate'] != null
          ? DateTime.parse(json['eventEndDate'] as String)
          : null,
      capacity: json['capacity'] as int?,
      availableSpots: json['availableSpots'] as int?,
      checkInTime: json['checkInTime'] as String?,
      checkOutTime: json['checkOutTime'] as String?,
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      vehicleType: json['vehicleType'] as String?,
      routeFrom: json['routeFrom'] as String?,
      routeTo: json['routeTo'] as String?,
      status: json['status'] as String,
      isFeatured: json['isFeatured'] as bool,
      boostExpiresAt: json['boostExpiresAt'] != null
          ? DateTime.parse(json['boostExpiresAt'] as String)
          : null,
      viewsCount: json['viewsCount'] as int,
      likesCount: json['likesCount'] as int,
      bookingsCount: json['bookingsCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      organizerName: json['organizerName'] as String?,
      organizerAvatar: json['organizerAvatar'] as String?,
      organizerBadge: json['organizerBadge'] != null
          ? BadgeLevel.values.firstWhere(
              (e) => e.name == json['organizerBadge'],
              orElse: () => BadgeLevel.standard,
            )
          : null,
      organizerRating: json['organizerRating'] != null
          ? (json['organizerRating'] as num).toDouble()
          : null,
    );
  }
}
