import 'package:flutter_test/flutter_test.dart';
import 'package:teybatdriver/features/home/utils/home_earnings_date_filter.dart';

void main() {
  final now = DateTime(2026, 8, 20, 15, 30);

  test('all time includes historical dates', () {
    expect(
      isWithinHomeEarningsPeriod(
        DateTime(1960),
        HomeEarningsDateFilter.all,
        now: now,
      ),
      isTrue,
    );
  });

  test('today includes only the current calendar day', () {
    expect(
      isWithinHomeEarningsPeriod(
        DateTime(2026, 8, 20, 8),
        HomeEarningsDateFilter.today,
        now: now,
      ),
      isTrue,
    );
    expect(
      isWithinHomeEarningsPeriod(
        DateTime(2026, 8, 19, 23, 59),
        HomeEarningsDateFilter.today,
        now: now,
      ),
      isFalse,
    );
  });

  test('week starts on Monday', () {
    expect(
      isWithinHomeEarningsPeriod(
        DateTime(2026, 8, 17),
        HomeEarningsDateFilter.week,
        now: now,
      ),
      isTrue,
    );
    expect(
      isWithinHomeEarningsPeriod(
        DateTime(2026, 8, 16, 23, 59),
        HomeEarningsDateFilter.week,
        now: now,
      ),
      isFalse,
    );
  });

  test('month includes only the current calendar month', () {
    expect(
      isWithinHomeEarningsPeriod(
        DateTime(2026, 8, 1),
        HomeEarningsDateFilter.month,
        now: now,
      ),
      isTrue,
    );
    expect(
      isWithinHomeEarningsPeriod(
        DateTime(2026, 7, 31, 23, 59),
        HomeEarningsDateFilter.month,
        now: now,
      ),
      isFalse,
    );
  });

  test('API date ranges preserve all time and calendar boundaries', () {
    final all = homeEarningsDateRange(HomeEarningsDateFilter.all, now: now);
    final week = homeEarningsDateRange(HomeEarningsDateFilter.week, now: now);
    final month = homeEarningsDateRange(HomeEarningsDateFilter.month, now: now);

    expect(all.from, isNull);
    expect(all.to, isNull);
    expect(week.from, DateTime(2026, 8, 17));
    expect(week.to, now);
    expect(month.from, DateTime(2026, 8, 1));
    expect(month.to, now);
  });
}
