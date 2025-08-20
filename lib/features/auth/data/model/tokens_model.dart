class TokensModel {
  final String firebaseToken;
  final String jwtToken;
  final String tokenType;
  final int expiresIn;

  TokensModel({
    required this.firebaseToken,
    required this.jwtToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory TokensModel.fromJson(Map<String, dynamic> json) => TokensModel(
        firebaseToken: json['firebaseToken'] as String,
        jwtToken: json['jwtToken'] as String,
        tokenType: json['tokenType'] as String,
        expiresIn: json['expiresIn'] as int,
      );
}
