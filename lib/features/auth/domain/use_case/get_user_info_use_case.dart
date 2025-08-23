import '../entity/user_entity.dart';
import '../repository/i_auth_repository.dart';

class GetUserInfoUseCase {
  final IAuthRepository _repository;

  GetUserInfoUseCase(this._repository);

  Future<User> call(String phone) async {
    return await _repository.getUserInfo(phoneNumber: phone);
  }
}