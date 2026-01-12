import '../model/chat_message_model.dart';

abstract class IChatRemoteDataSource {
  Stream<List<ChatMessageModel>> observeMessages(String bookingId);

  Future<void> sendMessage({
    required String bookingId,
    required String text,
    required String senderId,
    required int senderTypeValue,
    required String senderName,
  });
}
