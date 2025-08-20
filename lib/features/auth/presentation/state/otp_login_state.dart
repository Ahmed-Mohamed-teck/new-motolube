enum OtpLoginStatus {
  idle,
  checkingOrSendingOtp,
  registration,
  registering,
  awaitingOtp,
  verifyingOtp,
}

class OtpLoginState {
  final OtpLoginStatus status;
  final String phone;
  final String name;
  final String otp;
  final int secondsRemaining;
  final String? errorMessage;
  final bool isAuthenticated;

  const OtpLoginState({
    this.status = OtpLoginStatus.idle,
    this.phone = '',
    this.name = '',
    this.otp = '',
    this.secondsRemaining = 0,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  OtpLoginState copyWith({
    OtpLoginStatus? status,
    String? phone,
    String? name,
    String? otp,
    int? secondsRemaining,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return OtpLoginState(
      status: status ?? this.status,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      otp: otp ?? this.otp,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
