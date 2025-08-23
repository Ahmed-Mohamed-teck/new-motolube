class OtpInfo {
  final String mobileNumber;
  final int expiresIn;
  final String message;
  const OtpInfo({
    required this.mobileNumber,
    required this.expiresIn,
    required this.message,
  });
}