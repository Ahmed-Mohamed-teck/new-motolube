class SendOtpRequest {
  final String mobileNumber;
  SendOtpRequest(this.mobileNumber);

  Map<String, dynamic> toJson() => {
        'mobileNumber': mobileNumber,
      };
}
