import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/widget/internal_app_bar.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../../../auth/presentation/view_model/auth_state.dart';
import '../../../auth/provider/auth_provider.dart';
import '../../domain/entity/chat_message.dart';
import '../../domain/entity/chat_user.dart';
import '../view_model/chat_view_model.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, this.bookingId});

  final String? bookingId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _lastMessageCount = 0;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  ChatSession? _sessionFor(AuthState authState, String bookingId) {
    if (authState is! AuthenticatedState) return null;
    final user = authState.user;
    final chatUser = _userForChat(user);
    if (!chatUser.isValid) return null;
    return ChatSession(
      bookingId: bookingId,
      user: chatUser,
    );
  }

  ChatUser _userForChat(User user) {
    final idCandidate =
        user.fireBaseId.trim().isNotEmpty ? user.fireBaseId.trim() : user.oracleId;
    final buffer = StringBuffer();
    final first = user.firstName?.trim() ?? '';
    final last = user.lastName?.trim() ?? '';
    if (first.isNotEmpty) buffer.write(first);
    if (last.isNotEmpty) {
      if (buffer.isNotEmpty) buffer.write(' ');
      buffer.write(last);
    }
    final fallbackName = user.name?.trim() ?? '';
    final displayName =
        (buffer.isNotEmpty ? buffer.toString() : fallbackName).trim();
    return ChatUser(
      id: idCandidate,
      userType: user.userType,
      displayName: displayName.isNotEmpty ? displayName : user.mobileNo,
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _handleSend(ChatSession session) async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    await ref.read(chatControllerProvider(session).notifier).sendMessage(text);
    if (!mounted) return;
    _messageController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final bookingId = widget.bookingId?.trim() ?? '';
    final authState = ref.watch(authViewModelProvider);
    if (bookingId.isEmpty) {
      return Scaffold(
        appBar: InternalAppBar(title: s.chatTitle),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              s.chatUnavailable,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      );
    }

    final session = _sessionFor(authState, bookingId);
    if (session == null) {
      return Scaffold(
        appBar: InternalAppBar(title: s.chatTitle),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              s.chatLoginRequired,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      );
    }

    final chatState = ref.watch(chatControllerProvider(session));
    final messagesValue = chatState.messages;

    return Scaffold(
      appBar: InternalAppBar(title: s.chatTitle),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: _BookingPill(bookingId: bookingId),
            ),
            Expanded(
              child: messagesValue.when(
                data: (messages) {
                  if (_lastMessageCount != messages.length) {
                    _lastMessageCount = messages.length;
                    _scrollToBottom();
                  }
                  if (messages.isEmpty) {
                    return _EmptyChatPlaceholder(message: s.chatEmptyMessage);
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMine = message.senderId == session.user.id;
                      return _MessageBubble(
                        message: message,
                        isMine: isMine,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => _ChatError(
                  message: s.chatErrorLoading,
                  onRetry: () {
                    ref.refresh(chatControllerProvider(session));
                  },
                ),
              ),
            ),
            if (chatState.errorMessage?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, size: 16, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        chatState.errorMessage ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.red,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: _MessageInput(
                controller: _messageController,
                isSending: chatState.isSending,
                hintText: s.chatInputHint,
                sendLabel: s.chatSendLabel,
                onSend: () => _handleSend(session),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingPill extends StatelessWidget {
  const _BookingPill({required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            size: 18,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            bookingId,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatError extends StatelessWidget {
  const _ChatError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(s.commonRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyChatPlaceholder extends StatelessWidget {
  const _EmptyChatPlaceholder({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chat_bubble_outline, size: 42),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMine});

  final ChatMessage message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor =
        isMine ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant;
    final textColor =
        isMine ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;
    final time = DateFormat('hh:mm a').format(message.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment:
                    isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isMine && message.senderName.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        message.senderName,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: textColor.withOpacity(0.85),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  Text(
                    message.text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    time,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: textColor.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput({
    required this.controller,
    required this.isSending,
    required this.hintText,
    required this.sendLabel,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isSending;
  final String hintText;
  final String sendLabel;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => onSend(),
            minLines: 1,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: isSending ? null : onSend,
          icon: isSending
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.send_rounded),
          label: Text(sendLabel),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}
