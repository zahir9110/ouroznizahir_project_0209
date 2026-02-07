import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/user.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final List<Message> messages;
  final User otherParticipant;

  const ConversationLoaded({
    required this.messages,
    required this.otherParticipant,
  });

  @override
  List<Object> get props => [messages, otherParticipant];
}

class ConversationError extends ConversationState {
  final String message;

  const ConversationError(this.message);

  @override
  List<Object> get props => [message];
}

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object> get props => [];
}

class LoadConversation extends ConversationEvent {
  final String conversationId;

  const LoadConversation(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}

class MessageSent extends ConversationEvent {
  final Message message;

  const MessageSent(this.message);

  @override
  List<Object> get props => [message];
}

class TypingStarted extends ConversationEvent {
  final String conversationId;

  const TypingStarted(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}

class TypingStopped extends ConversationEvent {
  final String conversationId;

  const TypingStopped(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}
