
part of 'verification_bloc.dart';

abstract class VerificationEvent extends Equatable {
  const VerificationEvent();

  @override
  List<Object?> get props => [];
}

class VerificationStarted extends VerificationEvent {}

class VerificationStepCompleted extends VerificationEvent {
  final int step;
  final double percentage;

  const VerificationStepCompleted(this.step, this.percentage);

  @override
  List<Object?> get props => [step, percentage];
}

class VerificationSubmitted extends VerificationEvent {}

class VerificationDraftSaved extends VerificationEvent {}
