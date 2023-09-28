import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holiday_jp/holiday_jp.dart' as holiday_jp;
//祝日判定は、どうしても手間がかかるため、外部パッケージを使わせていただきました。

final monthNumberProvider = Provider<List<int>>((ref) {
  return List.generate(12, (index) => index+1);
});
final selectedMonthStringProvider = StateProvider<String>((ref) => ''); 

final firstDayMonthProvider = Provider.family<String, DateTime>((ref, firstDay) {
  if (firstDay.month < 10) {
    return '${firstDay.year.toString()}年0${firstDay.month.toString()}月';
  }
  return '${firstDay.year.toString()}年${firstDay.month.toString()}月'; 
});

final selectedMonthProvider = StateProvider<String>((ref) => '');
final selectedYearProvider = StateProvider<int>((ref) => DateTime.now().year);
final selectedYearProvider2 = Provider.family<int, DateTime>((ref, firstDay) => firstDay.year);

final holidaysProvider = StreamProvider.family<List<String>, DateTime>((ref, firstDay) async* {
  final setTimeString = ref.watch(selectedYearProvider2(firstDay)).toString();
  DateTime setTime = DateTime.parse('$setTimeString-01-01');
  int setYear = setTime.year;
  final startDate = DateTime.utc(setYear, 1, 1);
  final endDate = DateTime.utc(setYear, 12, 31);
  final searchHolidays = holiday_jp.between(startDate, endDate);
  final holidayList = <String>[];

  for (final holiday in searchHolidays) {
    holidayList.add(holiday.date.toString());
    // リスト全体をストリームに返す
    yield holidayList;
  }
});