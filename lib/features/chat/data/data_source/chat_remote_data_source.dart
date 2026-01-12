import 'package:cloud_firestore/cloud_firestore.dart';

import 'i_chat_remote_data_source.dart';
import '../model/chat_message_model.dart';

class ChatRemoteDataSource implements IChatRemoteDataSource {
  ChatRemoteDataSource(this.firestore);

  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> _messagesCollection(String bookingId) {
    return firestore
        .collection('bookings')
        .doc(bookingId)
        .collection('messages');
  }

  @override
  Stream<List<ChatMessageModel>> observeMessages(String bookingId) {
    final collection = _messagesCollection(bookingId);
    return collection
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(ChatMessageModel.fromDocument)
              .toList(growable: false),
        );
  }

  @override
  Future<void> sendMessage({
    required String bookingId,
    required String text,
    required String senderId,
    required int senderTypeValue,
    required String senderName,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final collection = _messagesCollection(bookingId);
    final doc = collection.doc();

    await doc.set({
      'id': doc.id,
      'bookingId': bookingId,
      'senderId': senderId,
      'senderType': senderTypeValue,
      'senderName': senderName,
      'text': trimmed,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
