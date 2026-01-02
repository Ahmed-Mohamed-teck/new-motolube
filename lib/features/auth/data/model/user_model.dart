import '../../domain/entity/user_entity.dart';
import '../../domain/entity/user_type.dart';

class UserModel {
  final String oracleId;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String mobileNo;
  final String? email;
  final bool isVerified;
  final UserType userType;
  final String fireBaseId;
  final String? customer_id;

  UserModel({
    required this.oracleId,
    this.firstName,
    this.lastName,
    this.name,
    required this.mobileNo,
    this.email,
    required this.isVerified,
    required this.userType,
    this.fireBaseId = '',
    this.customer_id = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    oracleId: json['oracleId'] as String,
    firstName: json['firstName'] as String?,
    lastName: json['lastName'] as String?,
    name: _resolveName(
      json['name'] as String?,
      json['firstName'] as String?,
      json['lastName'] as String?,
    ),
    mobileNo: json['mobileNo'] ?? json['mobileNumber'] as String,
    email: json['email'] as String?,
    isVerified: json['isVerified'] as bool? ?? false,
    userType: UserType.fromValue(json['userType'] as int? ?? 1),
    fireBaseId: (json['fireBaseId'] ?? json['firebaseId'] ?? '').toString(),
    customer_id:
        (json['customer_id'] ?? json['customerId'] ?? json['customerID'] ?? '')
            .toString(),
  );

  User toEntity() => User(
    oracleId: oracleId,
    firstName: firstName,
    lastName: lastName,
    name: name,
    mobileNo: mobileNo,
    email: email,
    isVerified: isVerified,
    userType: userType,
    fireBaseId: fireBaseId,
    customer_id: customer_id,
  );
}

String? _resolveName(String? name, String? firstName, String? lastName) {
  if (name != null && name.isNotEmpty) {
    return name;
  }

  final buffer = StringBuffer();
  if (firstName != null && firstName.isNotEmpty) {
    buffer.write(firstName);
  }
  if (lastName != null && lastName.isNotEmpty) {
    if (buffer.isNotEmpty) {
      buffer.write(' ');
    }
    buffer.write(lastName);
  }

  return buffer.isEmpty ? null : buffer.toString();
}
