import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/otp_auth_provider.dart';
import '../state/otp_login_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(otpLoginNotifierProvider);
    final notifier = ref.read(otpLoginNotifierProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.errorMessage != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      }
      if (state.isAuthenticated) {
        Navigator.pushReplacementNamed(context, 'baseHomeScreen');
      }
    });

    final showName = state.status == OtpLoginStatus.registration ||
        state.status == OtpLoginStatus.registering;
    final showOtp = state.status == OtpLoginStatus.awaitingOtp ||
        state.status == OtpLoginStatus.verifyingOtp;

    String buttonText = 'Login';
    VoidCallback? buttonAction;
    final loadingStates = {
      OtpLoginStatus.checkingOrSendingOtp,
      OtpLoginStatus.registering,
      OtpLoginStatus.verifyingOtp,
    };
    final isLoading = loadingStates.contains(state.status);

    if (showOtp) {
      buttonText = 'Verify';
      buttonAction = isLoading ? null : notifier.verifyOtp;
    } else if (showName) {
      buttonText = 'Register';
      buttonAction = isLoading ? null : notifier.register;
    } else {
      buttonText = 'Login';
      buttonAction = isLoading ? null : notifier.sendOtp;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration:
                  const InputDecoration(labelText: 'Phone', hintText: '+9665XXXXXXXX'),
              onChanged: notifier.updatePhone,
            ),
            if (showName) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: notifier.updateName,
              ),
            ],
            if (showOtp) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'OTP'),
                onChanged: notifier.updateOtp,
              ),
              const SizedBox(height: 8),
              Text('Expires in ${state.secondsRemaining}s'),
              TextButton(
                onPressed: state.secondsRemaining > 0
                    ? null
                    : () => notifier.resendOtp(),
                child: const Text('Resend OTP'),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: buttonAction,
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
