import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:newmotorlube/features/auth/data/data_source/i_auth_remote_data_source.dart';
import 'package:newmotorlube/features/auth/data/model/user_model.dart';

import '../../../../core/utils/end_point.dart';

class AuthRemoteDataSourceImpl extends IAuthRemoteDataSource{

  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<bool> isRegisteredUser({required String phoneNumber}) async{
    try{
      final res = await dio.post(isRegisteredUserEndPoint, data: {
        'mobileNumber': phoneNumber,
      });
      if(res.statusCode == 200){
        debugPrint('Response from isRegisteredUser: ${res.data}');
        return res.data['isRegistered'] as bool;
      }
      return false;
  }catch(e){
      debugPrint('Error in isRegisteredUser: $e');
      return false;
    }
    }

  @override
  Future<bool> sendOtp({required String phoneNumber}) async{
    try{
      final res = await dio.post(
        sendOtpEndPoint,
        data: {
          'mobileNumber': phoneNumber,
        },
      );
      debugPrint('Response from sendOtp: ${res.data}');
      return true;
    }catch(e){
      debugPrint('Error in sendOtp: $e');
      return false;
    }
  }

  @override
  Future<UserModel> verifyOtp({required String phoneNumber, required String otp}) {
    // TODO: implement verifyOtp
    throw UnimplementedError();
  }

}