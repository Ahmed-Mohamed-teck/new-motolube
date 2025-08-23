import '../../domain/entity/otp_info.dart';

class SendOtpResponse {
  final String message;
  final String mobileNumber;
  final int expiresIn;
  SendOtpResponse({required this.message, required this.mobileNumber, required this.expiresIn});

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) => SendOtpResponse(
    message: json['message'] as String,
    mobileNumber: json['mobileNumber'] as String,
    expiresIn: json['expiresIn'] as int,
  );

  OtpInfo toEntity() => OtpInfo(
    mobileNumber: mobileNumber,
    expiresIn: expiresIn,
    message: message,
  );
}