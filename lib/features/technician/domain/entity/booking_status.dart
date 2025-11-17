class TechnicianBookingStatus {
  final String label;
  final String code;
  final String hexColor;

  const TechnicianBookingStatus({
    this.label = '',
    this.code = '',
    this.hexColor = '',
  });

  bool get hasLabel => label.trim().isNotEmpty;

  bool get hasColor => hexColor.trim().isNotEmpty;

  /// Returns an ARGB color int if the hex value is valid (`#RRGGBB`).
  int? get colorValue {
    if (!hasColor) return null;
    final normalized = hexColor.replaceAll('#', '').trim();
    if (normalized.length != 6) return null;
    final parsed = int.tryParse(normalized, radix: 16);
    if (parsed == null) return null;
    return 0xFF000000 | parsed;
  }

  TechnicianBookingStatus copyWith({
    String? label,
    String? code,
    String? hexColor,
  }) {
    return TechnicianBookingStatus(
      label: label ?? this.label,
      code: code ?? this.code,
      hexColor: hexColor ?? this.hexColor,
    );
  }

  factory TechnicianBookingStatus.fromRaw({
    String? label,
    String? code,
    String? hexColor,
  }) {
    return TechnicianBookingStatus(
      label: label?.trim() ?? '',
      code: code?.trim() ?? '',
      hexColor: hexColor?.trim() ?? '',
    );
  }
}
