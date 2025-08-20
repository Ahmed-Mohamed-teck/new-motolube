import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/auth_providers.dart';
import '../view_model/auth_state.dart';
import '../widget/otp_input.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);
    final vm = ref.read(authViewModelProvider.notifier);

    ref.listen<AuthState>(authViewModelProvider, (prev, next) {
      if (next is ErrorState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.message)));
      }
      if (prev is VerifyingState && next is IdleState) {
        Navigator.pushReplacementNamed(context, 'baseHomeScreen');
      }
    });

    final showName = state is RegistrationState;
    final showOtp = state is AwaitingOtpState || state is VerifyingState;

    String buttonText = 'Login';
    VoidCallback? buttonAction;
    final isLoading = state is CheckingState || state is VerifyingState;

    if (showOtp) {
      buttonText = 'Verify';
      buttonAction = isLoading ? null : vm.onVerifyPressed;
    } else if (showName) {
      buttonText = 'Register';
      buttonAction = isLoading
          ? null
          : () => vm.onRegisterPressed(
                name: _nameController.text,
                phone: _phoneController.text,
              );
    } else {
      buttonText = 'Login';
      buttonAction = isLoading
          ? null
          : () => vm.onLoginPressed(_phoneController.text);
    }

    String phone = '';
    int secondsRemaining = 0;
    String? otpError;
    if (state is AwaitingOtpState) {
      phone = state.phone;
      secondsRemaining = state.remainingSeconds;
      otpError = state.errorMessage;
    } else if (state is VerifyingState) {
      phone = state.phone;
      secondsRemaining = state.remainingSeconds;
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
              decoration: const InputDecoration(
                labelText: 'Phone',
                hintText: '+9665XXXXXXXX',
              ),
            ),
            if (showName) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
            ],
            if (showOtp) ...[
              const SizedBox(height: 12),
              Text('Enter the OTP sent to $phone'),
              if (otpError != null) ...[
                const SizedBox(height: 8),
                Text(otpError, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 12),
              OtpInput(
                length: 6,
                onChanged: vm.onOtpChanged,
              ),
              const SizedBox(height: 8),
              Text('Expires in ${secondsRemaining}s'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't receive the OTP?"),
                  TextButton(
                    onPressed:
                        secondsRemaining > 0 ? null : () => vm.onResendOtp(),
                    child: const Text('Resend OTP'),
                  ),
                ],
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
