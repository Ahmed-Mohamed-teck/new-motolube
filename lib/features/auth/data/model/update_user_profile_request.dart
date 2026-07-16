class UpdateUserProfileRequest {
  final String oracleId;
  final String fireBaseId;
  final String photoBase64;
  final String? email;
  final int userType;

  const UpdateUserProfileRequest({
    required this.oracleId,
    required this.fireBaseId,
    required this.photoBase64,
    required this.email,
    required this.userType,
  });

  Map<String, dynamic> toJson() => {
    'oracleId': oracleId,
    'fireBaseId': fireBaseId,
    'photoBase64': photoBase64,
    'email': email,
    'userType': userType,
  };
}
