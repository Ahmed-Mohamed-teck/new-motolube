import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/enum.dart';
import '../../provider/auth_provider.dart';
import '../state/auth_flow_state.dart';

class AuthFlowController extends StateNotifier<AuthFlowState> {
  final Ref ref;
  AuthFlowController(this.ref) : super(const AuthFlowState());

  static const _saudi = '+966';

  String _composeFullPhone(String local) {
    final t = local.trim();
    final normalized = t.startsWith('0') ? t.substring(1) : t;
    return '$_saudi$normalized';
  }

  Future<void> continueFromPhone() async {
    final phoneVM = ref.read(loginPhoneProvider.notifier);
    final phone = ref.read(loginPhoneProvider).phoneLocal;
    final err = phoneVM.validatePhone(phone);
    if (err != null) { phoneVM.setError(err); return; }

    final full = _composeFullPhone(phone);
    state = state.copyWith(loading: true, fullPhone: full);

    final authVm = ref.read(authViewModelProvider.notifier);
    final registered = await authVm.isRegisteredUser(full).catchError((_) => false);

    if (registered) {
      await ref.read(otpProvider.notifier).sendOtp(full);
      state = state.copyWith(step: AuthFlowStep.otp, loading: false);
    } else {
      state = state.copyWith(step: AuthFlowStep.needRegistration, loading: false);
    }
  }

  Future<void> registerThenOtp() async {
    // final phoneVM = ref.read(loginPhoneProvider.notifier);
    // final regVM   = ref.read(registerProvider.notifier);
    // final phone = ref.read(loginPhoneProvider).phoneLocal;
    // final name  = ref.read(registerProvider).username;
    //
    // final phoneErr = phoneVM.validatePhone(phone);
    // final nameErr  = regVM.validateName(name);
    // if (phoneErr != null) phoneVM.setError(phoneErr);
    // if (nameErr  != null) regVM.setError(nameErr);
    // if (phoneErr != null || nameErr != null) return;
    //
    // final full = _composeFullPhone(phone);
    // state = state.copyWith(loading: true, fullPhone: full);
    //
    // // TODO: inject/register use-case; this is a placeholder
    // await ref.read(authRepositoryProvider).registerUser(phone: full, name: name);
    //
    // await ref.read(otpProvider.notifier).sendOtp(full);
    // state = state.copyWith(step: AuthFlowStep.otp, loading: false);
  }

  Future<void> verifyOtpThenAuthorize() async {
    final otpVM = ref.read(otpProvider.notifier);
    final code  = ref.read(otpProvider).code;
    final err   = otpVM.validateOtp(code);
    if (err != null) { otpVM.setError(err); return; }

    state = state.copyWith(loading: true);
    final phone = state.fullPhone!;
    await otpVM.verifyOtp(phone, code);

    // If verify succeeds → mark authorized (your existing AuthViewModel)
    ref.read(authViewModelProvider.notifier).toAuthorized(); // or set Authorized in your AuthViewModel
    state = state.copyWith(step: AuthFlowStep.done, loading: false);
  }
}