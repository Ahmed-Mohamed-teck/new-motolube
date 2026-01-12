import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/chat_message.dart';
import '../../../auth/domain/entity/user_type.dart';

class ChatMessageModel extends ChatMessage {
  ChatMessageModel({
    required super.id,
    required super.bookingId,
    required super.senderId,
    required super.senderType,
    required super.senderName,
    required super.text,
    required super.createdAt,
  });

  factory ChatMessageModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? const <String, dynamic>{};
    final createdAtRaw = data['createdAt'];
    DateTime createdAt;
    if (createdAtRaw is Timestamp) {
      createdAt = createdAtRaw.toDate();
    } else if (createdAtRaw is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtRaw);
    } else {
      createdAt = DateTime.now();
    }

    return ChatMessageModel(
      id: (data['id'] ?? doc.id).toString(),
      bookingId: (data['bookingId'] ?? '').toString(),
      senderId: (data['senderId'] ?? '').toString(),
      senderType: UserType.fromValue(
        int.tryParse((data['senderType'] ?? '').toString()) ??
            UserType.customer.value,
      ),
      senderName: (data['senderName'] ?? '').toString(),
      text: (data['text'] ?? '').toString(),
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'senderId': senderId,
      'senderType': senderType.value,
      'senderName': senderName,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
