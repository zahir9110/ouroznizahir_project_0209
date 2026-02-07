
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc() : super(VerificationInitial()) {
    on<VerificationStarted>(_onStarted);
    on<VerificationStepCompleted>(_onStepCompleted);
    on<VerificationSubmitted>(_onSubmitted);
    on<VerificationDraftSaved>(_onDraftSaved);
  }

  void _onStarted(VerificationStarted event, Emitter<VerificationState> emit) {
    emit(const VerificationInProgress(
      currentStep: 0,
      completionPercentage: 0.0,
    ));
  }

  void _onStepCompleted(VerificationStepCompleted event, Emitter<VerificationState> emit) {
    final currentState = state;
    if (currentState is VerificationInProgress) {
      emit(currentState.copyWith(
        currentStep: event.step,
        completionPercentage: event.percentage,
      ));
    }
  }

  void _onSubmitted(VerificationSubmitted event, Emitter<VerificationState> emit) async {
    emit(VerificationSubmitting());
    // TODO: Appel repository
    await Future.delayed(const Duration(seconds: 2));
    emit(VerificationSuccess());
  }

  void _onDraftSaved(VerificationDraftSaved event, Emitter<VerificationState> emit) {
    final currentState = state;
    if (currentState is VerificationInProgress) {
      emit(currentState.copyWith(lastSaved: DateTime.now()));
    }
  }
}
