import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/core/providers/dio_provider.dart';
import 'package:newmotorlube/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:newmotorlube/features/auth/domain/use_case/is_registered_user_use_case.dart';
import '../../data/repository/auth_repository.dart';
import '../../domain/repository/i_auth_repository.dart';
import '../state/auth_state.dart';




class AuthViewModel extends StateNotifier<AuthState> {
  final IsRegisteredUserUseCase isRegisteredUserUseCase;
  AuthViewModel({required this.isRegisteredUserUseCase}) : super(NotAuthorized());

  /// Method to check if the user is registered.
  Future<bool> isRegisteredUser(String phoneNumber) async {
    try {
      final isRegistered = await isRegisteredUserUseCase(phoneNumber: phoneNumber);
      debugPrint('isRegisteredUser: $isRegistered');
      return isRegistered;
    } catch (e) {
      return false;
    }
  }

  void toAuthorized() {
    state = Authorized();
  }

}