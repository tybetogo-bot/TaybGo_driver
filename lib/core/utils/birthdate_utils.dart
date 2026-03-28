import 'package:intl/intl.dart';

class BirthdateUtils {
  static const int minDriverAge = 18;
  static const int maxDriverAge = 80;

  static String formatForApi(DateTime birthdate) {
    return DateFormat('yyyy-MM-dd').format(_dateOnly(birthdate));
  }

  static int calculateAge(DateTime birthdate, {DateTime? referenceDate}) {
    final today = _dateOnly(referenceDate ?? DateTime.now());
    final normalizedBirthdate = _dateOnly(birthdate);

    var age = today.year - normalizedBirthdate.year;
    final hasHadBirthdayThisYear =
        today.month > normalizedBirthdate.month ||
        (today.month == normalizedBirthdate.month &&
            today.day >= normalizedBirthdate.day);

    if (!hasHadBirthdayThisYear) {
      age--;
    }

    return age;
  }

  static bool isWithinDriverAgeRange(
    DateTime birthdate, {
    DateTime? referenceDate,
  }) {
    final age = calculateAge(birthdate, referenceDate: referenceDate);
    return age >= minDriverAge && age <= maxDriverAge;
  }

  static DateTime latestEligibleBirthdate({DateTime? referenceDate}) {
    final today = _dateOnly(referenceDate ?? DateTime.now());
    return DateTime(today.year - minDriverAge, today.month, today.day);
  }

  static DateTime earliestEligibleBirthdate({DateTime? referenceDate}) {
    final today = _dateOnly(referenceDate ?? DateTime.now());
    return DateTime(today.year - maxDriverAge, today.month, today.day);
  }

  static DateTime? parse(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return _dateOnly(value.toLocal());
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return _dateOnly(parsed.toLocal());
      }
    }
    return null;
  }

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
