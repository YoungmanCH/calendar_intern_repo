int getElapsedMonths(DateTime date) {
  final baseDate = DateTime(1970, 1);
  print('dateMonth: ${date}');
  final elapsedMonth = (date.year - baseDate.year) * 12 + date.month - baseDate.month;
  return elapsedMonth;
}

DateTime getYearFromElapsedMonths(int elapsedMonths) {
  final baseDate = DateTime(1970, 1, 1);
  final addYears = elapsedMonths ~/ 12 + baseDate.year;
  final addMonths = elapsedMonths  % 12 + baseDate.month;
  return DateTime(addYears, addMonths);
}