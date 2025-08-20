class VerifyOtpRequest {
  final String mobileNumber;
  final String otp;
  VerifyOtpRequest({required this.mobileNumber, required this.otp});

  Map<String, dynamic> toJson() => {
        'mobileNumber': mobileNumber,
        'otp': otp,
      };
}
