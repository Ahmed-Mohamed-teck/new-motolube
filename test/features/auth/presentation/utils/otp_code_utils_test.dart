import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:newmotorlube/features/auth/presentation/utils/otp_code_utils.dart';

void main() {
  group('otpCodeFromFields', () {
    test('keeps field order for LTR layouts', () {
      final code = otpCodeFromFields(const [
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
      ], TextDirection.ltr);

      expect(code, '123456');
    });

    test('uses visual entry order for RTL layouts', () {
      final code = otpCodeFromFields(const [
        '6',
        '5',
        '4',
        '3',
        '2',
        '1',
      ], TextDirection.rtl);

      expect(code, '123456');
    });

    test('normalizes Arabic and Persian digits', () {
      expect(normalizeOtpDigits('١٢٣٤٥٦'), '123456');
      expect(normalizeOtpDigits('۱۲۳۴۵۶'), '123456');
    });
  });
}
