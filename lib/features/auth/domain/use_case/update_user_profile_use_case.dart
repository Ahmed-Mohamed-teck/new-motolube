import '../repository/i_auth_repository.dart';

class UpdateUserProfileUseCase {
  final IAuthRepository _repository;

  UpdateUserProfileUseCase(this._repository);

  Future<void> call({
    required String oracleId,
    required String fireBaseId,
    required String photoBase64,
    required String? email,
    required int userType,
  }) {
    return _repository.updateUserProfile(
      oracleId: oracleId,
      fireBaseId: fireBaseId,
      photoBase64: photoBase64,
      email: email,
      userType: userType,
    );
  }
}
