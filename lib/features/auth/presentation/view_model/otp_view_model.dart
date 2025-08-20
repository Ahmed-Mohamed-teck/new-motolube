import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/auth_provider.dart';
import '../state/otp_state.dart';

class OtpVM extends StateNotifier<OtpState> {
  final Ref ref;
  OtpVM(this.ref) : super(const OtpState());

  void onChanged(String v) => state = OtpState(code: v.trim(), errorKey: null);
  String? validateOtp(String? raw) {
    final v = (raw ?? '').trim();
    if (v.isEmpty) return "appLang.requiredField";
    if (v.length < 4) return "appLang.invalidOtp"; // adjust length
    return null;
  }
  void setError(String k) => state = OtpState(code: state.code, errorKey: k);

  Future<void> sendOtp(String phone) async {
    await ref.read(authRepositoryProvider).sendOtp(phoneNumber: phone);
  }

  Future<void> verifyOtp(String phone, String code) async {
    await ref.read(authRepositoryProvider).verifyOtp(phoneNumber: phone, otp: code);
  }
}