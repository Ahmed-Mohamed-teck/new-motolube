class User {
  final String id;
  final String? name;
  final String mobileNumber;
  final String? email;
  final bool isVerified;
  const User({
    required this.id,
    this.name,
    required this.mobileNumber,
    this.email,
    required this.isVerified,
  });
}
