import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/chat_message.dart';

class ChatState {
  final AsyncValue<List<ChatMessage>> messages;
  final bool isSending;
  final String? errorMessage;

  const ChatState({
    required this.messages,
    this.isSending = false,
    this.errorMessage,
  });

  factory ChatState.initial() =>
      const ChatState(messages: AsyncValue.loading(), isSending: false);

  ChatState copyWith({
    AsyncValue<List<ChatMessage>>? messages,
    bool? isSending,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
