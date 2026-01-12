import '../entity/chat_user.dart';
import '../repository/i_chat_repository.dart';

class SendChatMessageUseCase {
  final IChatRepository repository;

  const SendChatMessageUseCase(this.repository);

  Future<void> call({
    required String bookingId,
    required String text,
    required ChatUser sender,
  }) {
    return repository.sendMessage(
      bookingId: bookingId,
      text: text,
      sender: sender,
    );
  }
}
