// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../core/providers/global_lang_provider.dart';
// import '../../../../core/utils/ui_components/shared_ui.dart';
// import '../../provider/auth_provider.dart';
// import '../view_model/auth_state.dart';
//
// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   final _phoneController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//
//   // 6-digit OTP controllers/focus nodes
//   final List<TextEditingController> _otpCtrls =
//   List.generate(6, (_) => TextEditingController());
//   final List<FocusNode> _otpNodes = List.generate(6, (_) => FocusNode());
//
//   // UI helper to keep OTP visible while resending (avoid flicker)
//   bool _stayOnOtp = false;
//
//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _nameController.dispose();
//     _emailController.dispose();
//     for (final c in _otpCtrls) c.dispose();
//     for (final n in _otpNodes) n.dispose();
//     super.dispose();
//   }
//
//   void _clearOtpFields() {
//     for (final c in _otpCtrls) c.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(authViewModelProvider);
//     final vm = ref.read(authViewModelProvider.notifier);
//
//     ref.listen<AuthState>(authViewModelProvider, (prev, next) {
//       if (next is ErrorState) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("something went wrong"),
//             behavior: SnackBarBehavior.floating,
//             margin: EdgeInsets.only(top: 10, left: 16, right: 16),
//             duration: Duration(seconds: 3),
//           ),
//         );
//       }
//
//       // Keep OTP visible while moving through resend/verify states
//       if (next is AwaitingOtpState || next is VerifyingState) {
//         // Fresh AwaitingOtp after resend → clear boxes
//         if (next is AwaitingOtpState) {
//           _clearOtpFields();
//         }
//         _stayOnOtp = true;
//       } else {
//         // Leaving OTP flow entirely
//         _stayOnOtp = false;
//       }
//
//       if (prev is VerifyingState && next is AuthenticatedState) {
//         Navigator.pushReplacementNamed(context, 'baseHomeScreen');
//       }
//       setState(() {}); // reflect _stayOnOtp changes
//     });
//
//     final showName = state is RegistrationState;
//     final showOtp = state is AwaitingOtpState || state is VerifyingState;
//     final showOtpUI = showOtp || _stayOnOtp; // <- prevents flicker
//
//     String buttonText = 'Login';
//     VoidCallback? buttonAction;
//     final isLoading = state is CheckingState || state is VerifyingState;
//
//     if (showOtp) {
//       buttonText = 'Verify';
//       buttonAction = isLoading ? null : vm.onVerifyPressed;
//     } else if (showName) {
//       buttonText = 'Register';
//       buttonAction = isLoading
//           ? null
//           : () => vm.onRegisterPressed(
//         name: _nameController.text,
//         phone: _phoneController.text,
//         email: _emailController.text,
//       );
//     } else {
//       buttonText = 'Login';
//       buttonAction =
//       isLoading ? null : () => vm.onLoginPressed(_phoneController.text);
//     }
//
//     String phone = '';
//     int secondsRemaining = 0;
//     String? otpError;
//     if (state is AwaitingOtpState) {
//       phone = state.phone;
//       secondsRemaining = state.remainingSeconds;
//       otpError = state.errorMessage;
//     } else if (state is VerifyingState) {
//       phone = state.phone;
//       secondsRemaining = state.remainingSeconds;
//     }
//
//     void _notifyOtp() {
//       final code = _otpCtrls.map((c) => c.text).join();
//       vm.onOtpChanged(code);
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xffDEBB33),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.public, color: Colors.black),
//           onPressed: () => buildShowLangBottomSheet(context, ref),
//         ),
//       ),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // Yellow background layer
//             Container(color: const Color(0xffDEBB33)),
//
//             // Centered decorative image
//             Center(
//               child: Image.asset(
//                 'assets/images/login-bg.png',
//                 fit: BoxFit.contain,
//               ),
//             ),
//
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 250),
//                 curve: Curves.ease,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const SizedBox(height: 8),
//
//                     // Hide welcome/login copy when OTP UI is showing
//                     if (!showOtpUI) ...[
//                       Text(
//                         appLang.loginWelcomeMessage,
//                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 24),
//                     ],
//
//                     // ================== Phone/Register View ==================
//                     if (!showOtpUI) ...[
//                       Text(appLang.phoneNumber),
//                       const SizedBox(height: 8),
//
//                       Row(
//                         children: [
//                           // Country code
//                           Container(
//                             width: 84,
//                             padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey.shade400),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Text(
//                               '+966',
//                               style: TextStyle(fontSize: 16),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//
//                           // Phone input
//                           Expanded(
//                             child: TextFormField(
//                               controller: _phoneController,
//                               keyboardType: TextInputType.phone,
//                               decoration: InputDecoration(
//                                 hintText: '5XXXXXXXX',
//                                 contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 14, horizontal: 12,
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       if (showName) ...[
//                         const SizedBox(height: 16),
//                         const Text('اسم المستخدم'),
//                         const SizedBox(height: 8),
//                         TextFormField(
//                           decoration: InputDecoration(
//                             hintText: "أدخل اسم المستخدم",
//                             contentPadding: const EdgeInsets.symmetric(
//                                 vertical: 14, horizontal: 12),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           onChanged: (s) => _nameController.text = s,
//                         ),
//                         const SizedBox(height: 12),
//                         TextFormField(
//                           decoration: InputDecoration(
//                             hintText: "البريد الالكتروني",
//                             contentPadding: const EdgeInsets.symmetric(
//                                 vertical: 14, horizontal: 12),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           onChanged: (s) => _emailController.text = s,
//                         ),
//                       ],
//                     ],
//
//                     // ================== OTP View (6 digits) ==================
//                     if (showOtpUI) ...[
//                       Text(
//                         'Enter the OTP sent to $phone',
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                       ),
//                       const SizedBox(height: 16),
//
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: List.generate(6, (i) {
//                           return SizedBox(
//                             width: 48,
//                             height: 64,
//                             child: TextField(
//                               controller: _otpCtrls[i],
//                               focusNode: _otpNodes[i],
//                               textAlign: TextAlign.center,
//                               keyboardType: TextInputType.number,
//                               // inputFormatters: const [
//                               //   FilteringTextInputFormatter.digitsOnly,
//                               //   LengthLimitingTextInputFormatter(1),
//                               // ],
//                               onChanged: (v) {
//                                 if (v.isNotEmpty && i < 5) {
//                                   _otpNodes[i + 1].requestFocus();
//                                 } else if (v.isEmpty && i > 0) {
//                                   _otpNodes[i - 1].requestFocus();
//                                 }
//                                 _notifyOtp();
//                               },
//                               decoration: InputDecoration(
//                                 contentPadding: EdgeInsets.zero,
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               style: const TextStyle(fontSize: 24, letterSpacing: 2),
//                             ),
//                           );
//                         }),
//                       ),
//
//                       if (otpError != null && otpError!.isNotEmpty) ...[
//                         const SizedBox(height: 8),
//                         Text(
//                           otpError!,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                       ],
//
//                       const SizedBox(height: 12),
//                       Text(
//                         'Expires in ${secondsRemaining}s',
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text("Don’t receive the OTP?"),
//                           TextButton(
//                             onPressed: (state is VerifyingState) || secondsRemaining > 0
//                                 ? null
//                                 : () {
//                               // UI cleanup before calling VM (logic unchanged)
//                               _clearOtpFields();
//                               _notifyOtp(); // send empty code to VM
//                               setState(() => _stayOnOtp = true);
//                               vm.onResendOtp();
//                             },
//                             child: const Text('Resend OTP'),
//                           ),
//                         ],
//                       ),
//                     ],
//
//                     const SizedBox(height: 24),
//
//                     SizedBox(
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: (state is VerifyingState) ? null : (showOtp ? vm.onVerifyPressed : buttonAction),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.amber[600],
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: (state is VerifyingState)
//                             ? const SizedBox(
//                           height: 22,
//                           width: 22,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                             : Text(
//                           showOtp ? 'Verify' : (showName ? 'Register' : 'Login'),
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  // 6-digit OTP controllers/focus nodes
  final List<TextEditingController> _otpCtrls =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpNodes = List.generate(6, (_) => FocusNode());

  // UI helpers
  bool _wasOnOtpBefore = false; // remember if we entered OTP flow
  bool _stayOnOtp = false;      // keep showing OTP during transient states
  bool _pendingClearOtp = false; // clear boxes *only* after a resend (fresh OTP)

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    for (final c in _otpCtrls) c.dispose();
    for (final n in _otpNodes) n.dispose();
    super.dispose();
  }

  void _clearOtpFields() {
    for (final c in _otpCtrls) c.clear();
  }

  void _focusFirstOtp() {
    if (_otpNodes.isNotEmpty) {
      Future.microtask(() => _otpNodes.first.requestFocus());
    }
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
        email: _emailController.text,
      );
    } else {
      buttonText = 'Login';
      buttonAction =
      isLoading ? null : () => vm.onLoginPressed(_phoneController.text);
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

    void _notifyOtp() {
      final code = _otpCtrls.map((c) => c.text).join();
      vm.onOtpChanged(code);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffDEBB33),
        elevation: 0,
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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),

                    // Hide welcome/login copy when OTP UI is showing
                    if (!showOtpUI) ...[
                      Text(
                        appLang.loginWelcomeMessage,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                                  vertical: 14, horizontal: 12,
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
                        Text(appLang.userName),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: appLang.userNameHint,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (s) => _nameController.text = s,
                        ),
                        const SizedBox(height: 12),
                        Text(appLang.userEmail),
                        const SizedBox(height: 8),
                        TextFormField(
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
                                vertical: 14, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (s) => _emailController.text = s,
                        ),
                      ],
                    ],

                    // ================== OTP View (6 digits) ==================
                    if (showOtpUI) ...[
                      Text(
                        '${appLang.enterOtpSentTo} $phone',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (i) {
                          return SizedBox(
                            width: 48,
                            height: 64,
                            child: TextField(
                              controller: _otpCtrls[i],
                              focusNode: _otpNodes[i],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters:  [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(1),
                              ],
                              onChanged: (v) {
                                if (v.isNotEmpty && i < 5) {
                                  _otpNodes[i + 1].requestFocus();
                                } else if (v.isEmpty && i > 0) {
                                  _otpNodes[i - 1].requestFocus();
                                }
                                _notifyOtp(); // ← won't be cleared now unless resend triggered
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              style: const TextStyle(fontSize: 24, letterSpacing: 2),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 12),

                      // error text (if any)
                      Builder(
                        builder: (_) {
                          if (state is AwaitingOtpState &&
                              state.errorMessage != null &&
                              state.errorMessage!.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                state.errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
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
                            onPressed: (state is VerifyingState) || secondsRemaining > 0
                                ? null
                                : () {
                              // Mark that the next AwaitingOtpState is a *fresh* OTP
                              _pendingClearOtp = true;
                              _stayOnOtp = true;
                              _wasOnOtpBefore = true;
                              setState(() {});
                              vm.onResendOtp();
                            },
                            child:  Text(appLang.resendOTP),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 24),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: (state is VerifyingState)
                            ? null
                            : (showOtp ? vm.onVerifyPressed : buttonAction),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: (state is VerifyingState)
                            ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : Text(
                          showOtp ? appLang.verify : (showName ? appLang.register : appLang.login),
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

