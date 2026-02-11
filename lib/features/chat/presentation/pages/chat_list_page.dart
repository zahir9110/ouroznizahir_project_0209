import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/message.dart';
import 'conversation_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  // Mock data - À remplacer par un vrai état BLoC plus tard
  late List<Conversation> _conversations;

  @override
  void initState() {
    super.initState();
    _conversations = _getMockConversations();
  }

  List<Conversation> _getMockConversations() {
    return [
      Conversation(
        id: 'conv_1',
        otherParticipant: User(
          id: 'user_1',
          name: 'Marie Kouassi',
          avatar: 'https://i.pravatar.cc/150?img=1',
          isOnline: true,
        ),
        lastMessage: Message(
          senderId: 'user_1',
          type: MessageType.text,
          content: MessageContent(text: 'Salut ! Tu es disponible pour le festival ce weekend ?'),
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          status: MessageStatus.read,
        ),
        unreadCount: 2,
        isPinned: true,
        updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Conversation(
        id: 'conv_2',
        otherParticipant: User(
          id: 'user_2',
          name: 'Jean Dupont',
          avatar: 'https://i.pravatar.cc/150?img=2',
          isOnline: false,
          lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        lastMessage: Message(
          senderId: 'current_user',
          type: MessageType.text,
          content: MessageContent(text: 'D\'accord, à plus tard !'),
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          status: MessageStatus.delivered,
        ),
        unreadCount: 0,
        updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      Conversation(
        id: 'conv_3',
        otherParticipant: User(
          id: 'user_3',
          name: 'Sarah Martin',
          avatar: 'https://i.pravatar.cc/150?img=3',
          isOnline: true,
        ),
        lastMessage: Message(
          senderId: 'user_3',
          type: MessageType.image,
          content: MessageContent(
            text: '📷 Photo',
            url: 'https://picsum.photos/200',
          ),
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          status: MessageStatus.read,
        ),
        unreadCount: 0,
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Conversation(
        id: 'conv_4',
        otherParticipant: User(
          id: 'user_4',
          name: 'Ahmed Diallo',
          avatar: 'https://i.pravatar.cc/150?img=4',
          isOnline: false,
          lastSeen: DateTime.now().subtract(const Duration(days: 2)),
        ),
        lastMessage: Message(
          senderId: 'user_4',
          type: MessageType.text,
          content: MessageContent(text: 'Merci pour les billets !'),
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          status: MessageStatus.read,
        ),
        unreadCount: 0,
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Maintenant';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}j';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String _getMessagePreview(Message message) {
    switch (message.type) {
      case MessageType.text:
        return message.content.text ?? '';
      case MessageType.image:
        return '📷 Photo';
      case MessageType.audio:
        return '🎤 Message vocal';
      case MessageType.postShare:
        return '📄 Publication partagée';
      case MessageType.location:
        return '📍 Position';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Messages',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: Implémenter la recherche
              debugPrint('Recherche de conversations');
            },
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: AppColors.primary),
            onPressed: () {
              // TODO: Nouvelle conversation
              debugPrint('Nouvelle conversation');
            },
          ),
        ],
      ),
      body: _conversations.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                final conversation = _conversations[index];
                return _buildConversationItem(conversation);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80.r,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            'Aucun message',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Commencez une conversation',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationItem(Conversation conversation) {
    final user = conversation.otherParticipant;
    final lastMessage = conversation.lastMessage;
    final isUnread = conversation.unreadCount > 0;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationPage(
              conversationId: conversation.id,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isUnread ? AppColors.primary.withOpacity(0.05) : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: AppColors.background,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Avatar avec badge online
            Stack(
              children: [
                CircleAvatar(
                  radius: 28.r,
                  backgroundImage: NetworkImage(user.avatar),
                ),
                if (user.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 16.r,
                      height: 16.r,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                if (conversation.isPinned)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2.r),
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.push_pin,
                        size: 12.r,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12.w),
            // Contenu de la conversation
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          user.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (lastMessage != null)
                        Text(
                          _formatTimestamp(lastMessage.timestamp),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isUnread ? AppColors.primary : AppColors.textSecondary,
                            fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      // Indicateur de statut pour les messages envoyés
                      if (lastMessage != null && lastMessage.senderId == 'current_user')
                        Padding(
                          padding: EdgeInsets.only(right: 4.w),
                          child: Icon(
                            lastMessage.status == MessageStatus.read
                                ? Icons.done_all
                                : lastMessage.status == MessageStatus.delivered
                                    ? Icons.done_all
                                    : Icons.done,
                            size: 16.r,
                            color: lastMessage.status == MessageStatus.read
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          lastMessage != null ? _getMessagePreview(lastMessage) : 'Aucun message',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isUnread ? AppColors.textPrimary : AppColors.textSecondary,
                            fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          margin: EdgeInsets.only(left: 8.w),
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            conversation.unreadCount > 99
                                ? '99+'
                                : '${conversation.unreadCount}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
