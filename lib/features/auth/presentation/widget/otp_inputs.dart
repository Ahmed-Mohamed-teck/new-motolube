import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/otp_code_utils.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    this.length = 6,
    this.onChanged,
    this.boxSize = 48,
  });

  final int length;
  final double boxSize;
  final ValueChanged<String>? onChanged;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _notify() {
    final code = otpCodeFromFields(
      _controllers.map((c) => c.text).toList(),
      Directionality.of(context),
    );
    widget.onChanged?.call(code);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: widget.boxSize,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩۰-۹]')),
              LengthLimitingTextInputFormatter(1),
            ],
            maxLength: 1,
            decoration: const InputDecoration(
              counterText: '',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              final digit = normalizeOtpDigits(value);
              if (digit != value) {
                _controllers[index].value = TextEditingValue(
                  text: digit,
                  selection: TextSelection.collapsed(offset: digit.length),
                );
              }

              final isRtl = Directionality.of(context) == TextDirection.rtl;
              if (digit.length == 1) {
                if (isRtl) {
                  if (index > 0) _focusNodes[index - 1].requestFocus();
                } else {
                  if (index < widget.length - 1) {
                    _focusNodes[index + 1].requestFocus();
                  }
                }
              } else if (value.isEmpty) {
                if (isRtl) {
                  if (index < widget.length - 1) {
                    _focusNodes[index + 1].requestFocus();
                  }
                } else {
                  if (index > 0) _focusNodes[index - 1].requestFocus();
                }
              }
              _notify();
            },
          ),
        );
      }),
    );
  }
}
