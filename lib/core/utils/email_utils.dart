final RegExp _emailValidationPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

String normalizeEmail(String value) => value.trim().toLowerCase();

bool isValidNormalizedEmail(String value) {
  final normalized = normalizeEmail(value);
  if (normalized.isEmpty) return false;
  return _emailValidationPattern.hasMatch(normalized);
}
