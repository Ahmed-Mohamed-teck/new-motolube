import '../entity/chat_message.dart';
import '../repository/i_chat_repository.dart';

class ObserveChatMessagesUseCase {
  final IChatRepository repository;

  const ObserveChatMessagesUseCase(this.repository);

  Stream<List<ChatMessage>> call(String bookingId) {
    return repository.observeMessages(bookingId);
  }
}
