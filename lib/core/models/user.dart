import 'package:benin_experience/core/models/user_type.dart';

/// User Model
class User {
  final String id;
  final String firebaseUid;
  final String email;
  final String? phone;
  final String fullName;
  final String? avatarUrl;
  final String? bio;
  final UserType userType;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.firebaseUid,
    required this.email,
    this.phone,
    required this.fullName,
    this.avatarUrl,
    this.bio,
    required this.userType,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOrganizer => userType.isOrganizer;
  bool get isTraveler => userType.isTraveler;
  bool get isAdmin => userType.isAdmin;

  String get displayName => fullName;
  String get initials {
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.substring(0, 2).toUpperCase();
  }

  User copyWith({
    String? id,
    String? firebaseUid,
    String? email,
    String? phone,
    String? fullName,
    String? avatarUrl,
    String? bio,
    UserType? userType,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      userType: userType ?? this.userType,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firebaseUid': firebaseUid,
      'email': email,
      'phone': phone,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'userType': userType.name,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      firebaseUid: json['firebaseUid'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      fullName: json['fullName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      userType: UserType.values.firstWhere(
        (e) => e.name == json['userType'],
        orElse: () => UserType.traveler,
      ),
      isVerified: json['isVerified'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
