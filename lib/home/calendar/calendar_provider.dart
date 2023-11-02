import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holiday_jp/holiday_jp.dart' as holiday_jp;

//祝日判定は、どうしても手間がかかるため、外部パッケージを使わせていただきました。

// final monthNumberProvider = Provider<List<int>>((ref) {
//   return List.generate(12, (index) => index+1);
// });
// final selectedMonthStringProvider = StateProvider<String>((ref) => ''); 

final selectedCountMonthProvider = StateProvider<int>((ref) => DateTime.now().month);

final firstDayMonthProvider = Provider.family<String, DateTime>((ref, firstDay) {
  if (firstDay.month < 10) {
    return '${firstDay.year.toString()}年0${firstDay.month.toString()}月';
  }
  return '${firstDay.year.toString()}年${firstDay.month.toString()}月'; 
});

final setDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

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


// //今回は、dynamicが返り値、引数タプル型（レコード型）が引数の方を表している。なお、返り値が複数存在する場合は、レコード型を使用すると良い。
// final calendarProvider = Provider.family<dynamic, ({DateTime firstDay})>((ref, args) {


//     List dateList = [];
//     final List dayOfWeek = ['月', '火', '水', '木', '金', '土', '日'];
//     final List monthNumber = List.generate(12, (index) => index+1);
//     String selectedMonth = '';
//     int todayMonth = 0;
//     List<int> dateInMonth = [];
//     List<int> dateInLastMonth = [];
//     List<int> dateInNextMonth = [];
//     int year = 0;
//     int month = 0;
//     int lateCount = 0;
//     int plusCount = 0;
//     bool judge = false;
//     int dateSave = 0;
//     int plusSaveCount = 0;

//     List<bool> calJudgeList = [];

//       final firstDay = args.firstDay;
//       // final firstDay = args.$1;
//       // final lastDay = args.$2;
//       void dateInMonthFunc() {
//       year = firstDay.year;
//       month = firstDay.month;
//       DateTime firstDate = DateTime(year, month);
//       DateTime endDate = DateTime(year, month+1);
//       DateTime lastMonth = DateTime(year, month-1);
//       DateTime nextMonth = DateTime(year, month+1);
//       DateTime nextnextMonth = DateTime(year, month+2);
//       dateInMonth.clear();

//       //先月
//       for (DateTime date = lastMonth; date.isBefore(firstDate); date = date.add(const Duration(days: 1))) {
//         dateInLastMonth.add(date.day);
//       }

//       //来月
//       for (DateTime date = nextMonth; date.isBefore(nextnextMonth); date = date.add(const Duration(days: 1))) {
//         dateInNextMonth.add(date.day);
//       }

//       //今月
//       for (DateTime date = firstDate; date.isBefore(endDate); date = date.add(const Duration(days: 1))) {
//         dateInMonth.add(date.day);
//       }
//     }

//     void dateListFunc() {
//       dateList.clear();
//       for (int i = 0; i < 42; i++) {
//         dateList.add(i);
//       }
//     }

//     dateInMonthFunc();
//     dateListFunc();
//     calJudgeList.clear();

//     return (lateCount: lateCount, dateInMonth: dateInMonth);
// });
