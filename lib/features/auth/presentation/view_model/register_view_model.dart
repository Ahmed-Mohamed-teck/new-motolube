import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/register_state.dart';

class RegisterVM extends StateNotifier<RegisterState> {
  RegisterVM() : super(const RegisterState());
  void onChanged(String v) => state = RegisterState(username: v.trim(), errorKey: null);
  String? validateName(String? raw) => (raw ?? '').trim().isEmpty ? "appLang.requiredField" : null;
  void setError(String k) => state = RegisterState(username: state.username, errorKey: k);
}