import '../../domain/entity/chat_message.dart';
import '../../domain/entity/chat_user.dart';
import '../../domain/repository/i_chat_repository.dart';
import '../data_source/i_chat_remote_data_source.dart';
import '../model/chat_message_model.dart';

class ChatRepositoryImpl implements IChatRepository {
  ChatRepositoryImpl(this.remoteDataSource);

  final IChatRemoteDataSource remoteDataSource;

  @override
  Stream<List<ChatMessage>> observeMessages(String bookingId) {
    return remoteDataSource.observeMessages(bookingId);
  }

  @override
  Future<void> sendMessage({
    required String bookingId,
    required String text,
    required ChatUser sender,
  }) {
    return remoteDataSource.sendMessage(
      bookingId: bookingId,
      text: text,
      senderId: sender.id,
      senderTypeValue: sender.userType.value,
      senderName: sender.displayName,
    );
  }
}
