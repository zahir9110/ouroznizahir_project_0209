
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum VerificationStatus {
  draft,
  submitted,
  aiProcessing,
  humanReview,
  approved,
  rejected,
  appealed,
}

enum ProfessionalType {
  hotel,
  restaurant,
  eventOrganizer,
  tourGuide,
  culturalSite,
  transport,
  artisan,
}

class VerificationRequest extends Equatable {
  final String id;
  final String userId;
  final VerificationStatus status;
  final ProfessionalType type;
  final String businessName;
  final String description;
  final List<String> documents;
  final GeoPoint location;
  final String address;
  final String phoneNumber;
  final String? website;
  final String? socialMedia;
  final String? traditionalAuthority;
  final List<String>? culturalAffiliation;
  final List<String> localReferences;
  final Map<String, dynamic>? aiAnalysis;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final String? reviewerNotes;

  const VerificationRequest({
    required this.id,
    required this.userId,
    this.status = VerificationStatus.draft,
    required this.type,
    required this.businessName,
    required this.description,
    this.documents = const [],
    required this.location,
    required this.address,
    required this.phoneNumber,
    this.website,
    this.socialMedia,
    this.traditionalAuthority,
    this.culturalAffiliation,
    this.localReferences = const [],
    this.aiAnalysis,
    this.submittedAt,
    this.reviewedAt,
    this.reviewerNotes,
  });

  @override
  List<Object?> get props => [id, userId, status, businessName];
}