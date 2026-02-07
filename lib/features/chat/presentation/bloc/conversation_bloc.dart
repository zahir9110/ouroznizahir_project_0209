import 'package:flutter_bloc/flutter_bloc.dart';
import 'conversation_event.dart';
import '../../domain/entities/user.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc() : super(ConversationInitial()) {
    on<LoadConversation>(_onLoadConversation);
    on<MessageSent>(_onMessageSent);
    on<TypingStarted>(_onTypingStarted);
    on<TypingStopped>(_onTypingStopped);
  }

  Future<void> _onLoadConversation(
    LoadConversation event,
    Emitter<ConversationState> emit,
  ) async {
    emit(ConversationLoading());
    // TODO: Implement actual conversation loading logic
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data for now
    final mockUser = User(
      id: 'user_2',
      name: 'Jean Dupont',
      avatar: 'https://via.placeholder.com/150',
      isOnline: true,
    );
    
    emit(ConversationLoaded(
      messages: const [],
      otherParticipant: mockUser,
    ));
  }

  Future<void> _onMessageSent(
    MessageSent event,
    Emitter<ConversationState> emit,
  ) async {
    if (state is ConversationLoaded) {
      final currentState = state as ConversationLoaded;
      final updatedMessages = [event.message, ...currentState.messages];
      
      emit(ConversationLoaded(
        messages: updatedMessages,
        otherParticipant: currentState.otherParticipant,
      ));
    }
  }

  Future<void> _onTypingStarted(
    TypingStarted event,
    Emitter<ConversationState> emit,
  ) async {
    // TODO: Implement typing indicator logic
  }

  Future<void> _onTypingStopped(
    TypingStopped event,
    Emitter<ConversationState> emit,
  ) async {
    // TODO: Implement typing indicator logic
  }
}
