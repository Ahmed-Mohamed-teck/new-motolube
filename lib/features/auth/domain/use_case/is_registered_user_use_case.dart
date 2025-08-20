import 'package:newmotorlube/features/auth/domain/repository/i_auth_repository.dart';

class IsRegisteredUserUseCase{
  final IAuthRepository repository;
  IsRegisteredUserUseCase(this.repository);
  Future<bool> call({required String phoneNumber}) {
    return repository.isRegisteredUser(phoneNumber: phoneNumber);
  }
}