import 'package:newmotorlube/features/auth/domain/entity/user_entity.dart';

abstract class IAuthRepository {
  Future<bool> isRegisteredUser({required String phoneNumber});
  Future<bool> sendOtp({required String phoneNumber});
  Future<UserEntity> verifyOtp({
    required String phoneNumber,
    required String otp,
  });
}