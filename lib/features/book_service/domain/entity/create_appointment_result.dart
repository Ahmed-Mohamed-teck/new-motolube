class CreateAppointmentResult {
  final String infoCode;
  final String infoType;
  final String infoDescriptionAr;
  final String infoDescriptionEn;
  final String infoDescription;

  const CreateAppointmentResult({
    required this.infoCode,
    required this.infoType,
    required this.infoDescriptionAr,
    required this.infoDescriptionEn,
    required this.infoDescription,
  });

  bool get isSuccessful => infoCode.trim() == '0001';

  String get displayMessage {
    final message = infoDescriptionEn.trim();
    if (message.isNotEmpty) {
      return message;
    }
    final fallback = infoDescription.trim();
    if (fallback.isNotEmpty) {
      return fallback;
    }
    return infoType.trim().isNotEmpty ? infoType : 'Appointment created';
  }
}
