enum HomeEarningsDateFilter { all, today, week, month }

class HomeEarningsDateRange {
  final DateTime? from;
  final DateTime? to;

  const HomeEarningsDateRange({this.from, this.to});
}

HomeEarningsDateRange homeEarningsDateRange(
  HomeEarningsDateFilter filter, {
  DateTime? now,
}) {
  final reference = (now ?? DateTime.now()).toLocal();
  final todayStart = DateTime(reference.year, reference.month, reference.day);

  return switch (filter) {
    HomeEarningsDateFilter.all => const HomeEarningsDateRange(),
    HomeEarningsDateFilter.today => HomeEarningsDateRange(
      from: todayStart,
      to: reference,
    ),
    HomeEarningsDateFilter.week => HomeEarningsDateRange(
      from: todayStart.subtract(
        Duration(days: todayStart.weekday - DateTime.monday),
      ),
      to: reference,
    ),
    HomeEarningsDateFilter.month => HomeEarningsDateRange(
      from: DateTime(reference.year, reference.month),
      to: reference,
    ),
  };
}

bool isWithinHomeEarningsPeriod(
  DateTime date,
  HomeEarningsDateFilter filter, {
  DateTime? now,
}) {
  if (filter == HomeEarningsDateFilter.all) return true;

  final reference = (now ?? DateTime.now()).toLocal();
  final value = date.toLocal();
  final todayStart = DateTime(reference.year, reference.month, reference.day);

  final DateTime rangeStart;
  final DateTime rangeEnd;

  switch (filter) {
    case HomeEarningsDateFilter.all:
      return true;
    case HomeEarningsDateFilter.today:
      rangeStart = todayStart;
      rangeEnd = todayStart.add(const Duration(days: 1));
    case HomeEarningsDateFilter.week:
      rangeStart = todayStart.subtract(
        Duration(days: todayStart.weekday - DateTime.monday),
      );
      rangeEnd = todayStart.add(const Duration(days: 1));
    case HomeEarningsDateFilter.month:
      rangeStart = DateTime(reference.year, reference.month);
      rangeEnd = DateTime(reference.year, reference.month + 1);
  }

  return !value.isBefore(rangeStart) && value.isBefore(rangeEnd);
}
