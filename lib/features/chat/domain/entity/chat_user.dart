import '../../../auth/domain/entity/user_type.dart';

class ChatUser {
  final String id;
  final UserType userType;
  final String displayName;

  const ChatUser({
    required this.id,
    required this.userType,
    required this.displayName,
  });

  bool get isValid => id.trim().isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatUser &&
        other.id == id &&
        other.userType == userType &&
        other.displayName == displayName;
  }

  @override
  int get hashCode => Object.hash(id, userType, displayName);
}
