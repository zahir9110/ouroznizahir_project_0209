
part of 'verification_bloc.dart';

abstract class VerificationState extends Equatable {
  const VerificationState();

  @override
  List<Object?> get props => [];
}

class VerificationInitial extends VerificationState {}

class VerificationInProgress extends VerificationState {
  final int currentStep;
  final double completionPercentage;
  final DateTime? lastSaved;
  final VerificationSubmissionStatus submissionStatus;
  
  // Form data
  final String fullName;
  final String? professionalType;
  final List<String> placePhotos;
  
  // Step validation flags
  final bool stepIdentityValid;
  final bool stepProfessionalValid;
  final bool stepLocationValid;
  final bool stepDocumentsValid;
  final bool stepMediaValid;
  final bool stepHistoryValid;
  
  // Overall category validation (for 3-question model)
  final bool identityValid;
  final bool legitimacyValid;
  final bool trustValid;

  const VerificationInProgress({
    required this.currentStep,
    required this.completionPercentage,
    this.lastSaved,
    this.submissionStatus = VerificationSubmissionStatus.initial,
    this.fullName = '',
    this.professionalType,
    this.placePhotos = const [],
    this.stepIdentityValid = false,
    this.stepProfessionalValid = false,
    this.stepLocationValid = false,
    this.stepDocumentsValid = false,
    this.stepMediaValid = false,
    this.stepHistoryValid = false,
    this.identityValid = false,
    this.legitimacyValid = false,
    this.trustValid = false,
  });

  double get completionProgress => completionPercentage / 100;
  
  bool get isReadyForSubmission => 
    identityValid && legitimacyValid && trustValid;

  VerificationInProgress copyWith({
    int? currentStep,
    double? completionPercentage,
    DateTime? lastSaved,
    VerificationSubmissionStatus? submissionStatus,
    String? fullName,
    String? professionalType,
    List<String>? placePhotos,
    bool? stepIdentityValid,
    bool? stepProfessionalValid,
    bool? stepLocationValid,
    bool? stepDocumentsValid,
    bool? stepMediaValid,
    bool? stepHistoryValid,
    bool? identityValid,
    bool? legitimacyValid,
    bool? trustValid,
  }) {
    return VerificationInProgress(
      currentStep: currentStep ?? this.currentStep,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      lastSaved: lastSaved ?? this.lastSaved,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      fullName: fullName ?? this.fullName,
      professionalType: professionalType ?? this.professionalType,
      placePhotos: placePhotos ?? this.placePhotos,
      stepIdentityValid: stepIdentityValid ?? this.stepIdentityValid,
      stepProfessionalValid: stepProfessionalValid ?? this.stepProfessionalValid,
      stepLocationValid: stepLocationValid ?? this.stepLocationValid,
      stepDocumentsValid: stepDocumentsValid ?? this.stepDocumentsValid,
      stepMediaValid: stepMediaValid ?? this.stepMediaValid,
      stepHistoryValid: stepHistoryValid ?? this.stepHistoryValid,
      identityValid: identityValid ?? this.identityValid,
      legitimacyValid: legitimacyValid ?? this.legitimacyValid,
      trustValid: trustValid ?? this.trustValid,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    completionPercentage,
    lastSaved,
    submissionStatus,
    fullName,
    professionalType,
    placePhotos,
    stepIdentityValid,
    stepProfessionalValid,
    stepLocationValid,
    stepDocumentsValid,
    stepMediaValid,
    stepHistoryValid,
    identityValid,
    legitimacyValid,
    trustValid,
  ];
}

class VerificationSubmitting extends VerificationState {}

class VerificationSuccess extends VerificationState {}

class VerificationFailure extends VerificationState {
  final String error;

  const VerificationFailure(this.error);

  @override
  List<Object?> get props => [error];
}

enum VerificationSubmissionStatus {
  initial,
  submitting,
  success,
  failure,
}
