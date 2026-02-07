import 'package:cloud_firestore/cloud_firestore.dart';

class VerificationRequest {
  final String id;
  final String userId;
  final ProfessionalType type; // hotel, restaurant, cultural_site, event_organizer
  final String businessName;
  final String description;
  final List<String> documents; // CAC, licences, photos du lieu
  final GeoPoint location;
  final String address;
  final String phoneNumber;
  final String? website;
  final String? socialMedia;
  
  // Données culturelles spécifiques au Bénin
  final String? traditionalAuthority; // Chef de village, roi local...
  final String? culturalAffiliation; // Ethnie, tradition associée
  final List<String> localReferences; // Personnes ressources locales
  
  final VerificationStatus status;
  final Map<String, dynamic>? aiAnalysis;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final String? reviewerNotes;

  const VerificationRequest({
    required this.id,
    required this.userId,
    required this.type,
    required this.businessName,
    required this.description,
    required this.documents,
    required this.location,
    required this.address,
    required this.phoneNumber,
    this.website,
    this.socialMedia,
    this.traditionalAuthority,
    this.culturalAffiliation,
    this.localReferences = const [],
    required this.status,
    this.aiAnalysis,
    required this.submittedAt,
    this.reviewedAt,
    this.reviewerNotes,
  });
}

enum ProfessionalType {
  hotel,
  restaurant,
  culturalSite,
  eventOrganizer,
  tourGuide,
  artisan,
  transport
}

enum VerificationStatus {
  pending,
  aiProcessing,
  humanReview,
  approved,
  rejected,
  additionalInfoRequired
}
