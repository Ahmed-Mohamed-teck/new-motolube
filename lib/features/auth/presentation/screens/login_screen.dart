// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:newmotorlube/core/providers/global_lang_provider.dart';
// import 'package:newmotorlube/features/auth/provider/auth_provider.dart';
//
// import '../../../../core/utils/ui_components/shared_ui.dart';
//
// /// --- Providers --------------------------------------------------------------
// /// Whether to show the username TextFormField (shown when phone is not registered)
// final showNameFieldProvider = StateProvider<bool>((ref) => false);
//
// /// Persist the raw local phone input (without country code)
// final phoneNumberProvider = StateProvider<String>((ref) => '');
//
// /// Persist username input when needed
// final usernameProvider = StateProvider<String>((ref) => '');
//
// class LoginScreen extends ConsumerWidget {
//   const LoginScreen({super.key});
//
//   static const _saudiCode = '+966';
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final showName = ref.watch(showNameFieldProvider);
//     final media = MediaQuery.of(context);
//
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: const Color(0xffDEBB33),
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.public, color: Colors.black),
//             onPressed: () => buildShowLangBottomSheet(context, ref),
//           ),
//         ),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               // Yellow background layer
//               Container(color: const Color(0xffDEBB33)),
//
//               // Centered decorative image
//               Center(
//                 child: Image.asset(
//                   'assets/images/login-bg.png',
//                   fit: BoxFit.contain,
//                 ),
//               ),
//
//               // Bottom sheet-like form container
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 250),
//                   curve: Curves.ease,
//                   height: showName
//                       ? media.size.height * 0.45
//                       : media.size.height * 0.34,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//                   child: _LoginForm(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _LoginForm extends ConsumerStatefulWidget {
//
//
//   @override
//   ConsumerState<_LoginForm> createState() => _LoginFormState();
// }
//
// class _LoginFormState extends ConsumerState<_LoginForm> {
//   final _formKey = GlobalKey<FormState>();
//
//   String _composeFullPhone(String localPart) {
//     // Normalize: if user starts with a leading 0 (e.g. 05...), strip it when composing
//     final trimmed = localPart.trim();
//     final normalized = trimmed.startsWith('0') ? trimmed.substring(1) : trimmed;
//     return '+966$normalized';
//   }
//
//   static String _digitsOnly(String s) => s.replaceAll(RegExp(r'\D'), '');
//
//   String? _ksaPhoneValidator(String? value) {
//     final v = (value ?? '').trim();
//     if (v.isEmpty) return "appLang.requiredField"; // from your localization
//
//     // Accept patterns like 5XXXXXXXX or 05XXXXXXXX
//     final regex = RegExp(r'^(?:05|5)\d{8}$'); // Fixed regex
//     if (!regex.hasMatch(v)) {
//       return "appLang.invalidPhone"; // ensure you have this key, or replace text
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final showName = ref.watch(showNameFieldProvider);
//     final phoneLocal = ref.watch(phoneNumberProvider);
//     final username = ref.watch(usernameProvider);
//
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const SizedBox(height: 8),
//           Text(
//             appLang.loginWelcomeMessage,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 24),
//
//           // Phone label
//           Text(appLang.phoneNumber),
//           const SizedBox(height: 8),
//
//           Row(
//             children: [
//               // Country code box
//               Container(
//                 width: 84,
//                 padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade400),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   '+966',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ),
//               const SizedBox(width: 12),
//
//               // Phone input
//               Expanded(
//                 child: TextFormField(
//                   initialValue: phoneLocal,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     hintText: '5XXXXXXXX',
//                     contentPadding:
//                     const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   validator: _ksaPhoneValidator,
//                   onChanged: (value) =>
//                   ref.read(phoneNumberProvider.notifier).state = value,
//                 ),
//               ),
//             ],
//           ),
//
//           // Username (only when needed)
//           if (showName) ...[
//             const SizedBox(height: 16),
//             Text('اسم المستخدم'),
//             const SizedBox(height: 8),
//             TextFormField(
//               initialValue: username,
//               decoration: InputDecoration(
//                 hintText: 'أدخل اسم المستخدم',
//                 contentPadding:
//                 const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//               onChanged: (v) =>
//               ref.read(usernameProvider.notifier).state = v.trim(),
//               validator: (v) {
//                 if (!showName) return null;
//                 if ((v ?? '').trim().isEmpty) return "appLang.requiredField";
//                 return null;
//               },
//             ),
//           ],
//
//           const Spacer(),
//
//           SizedBox(
//             height: 50,
//             child: ElevatedButton(
//               onPressed: () async {
//                 // Validate phone first; if showName is active, validate username too
//                 if (!_formKey.currentState!.validate()) return;
//
//                 final localPhone = ref.read(phoneNumberProvider).trim();
//                 final fullPhone = _composeFullPhone(localPhone);
//
//                 final isRegistered = await ref
//                     .read(authViewModelProvider.notifier)
//                     .isRegisteredUserUseCase(phoneNumber: fullPhone);
//
//                 if (!isRegistered) {
//                   // Reveal username field for registration flow
//                   ref.read(showNameFieldProvider.notifier).state = true;
//                   // Optionally: you can scroll into view or show a message
//                 } else {
//                   // Proceed to next screen (e.g., send OTP)
//                   // Navigator.pushNamed(context, 'baseHomeScreen');
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.amber[600],
//
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(
//                 appLang.login,
//                 style: const TextStyle(fontSize: 16),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ✅ keep your existing ones
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import 'package:newmotorlube/core/utils/ui_components/shared_ui.dart';
import 'package:newmotorlube/features/auth/provider/auth_provider.dart';

// ⛳️ adjust these imports to where you placed the providers/VMs:

import '../../../../core/utils/enum.dart';                // exports: otpProvider

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  static const _saudiCode = '+966';

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // Flow + child VMs
    final flow     = ref.watch(authFlowProvider);
    final flowVm   = ref.read(authFlowProvider.notifier);

    final phone    = ref.watch(loginPhoneProvider);
    final phoneVm  = ref.read(loginPhoneProvider.notifier);

    final reg      = ref.watch(registerProvider);
    final regVm    = ref.read(registerProvider.notifier);

    final otp      = ref.watch(otpProvider);
    final otpVm    = ref.read(otpProvider.notifier);

    final media = MediaQuery.of(context);

    final showName = flow.step == AuthFlowStep.needRegistration;
    final showOtp  = flow.step == AuthFlowStep.otp;

    // Bottom sheet height per step
    final double sheetHeight = showOtp
        ? media.size.height * 0.42
        : showName
        ? media.size.height * 0.52
        : media.size.height * 0.38;

    String? _resolveError(String? key) {
      if (key == null) return null;
      switch (key) {
        case 'appLang.requiredField':
          return 'appLang.requiredField';
        case 'appLang.invalidPhone':
          return 'appLang.invalidPhone';
        case 'appLang.invalidOtp':
          return 'appLang.invalidOtp';
        default:
          return 'appLang.errorOccurred'; // fallback
      }
    }

    String _ctaLabel() {
      switch (flow.step) {
        case AuthFlowStep.enterPhone:
          return 'appLang.continueLabel';   // e.g., "Continue"
        case AuthFlowStep.needRegistration:
          return 'appLang.createAccount';    // e.g., "Create account"
        case AuthFlowStep.otp:
          return 'appLang.verifyCode';       // e.g., "Verify code"
        case AuthFlowStep.done:
          return 'appLang.continueLabel';
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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

              // Bottom sheet-like container
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.ease,
                  height: sheetHeight,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        appLang.loginWelcomeMessage,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Phone label
                      Text(appLang.phoneNumber),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          // Country code box
                          Container(
                            width: 84,
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _saudiCode,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Phone input
                          Expanded(
                            child: TextFormField(
                              initialValue: phone.phoneLocal,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: '5XXXXXXXX',
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                errorText: _resolveError(phone.errorKey),
                              ),
                              onChanged: phoneVm.onChanged,
                            ),
                          ),
                        ],
                      ),

                      // Username (only when needed)
                      if (showName) ...[
                        const SizedBox(height: 16),
                        Text('اسم المستخدم'), // e.g., "اسم المستخدم"
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: reg.username,
                          decoration: InputDecoration(
                            hintText: "أدخل اسم المستخدم", // e.g., "أدخل اسم المستخدم"
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorText: _resolveError(reg.errorKey),
                          ),
                          onChanged: regVm.onChanged,
                        ),
                      ],

                      // OTP (only when sent)
                      if (showOtp) ...[
                        const SizedBox(height: 16),
                        Text("رمز التحقق"), // e.g., "رمز التحقق"
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: otp.code,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '••••',
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorText: _resolveError(otp.errorKey),
                          ),
                          onChanged: otpVm.onChanged,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: flow.loading
                                ? null
                                : () {
                              final phoneFull = flow.fullPhone;
                              if (phoneFull != null) {
                                otpVm.sendOtp(phoneFull);
                              }
                            },
                            child: Text("اعاده ارسال"),
                          ),
                        ),
                      ],

                      const Spacer(),

                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: flow.loading
                              ? null
                              : () async {
                            switch (flow.step) {
                              case AuthFlowStep.enterPhone:
                                await flowVm.continueFromPhone();
                                break;
                              case AuthFlowStep.needRegistration:
                                await flowVm.registerThenOtp();
                                break;
                              case AuthFlowStep.otp:
                                await flowVm.verifyOtpThenAuthorize();
                                if (flow.step ==
                                    AuthFlowStep.done) {
                                  // Navigate after successful verify
                                  // Navigator.pushReplacementNamed(context, 'baseHomeScreen');
                                }
                                break;
                              case AuthFlowStep.done:
                              // Already done; optionally navigate
                              // Navigator.pushReplacementNamed(context, 'baseHomeScreen');
                                break;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[600],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: flow.loading
                              ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : Text(
                            _ctaLabel(),
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
      ),
    );
  }
}

