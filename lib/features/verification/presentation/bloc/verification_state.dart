
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
  
  // Validation flags
  final bool identityValid;
  final bool legalValid;
  final bool locationValid;
  final bool mediaValid;
  final bool offerValid;

  const VerificationInProgress({
    required this.currentStep,
    required this.completionPercentage,
    this.lastSaved,
    this.identityValid = false,
    this.legalValid = false,
    this.locationValid = false,
    this.mediaValid = false,
    this.offerValid = false,
  });

  VerificationInProgress copyWith({
    int? currentStep,
    double? completionPercentage,
    DateTime? lastSaved,
    bool? identityValid,
    bool? legalValid,
    bool? locationValid,
    bool? mediaValid,
    bool? offerValid,
  }) {
    return VerificationInProgress(
      currentStep: currentStep ?? this.currentStep,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      lastSaved: lastSaved ?? this.lastSaved,
      identityValid: identityValid ?? this.identityValid,
      legalValid: legalValid ?? this.legalValid,
      locationValid: locationValid ?? this.locationValid,
      mediaValid: mediaValid ?? this.mediaValid,
      offerValid: offerValid ?? this.offerValid,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    completionPercentage,
    lastSaved,
    identityValid,
    legalValid,
    locationValid,
    mediaValid,
    offerValid,
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
