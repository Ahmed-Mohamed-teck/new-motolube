import 'package:newmotorlube/features/auth/domain/repository/i_auth_repository.dart';
import '../../domain/entity/user_entity.dart';
import '../data_source/i_auth_remote_data_source.dart';

class AuthRepositoryImpl extends IAuthRepository {
  final IAuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<bool> isRegisteredUser({required String phoneNumber}) {
    return remoteDataSource.isRegisteredUser(phoneNumber: phoneNumber);
  }

  @override
  Future<bool> sendOtp({required String phoneNumber}) {
    return remoteDataSource.sendOtp(phoneNumber: phoneNumber);
  }

  @override
  Future<UserEntity> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) {
    return remoteDataSource.verifyOtp(phoneNumber: phoneNumber, otp: otp);
  }
}