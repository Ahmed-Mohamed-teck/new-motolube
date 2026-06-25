import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/providers/global_lang_provider.dart';
import '../../../../core/utils/ui_components/shared_ui.dart';
import '../../provider/auth_provider.dart';
import '../view_model/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  final _otpController = TextEditingController();
  final _otpFocusNode = FocusNode();

  // UI helpers
  bool _wasOnOtpBefore = false; // remember if we entered OTP flow
  bool _stayOnOtp = false; // keep showing OTP during transient states
  bool _pendingClearOtp =
      false; // clear boxes *only* after a resend (fresh OTP)

  @override
  void dispose() {
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  void _clearOtpFields() {
    _otpController.clear();
    ref.read(authViewModelProvider.notifier).onOtpChanged('');
  }

  void _focusFirstOtp() {
    Future.microtask(() {
      if (mounted) _otpFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);
    final vm = ref.read(authViewModelProvider.notifier);

    ref.listen<AuthState>(authViewModelProvider, (prev, next) {
      if (next is ErrorState) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("something went wrong"),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 10, left: 16, right: 16),
            duration: Duration(seconds: 3),
          ),
        );
      }

      // Handle OTP-related states
      if (next is AwaitingOtpState) {
        _wasOnOtpBefore = true;
        _stayOnOtp = true;

        // Clear only if we explicitly requested a resend/new OTP
        if (_pendingClearOtp) {
          _clearOtpFields();
          _focusFirstOtp();
          _pendingClearOtp = false;
        }
      } else if (next is VerifyingState) {
        _wasOnOtpBefore = true;
        _stayOnOtp = true;
      }
      // During transient "Checking", keep OTP visible if we were on it
      else if (next is CheckingState && _wasOnOtpBefore) {
        _stayOnOtp = true;
      }
      // Leaving OTP flow entirely
      else {
        _wasOnOtpBefore = false;
        _stayOnOtp = false;
      }

      if (prev is VerifyingState && next is AuthenticatedState) {
        Navigator.pushReplacementNamed(context, 'baseHomeScreen');
      }
      setState(() {}); // reflect UI flags
    });

    final showName = state is RegistrationState;
    final showOtp = state is AwaitingOtpState || state is VerifyingState;

    // Keep OTP UI visible while we're in Checking and already on OTP
    final showOtpUI =
        showOtp || _stayOnOtp || (state is CheckingState && _wasOnOtpBefore);

    String buttonText = appLang.login;
    VoidCallback? buttonAction;
    final isLoading = state is CheckingState || state is VerifyingState;

    if (showOtpUI) {
      buttonText = appLang.verify;
      buttonAction = isLoading ? null : vm.onVerifyPressed;
    } else if (showName) {
      buttonText = appLang.register;
      buttonAction =
          isLoading
              ? null
              : () => vm.onRegisterPressed(
                firstName: _firstNameController.text,
                lastName: _lastNameController.text,
                phone: _phoneController.text,
                email: _emailController.text,
              );
    } else {
      buttonText = appLang.login;
      buttonAction =
          isLoading ? null : () => vm.onLoginPressed(_phoneController.text);
    }

    String phone = '';
    int secondsRemaining = 0;
    if (state is AwaitingOtpState) {
      phone = state.phone;
      secondsRemaining = state.remainingSeconds;
    } else if (state is VerifyingState) {
      phone = state.phone;
      secondsRemaining = state.remainingSeconds;
    }

    final otpErrorMessage =
        state is AwaitingOtpState ? state.errorMessage : null;
    final hasOtpError = otpErrorMessage != null && otpErrorMessage.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffDEBB33),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () async {
              await vm.skipAuthentication();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, 'baseHomeScreen');
            },
            child: Text(
              appLang.skip,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.public, color: Colors.black),
          onPressed: () => buildShowLangBottomSheet(context, ref),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Yellow background layer
            Container(color: const Color(0xffDEBB33)),

            // Centered decorative image
            Center(
              child: Image.asset(
                'assets/images/login-bg.png',
                fit: BoxFit.contain,
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.ease,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),

                    // Hide welcome/login copy when OTP UI is showing
                    if (!showOtpUI) ...[
                      Text(
                        appLang.loginWelcomeMessage,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                    ],

                    // ================== Phone/Register View ==================
                    if (!showOtpUI) ...[
                      Text(appLang.phoneNumber),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          // Country code

                          // Phone input
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: '5XXXXXXXX',
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (showName) ...[
                        const SizedBox(height: 16),
                        Text(appLang.firstName),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            hintText: appLang.firstNameHint,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(appLang.lastName),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            hintText: appLang.lastNameHint,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(appLang.userEmail),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          validator: (state) {
                            if (state == null || state.isEmpty) {
                              return appLang.userEmailHint;
                            }
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                            if (!emailRegex.hasMatch(state)) {
                              return appLang.notValidUserEmail;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: appLang.userEmail,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ],

                    // ================== OTP View (6 digits) ==================
                    if (showOtpUI) ...[
                      Text(
                        '${appLang.enterOtpSentTo} $phone',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          const otpLength = 6;
                          const separatorWidth = 8.0;
                          final pinWidth =
                              ((constraints.maxWidth -
                                          (separatorWidth * (otpLength - 1))) /
                                      otpLength)
                                  .clamp(42.0, 48.0)
                                  .toDouble();
                          final borderRadius = BorderRadius.circular(12);
                          final defaultPinTheme = PinTheme(
                            width: pinWidth,
                            height: 64,
                            textStyle: const TextStyle(
                              fontSize: 24,
                              letterSpacing: 2,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade500),
                              borderRadius: borderRadius,
                            ),
                          );

                          return Directionality(
                            textDirection: TextDirection.ltr,
                            child: Pinput(
                              length: otpLength,
                              controller: _otpController,
                              focusNode: _otpFocusNode,
                              enabled: state is! VerifyingState,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              defaultPinTheme: defaultPinTheme,
                              focusedPinTheme: defaultPinTheme
                                  .copyDecorationWith(
                                    border: Border.all(
                                      color: Colors.amber.shade700,
                                      width: 2,
                                    ),
                                    borderRadius: borderRadius,
                                  ),
                              submittedPinTheme: defaultPinTheme
                                  .copyDecorationWith(
                                    border: Border.all(
                                      color: Colors.amber.shade600,
                                    ),
                                    borderRadius: borderRadius,
                                  ),
                              errorPinTheme: defaultPinTheme.copyDecorationWith(
                                border: Border.all(
                                  color: Colors.red,
                                  width: 1.5,
                                ),
                                borderRadius: borderRadius,
                              ),
                              forceErrorState: hasOtpError,
                              separatorBuilder:
                                  (_) => const SizedBox(width: separatorWidth),
                              mainAxisAlignment: MainAxisAlignment.center,
                              onChanged: vm.onOtpChanged,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      // error text (if any)
                      if (hasOtpError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            otpErrorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      Text(
                        '${appLang.expiresIn} ${secondsRemaining}s',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(appLang.didntReceiveOtp),
                          TextButton(
                            onPressed:
                                (state is VerifyingState) ||
                                        secondsRemaining > 0
                                    ? null
                                    : () {
                                      // Mark that the next AwaitingOtpState is a *fresh* OTP
                                      _pendingClearOtp = true;
                                      _stayOnOtp = true;
                                      _wasOnOtpBefore = true;
                                      setState(() {});
                                      vm.onResendOtp();
                                    },
                            child: Text(appLang.resendOTP),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 24),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : buttonAction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            isLoading
                                ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  buttonText,
                                  style: const TextStyle(fontSize: 16),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
