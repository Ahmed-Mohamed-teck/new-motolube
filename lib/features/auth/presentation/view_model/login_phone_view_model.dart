import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/login_phone_state.dart';

class LoginPhoneVM extends StateNotifier<LoginPhoneState> {
  LoginPhoneVM() : super(const LoginPhoneState());

  void onChanged(String v) => state = LoginPhoneState(phoneLocal: v, errorKey: null);
  String? validatePhone(String? raw) {
    final v = (raw ?? '').trim();
    if (v.isEmpty) return "appLang.requiredField";
    if (!RegExp(r'^(?:05|5)\d{8}$').hasMatch(v)) return "appLang.invalidPhone";
    return null;
  }
  void setError(String k) => state = LoginPhoneState(phoneLocal: state.phoneLocal, errorKey: k);
}