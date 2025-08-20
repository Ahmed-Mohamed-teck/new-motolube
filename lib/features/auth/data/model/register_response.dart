class RegisterResponse {
  final String message;
  final String userId;
  final String mobileNumber;
  RegisterResponse({required this.message, required this.userId, required this.mobileNumber});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
        message: json['message'] as String,
        userId: json['userId'] as String,
        mobileNumber: json['mobileNumber'] as String,
      );
}
