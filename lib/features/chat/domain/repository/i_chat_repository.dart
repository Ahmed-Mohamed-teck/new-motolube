import '../entity/chat_message.dart';
import '../entity/chat_user.dart';

abstract class IChatRepository {
  Stream<List<ChatMessage>> observeMessages(String bookingId);

  Future<void> sendMessage({
    required String bookingId,
    required String text,
    required ChatUser sender,
  });
}
