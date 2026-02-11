import 'message.dart';
import 'user.dart';
import 'conversation_context.dart';

class Conversation {
  final String id;
  final User otherParticipant;
  final Message? lastMessage;
  final int unreadCount;
  final bool isPinned;
  final ConversationContext? context;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.otherParticipant,
    this.lastMessage,
    this.unreadCount = 0,
    this.isPinned = false,
    this.context,
    required this.updatedAt,
  });
}
