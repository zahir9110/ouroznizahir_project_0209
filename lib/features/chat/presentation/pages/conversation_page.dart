import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/conversation_context.dart';
import '../../domain/entities/message.dart';
import '../bloc/conversation_bloc.dart';
import '../bloc/conversation_event.dart';
import '../widgets/message_widgets.dart';

class ConversationPage extends StatefulWidget {
  final String conversationId;
  final ConversationContext? initialContext;  // Si nouvelle conversation

  const ConversationPage({
    super.key, 
    required this.conversationId,
    this.initialContext,
  });

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage>
    with WidgetsBindingObserver {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;
  bool _showEphemeralOptions = false;
  ConversationContext? _contextData;
  int? _ephemeralDuration;
  
  // Mock current user ID - in real app this would come from auth service
  static const String currentUserId = 'user_1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildContextualAppBar(),  // <-- Clé: contexte visible
      body: Column(
        children: [
          // Référence contextuelle (événement/lieu)
          if (_contextData != null) _buildContextHeader(),
          
          // Messages
          Expanded(
            child: _buildMessageList(),
          ),
          
          // Zone de saisie enrichie
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildContextualAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leadingWidth: 40,
      title: BlocBuilder<ConversationBloc, ConversationState>(
        builder: (context, state) {
          if (state is ConversationLoaded) {
            final otherUser = state.otherParticipant;
            return Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(otherUser.avatar),
                    ),
                    if (otherUser.isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        otherUser.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        otherUser.isOnline 
                            ? 'En ligne' 
                            : 'Vu ${_formatLastSeen(otherUser.lastSeen)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
      actions: [
        // Mode éphémère toggle
        IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              _showEphemeralOptions 
                  ? Icons.timer 
                  : Icons.timer_outlined,
              key: ValueKey(_showEphemeralOptions),
              color: _showEphemeralOptions 
                  ? Colors.orange.shade700 
                  : null,
            ),
          ),
          onPressed: () {
            setState(() => _showEphemeralOptions = !_showEphemeralOptions);
          },
        ),
        // Options conversation
        PopupMenuButton<String>(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'block',
              child: Text('Bloquer'),
            ),
            const PopupMenuItem(
              value: 'report',
              child: Text('Signaler'),
            ),
            const PopupMenuItem(
              value: 'clear',
              child: Text('Vider la conversation'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContextHeader() {
    final context = _contextData!;
    
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              context.referenceImage,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'À propos de',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.referenceTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (context.referenceDate != null)
                  Text(
                    '📅 ${DateFormat('dd MMM').format(context.referenceDate!)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.orange.shade700,
                    ),
                  ),
              ],
            ),
          ),
          // CTA contextuel
          if (context.type == 'event_booking')
            FilledButton(
              onPressed: () => _showBookingOptions(),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text('Réserver'),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return BlocBuilder<ConversationBloc, ConversationState>(
      builder: (context, state) {
        if (state is ConversationLoaded) {
          final messages = state.messages;
          
          return ListView.builder(
            controller: _scrollController,
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final showDate = index == messages.length - 1 ||
                  !_isSameDay(message.timestamp, messages[index + 1].timestamp);
              
              return Column(
                children: [
                  if (showDate) _buildDateSeparator(message.timestamp),
                  _buildMessageBubble(message),
                ],
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isMe = message.senderId == currentUserId;
    final isEphemeral = message.ephemeral?.enabled ?? false;
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: GestureDetector(
          onLongPress: () => _showMessageOptions(message),
          child: Column(
            crossAxisAlignment: isMe 
                ? CrossAxisAlignment.end 
                : CrossAxisAlignment.start,
            children: [
              // Contenu du message
              Container(
                margin: const EdgeInsets.only(bottom: 2),
                padding: _getPaddingForType(message.type),
                decoration: BoxDecoration(
                  color: isMe 
                      ? Colors.orange.shade700 
                      : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isMe ? 20 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _buildMessageContent(message, isMe),
              ),
              
              // Métadonnées (heure + statut)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isEphemeral)
                      Icon(
                        Icons.timer,
                        size: 12,
                        color: Colors.grey.shade500,
                      ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(message.timestamp),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Icon(
                        message.status == MessageStatus.read 
                            ? Icons.done_all 
                            : Icons.done,
                        size: 14,
                        color: message.status == MessageStatus.read 
                            ? Colors.blue.shade400 
                            : Colors.grey.shade400,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent(Message message, bool isMe) {
    final textColor = isMe ? Colors.white : Colors.black87;
    
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content.text!,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        );
        
      case MessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.network(
                message.content.url!,
                width: 200,
                fit: BoxFit.cover,
              ),
              if (message.ephemeral?.enabled ?? false)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.timer,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        );
        
      case MessageType.audio:
        return AudioMessagePlayer(
          url: message.content.url!,
          duration: message.content.duration!,
          isMe: isMe,
        );
        
      case MessageType.postShare:
        return PostSharePreview(
          postData: message.content.postPreview!,
          isCompact: true,
        );
        
      case MessageType.location:
        return LocationSharePreview(
          latitude: message.content.latitude!,
          longitude: message.content.longitude!,
          locationName: message.content.locationName,
        );
    }
  }

  Widget _buildInputArea() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Options mode éphémère
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showEphemeralOptions ? 60 : 0,
              child: _showEphemeralOptions 
                  ? _buildEphemeralOptions() 
                  : const SizedBox.shrink(),
            ),
            
            // Barre de saisie principale
            Row(
              children: [
                // Pièces jointes
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _showAttachmentMenu(),
                ),
                
                // Champ texte
                Expanded(
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (text) {
                      if (text.isNotEmpty && !_isTyping) {
                        setState(() => _isTyping = true);
                        _notifyTyping();
                      } else if (text.isEmpty && _isTyping) {
                        setState(() => _isTyping = false);
                      }
                    },
                  ),
                ),
                
                // Micro / Envoi
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _textController.text.isEmpty
                      ? GestureDetector(
                          onLongPressStart: (_) => _startRecording(),
                          onLongPressEnd: (_) => _stopRecording(),
                          child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade700,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.mic,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade700,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          onPressed: () => _sendMessage(),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEphemeralOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.timer, color: Colors.orange.shade700, size: 20),
          const SizedBox(width: 12),
          Text(
            'Mode éphémère:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 12),
          ChoiceChip(
            label: const Text('Off'),
            selected: _ephemeralDuration == null,
            onSelected: (_) => setState(() => _ephemeralDuration = null),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('24h'),
            selected: _ephemeralDuration == 24,
            onSelected: (_) => setState(() => _ephemeralDuration = 24),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('7j'),
            selected: _ephemeralDuration == 168,
            onSelected: (_) => setState(() => _ephemeralDuration = 168),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final message = Message(
      senderId: currentUserId,
      type: MessageType.text,
      content: MessageContent(text: text),
      timestamp: DateTime.now(),
      ephemeral: _ephemeralDuration != null 
          ? EphemeralSettings(
              enabled: true,
              durationHours: _ephemeralDuration!,
            )
          : null,
    );

    context.read<ConversationBloc>().add(MessageSent(message));
    _textController.clear();
    _scrollToBottom();
  }

  // Méthodes additionnelles...
  void _startRecording() {/* TODO: Implement audio recording */}
  void _stopRecording() {/* TODO: Implement audio recording stop */}
  void _showAttachmentMenu() {/* TODO: Implement attachment menu */}
  void _showMessageOptions(Message msg) {/* TODO: Implement message options */}
  void _notifyTyping() {/* TODO: Implement typing notification */}
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  
  void _showBookingOptions() {/* TODO: Implement booking options */}
  
  String _formatTime(DateTime timestamp) {
    return DateFormat('HH:mm').format(timestamp);
  }
  
  String _formatLastSeen(DateTime? lastSeen) {
    if (lastSeen == null) return 'Jamais';
    
    final now = DateTime.now();
    final difference = now.difference(lastSeen);
    
    if (difference.inMinutes < 1) return 'À l\'instant';
    if (difference.inMinutes < 60) return 'Il y a ${difference.inMinutes} min';
    if (difference.inHours < 24) return 'Il y a ${difference.inHours} h';
    if (difference.inDays < 7) return 'Il y a ${difference.inDays} j';
    
    return DateFormat('dd MMM').format(lastSeen);
  }
  
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
  
  Widget _buildDateSeparator(DateTime timestamp) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          DateFormat('dd MMMM yyyy').format(timestamp),
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
  
  EdgeInsets _getPaddingForType(MessageType type) {
    switch (type) {
      case MessageType.text:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      case MessageType.image:
        return EdgeInsets.zero;
      case MessageType.audio:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case MessageType.postShare:
      case MessageType.location:
        return const EdgeInsets.all(12);
    }
  }
}
