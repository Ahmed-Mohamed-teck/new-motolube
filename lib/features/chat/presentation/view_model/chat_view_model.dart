import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/chat_user.dart';
import '../../domain/use_case/observe_chat_messages_use_case.dart';
import '../../domain/use_case/send_chat_message_use_case.dart';
import '../../domain/entity/chat_message.dart';
import '../../provider/chat_provider.dart';
import 'chat_state.dart';

class ChatSession {
  final String bookingId;
  final ChatUser user;

  const ChatSession({
    required this.bookingId,
    required this.user,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatSession &&
        other.bookingId == bookingId &&
        other.user == user;
  }

  @override
  int get hashCode => Object.hash(bookingId, user);
}

class ChatViewModel extends StateNotifier<ChatState> {
  ChatViewModel({
    required this.ref,
    required this.session,
    required this.observeChatMessagesUseCase,
    required this.sendChatMessageUseCase,
  }) : super(ChatState.initial()) {
    _listenToMessages();
  }

  final Ref ref;
  final ChatSession session;
  final ObserveChatMessagesUseCase observeChatMessagesUseCase;
  final SendChatMessageUseCase sendChatMessageUseCase;

  StreamSubscription<List<ChatMessage>>? _subscription;

  void _listenToMessages() {
    _subscription = observeChatMessagesUseCase(session.bookingId).listen(
      (messages) {
        state = state.copyWith(messages: AsyncValue.data(messages));
      },
      onError: (error, stackTrace) {
        state = state.copyWith(messages: AsyncValue.error(error, stackTrace));
      },
    );

    ref.onDispose(() {
      _subscription?.cancel();
    });
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || !session.user.isValid) return;

    state = state.copyWith(isSending: true, clearError: true);
    try {
      await sendChatMessageUseCase(
        bookingId: session.bookingId,
        text: trimmed,
        sender: session.user,
      );
    } catch (error) {
      state = state.copyWith(errorMessage: error.toString());
    } finally {
      state = state.copyWith(isSending: false);
    }
  }
}

final chatControllerProvider =
    StateNotifierProvider.autoDispose.family<ChatViewModel, ChatState, ChatSession>(
  (ref, session) {
    return ChatViewModel(
      ref: ref,
      session: session,
      observeChatMessagesUseCase: ref.read(observeChatMessagesUseCaseProvider),
      sendChatMessageUseCase: ref.read(sendChatMessageUseCaseProvider),
    );
  },
);
