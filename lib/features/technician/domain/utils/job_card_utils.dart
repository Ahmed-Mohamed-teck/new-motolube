const Set<String> jobCardInvalidTokens = {
  'NA',
  'N/A',
  'NULL',
  'NONE',
  '-',
  '--',
  '0',
  'NA/',
  '/',
};

const Set<String> jobCardKeyTokens = {
  'srnumber',
  'srnum',
  'srno',
  'srid',
  'srref',
  'jobcardid',
  'jobcardnumber',
  'jobcardno',
  'jobcard',
  'openjobcardid',
  'openjobcardnumber',
  'openjobcardno',
  'jobcardref',
  'jobcardcode',
  'jobcardserial',
  'sr_num',
  'openjobcard',
};

String? sanitizeJobCardId(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  final normalized = trimmed.toUpperCase();
  if (jobCardInvalidTokens.contains(normalized)) return null;
  return trimmed;
}

String? findJobCardId(dynamic data) {
  final result = _walkForJobCardId(data);
  return result;
}

String? _walkForJobCardId(dynamic data) {
  if (data == null) return null;
  if (data is Map) {
    for (final entry in data.entries) {
      final key = entry.key.toString();
      final normalizedKey = normalizeJobCardKey(key);
      if (jobCardKeyTokens.contains(normalizedKey)) {
        final value = entry.value;
        if (value is String || value is num) {
          final candidate = sanitizeJobCardId(value.toString());
          if (candidate != null) return candidate;
        }
      }
      final nested = _walkForJobCardId(entry.value);
      if (nested != null) return nested;
    }
  } else if (data is Iterable) {
    for (final element in data) {
      final nested = _walkForJobCardId(element);
      if (nested != null) return nested;
    }
  }
  return null;
}

String normalizeJobCardKey(String value) {
  return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
}
