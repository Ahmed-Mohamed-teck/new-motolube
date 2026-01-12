import '../../../auth/domain/entity/user_type.dart';

class ChatMessage {
  final String id;
  final String bookingId;
  final String senderId;
  final UserType senderType;
  final String senderName;
  final String text;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.bookingId,
    required this.senderId,
    required this.senderType,
    required this.senderName,
    required this.text,
    required this.createdAt,
  });

  bool get isFromCustomer => senderType == UserType.customer;
}
