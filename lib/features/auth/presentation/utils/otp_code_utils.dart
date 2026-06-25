import 'dart:ui';

String normalizeOtpDigits(String value) {
  final buffer = StringBuffer();

  for (final rune in value.runes) {
    if (rune >= 0x30 && rune <= 0x39) {
      buffer.writeCharCode(rune);
    } else if (rune >= 0x0660 && rune <= 0x0669) {
      buffer.writeCharCode(0x30 + rune - 0x0660);
    } else if (rune >= 0x06F0 && rune <= 0x06F9) {
      buffer.writeCharCode(0x30 + rune - 0x06F0);
    }
  }

  return buffer.toString();
}

String otpCodeFromFields(List<String> fieldValues, TextDirection direction) {
  final orderedValues =
      direction == TextDirection.rtl ? fieldValues.reversed : fieldValues;

  return normalizeOtpDigits(orderedValues.join());
}
