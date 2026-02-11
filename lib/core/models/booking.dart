import 'package:benin_experience/core/models/user_type.dart';

/// Booking Model
class Booking {
  final String id;
  final String offerId;
  final String userId;
  final String organizerId;
  final String bookingType;
  final BookingStatus status;
  final int quantity;
  final double totalPrice;
  final double commission;
  final double organizerPayout;
  final DateTime? bookingDate;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final PaymentStatus paymentStatus;
  final String? paymentMethod;
  final String? transactionId;
  final String? qrCode;
  final String bookingCode;
  final Map<String, dynamic>? customerDetails;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Populated fields
  final String? offerTitle;
  final String? offerImage;
  final String? organizerName;
  final String? userName;

  const Booking({
    required this.id,
    required this.offerId,
    required this.userId,
    required this.organizerId,
    required this.bookingType,
    required this.status,
    required this.quantity,
    required this.totalPrice,
    required this.commission,
    required this.organizerPayout,
    this.bookingDate,
    this.checkInDate,
    this.checkOutDate,
    required this.paymentStatus,
    this.paymentMethod,
    this.transactionId,
    this.qrCode,
    required this.bookingCode,
    this.customerDetails,
    required this.createdAt,
    required this.updatedAt,
    this.offerTitle,
    this.offerImage,
    this.organizerName,
    this.userName,
  });

  bool get isPaid => paymentStatus == PaymentStatus.paid;
  bool get isConfirmed => status == BookingStatus.confirmed;
  bool get isCompleted => status == BookingStatus.completed;
  bool get canCancel => status.canCancel;
  bool get canReview => status.canReview;

  String get statusDisplay => status.displayName;
  String get paymentStatusDisplay => paymentStatus.displayName;

  Booking copyWith({
    String? id,
    String? offerId,
    String? userId,
    String? organizerId,
    String? bookingType,
    BookingStatus? status,
    int? quantity,
    double? totalPrice,
    double? commission,
    double? organizerPayout,
    DateTime? bookingDate,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    PaymentStatus? paymentStatus,
    String? paymentMethod,
    String? transactionId,
    String? qrCode,
    String? bookingCode,
    Map<String, dynamic>? customerDetails,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? offerTitle,
    String? offerImage,
    String? organizerName,
    String? userName,
  }) {
    return Booking(
      id: id ?? this.id,
      offerId: offerId ?? this.offerId,
      userId: userId ?? this.userId,
      organizerId: organizerId ?? this.organizerId,
      bookingType: bookingType ?? this.bookingType,
      status: status ?? this.status,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      commission: commission ?? this.commission,
      organizerPayout: organizerPayout ?? this.organizerPayout,
      bookingDate: bookingDate ?? this.bookingDate,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      qrCode: qrCode ?? this.qrCode,
      bookingCode: bookingCode ?? this.bookingCode,
      customerDetails: customerDetails ?? this.customerDetails,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      offerTitle: offerTitle ?? this.offerTitle,
      offerImage: offerImage ?? this.offerImage,
      organizerName: organizerName ?? this.organizerName,
      userName: userName ?? this.userName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'offerId': offerId,
      'userId': userId,
      'organizerId': organizerId,
      'bookingType': bookingType,
      'status': status.name,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'commission': commission,
      'organizerPayout': organizerPayout,
      'bookingDate': bookingDate?.toIso8601String(),
      'checkInDate': checkInDate?.toIso8601String(),
      'checkOutDate': checkOutDate?.toIso8601String(),
      'paymentStatus': paymentStatus.name,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'qrCode': qrCode,
      'bookingCode': bookingCode,
      'customerDetails': customerDetails,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'offerTitle': offerTitle,
      'offerImage': offerImage,
      'organizerName': organizerName,
      'userName': userName,
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      offerId: json['offerId'] as String,
      userId: json['userId'] as String,
      organizerId: json['organizerId'] as String,
      bookingType: json['bookingType'] as String,
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      quantity: json['quantity'] as int,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      commission: (json['commission'] as num).toDouble(),
      organizerPayout: (json['organizerPayout'] as num).toDouble(),
      bookingDate: json['bookingDate'] != null
          ? DateTime.parse(json['bookingDate'] as String)
          : null,
      checkInDate: json['checkInDate'] != null
          ? DateTime.parse(json['checkInDate'] as String)
          : null,
      checkOutDate: json['checkOutDate'] != null
          ? DateTime.parse(json['checkOutDate'] as String)
          : null,
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == json['paymentStatus'],
        orElse: () => PaymentStatus.pending,
      ),
      paymentMethod: json['paymentMethod'] as String?,
      transactionId: json['transactionId'] as String?,
      qrCode: json['qrCode'] as String?,
      bookingCode: json['bookingCode'] as String,
      customerDetails: json['customerDetails'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      offerTitle: json['offerTitle'] as String?,
      offerImage: json['offerImage'] as String?,
      organizerName: json['organizerName'] as String?,
      userName: json['userName'] as String?,
    );
  }
}

/// Review Model
class Review {
  final String id;
  final String bookingId;
  final String offerId;
  final String organizerId;
  final String userId;
  final int rating;
  final String? comment;
  final List<String>? photos;
  final bool isVerified;
  final bool isVisible;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Populated
  final String? userName;
  final String? userAvatar;

  const Review({
    required this.id,
    required this.bookingId,
    required this.offerId,
    required this.organizerId,
    required this.userId,
    required this.rating,
    this.comment,
    this.photos,
    required this.isVerified,
    required this.isVisible,
    required this.createdAt,
    required this.updatedAt,
    this.userName,
    this.userAvatar,
  });

  String get ratingStars => '⭐' * rating;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'offerId': offerId,
      'organizerId': organizerId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'photos': photos,
      'isVerified': isVerified,
      'isVisible': isVisible,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userName': userName,
      'userAvatar': userAvatar,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      offerId: json['offerId'] as String,
      organizerId: json['organizerId'] as String,
      userId: json['userId'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      photos:
          (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      isVerified: json['isVerified'] as bool,
      isVisible: json['isVisible'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userName: json['userName'] as String?,
      userAvatar: json['userAvatar'] as String?,
    );
  }
}
