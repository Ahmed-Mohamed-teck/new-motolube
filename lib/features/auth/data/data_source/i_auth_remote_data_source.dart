import 'package:newmotorlube/features/auth/data/model/user_model.dart';

abstract class IAuthRemoteDataSource{
  Future<bool> isRegisteredUser({required String phoneNumber});
  Future<bool> sendOtp({required String phoneNumber});
  Future<UserModel> verifyOtp({
    required String phoneNumber,
    required String otp,
  });

}