import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_function.dart';

final selectedDatePageProvider = StateProvider<DateTime>((ref) => DateTime.now());

final currentPageProvider = Provider.family<int, DateTime?>((ref, date) {
  if (date != null) {
    final dateDiff = date .year - DateTime.now().year;
    if (dateDiff != 0) {
      return dateDiff * 12 + date.month - 1;
    }
  }
  return DateTime.now().month - 1;
});

final homePageIndexProvider = StateProvider<int>((ref) => getElapsedMonths(DateTime.now()));

final firstDayProvider = StateProvider<DateTime>((ref) => DateTime.now());
final lastDayProvider = StateProvider<DateTime>((ref) => DateTime.now());