import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/pop_show_provider.dart';
import '../../../../../database/database.dart';
import 'package:holiday_jp/holiday_jp.dart' as holiday_jp;

final queryexecutor = connectionDatabase();
final database = ScheduleDatabase(queryexecutor);

Future scheJudgeFunc(WidgetRef ref, DateTime firstDateController) async{        
  await database.getSchedule().then((data){
    final dates = data.map((record) => record.date).toList();  
    if (dates.contains(firstDateController)) {
      ref.watch(scheExistJudgeProvider.notifier).state = true;
    }else {
      ref.watch(scheExistJudgeProvider.notifier).state = false;
    }
  });
}

//祝日の際のカラー設定
void switchFunc(WidgetRef ref, DateTime newFirstDay) {
  final judgeWeekPop = ref.watch(judgeWeekPopProvider);
  ref.watch(holidayJudgeProvider.notifier).state = judgePageDateFunc(newFirstDay);
  if (ref.watch(holidayJudgeProvider) == false) {
    switch (judgeWeekPop){
      case 1:
        ref.watch(weekPopProvider.notifier).state = '月';
        ref.watch(weekColorProvider.notifier).state = Colors.black;
      break;
      case 2:
        ref.watch(weekPopProvider.notifier).state = '火';
        ref.watch(weekColorProvider.notifier).state = Colors.black;
        break;
      case 3:
        ref.watch(weekPopProvider.notifier).state = '水';
        ref.watch(weekColorProvider.notifier).state  = Colors.black;
        break;
      case 4:
        ref.watch(weekPopProvider.notifier).state = '木';
        ref.watch(weekColorProvider.notifier).state  = Colors.black;
        break;
      case 5:
        ref.watch(weekPopProvider.notifier).state = '金';
        ref.watch(weekColorProvider.notifier).state  = Colors.black;
        break;
      case 6:
        ref.watch(weekPopProvider.notifier).state = '土';
        ref.watch(weekColorProvider.notifier).state  = Colors.blue;
        break;
      case 7:
        ref.watch(weekPopProvider.notifier).state = '日';
        ref.watch(weekColorProvider.notifier).state  = Colors.red;
        break;
      default: 
        debugPrint('error about judgeWeekPop');
        break;
    }
  }else {
    ref.watch(holidayJudgeProvider.notifier).state = false;
    switch (judgeWeekPop){
      case 1:
        ref.watch(weekPopProvider.notifier).state = '月';
        ref.watch(weekColorProvider.notifier).state  = Colors.red;
      break;
      case 2:
        ref.watch(weekPopProvider.notifier).state = '火';
        ref.watch(weekColorProvider.notifier).state  = Colors.red;
        break;
      case 3:
        ref.watch(weekPopProvider.notifier).state = '水';
        ref.watch(weekColorProvider.notifier).state  = Colors.red;
        break;
      case 4:
        ref.watch(weekPopProvider.notifier).state = '木';
        ref.watch(weekColorProvider.notifier).state  = Colors.red;
        break;
      case 5:
        ref.watch(weekPopProvider.notifier).state = '金';
        ref.watch(weekColorProvider.notifier).state  = Colors.red;
        break;
      case 6:
        ref.watch(weekPopProvider.notifier).state = '土';
        ref.watch(weekColorProvider.notifier).state  = Colors.red;
        break;
      case 7:
        ref.watch(weekPopProvider.notifier).state = '日';
        ref.watch(weekColorProvider.notifier).state  = Colors.red;
        break;
      default: 
        debugPrint('error about judgeWeekPop');
        break;
    }
  }
}

//祝日を一覧取得
bool judgePageDateFunc(DateTime day) {
  return holiday_jp.isHoliday(day);
}

//データベースの中身を各リストに追加
Future scheGetFunc(WidgetRef ref, DateTime firstDateController) async {
  ref.watch(scheduleTitleListProvider.notifier).state = await database.getScheduleTitle(firstDateController);
  ref.watch(scheduleJudgeListProvider.notifier).state = await database.getScheduleJudge(firstDateController);
  ref.watch(scheduleStartDayListProvider.notifier).state = await database.getScheduleStartDay(firstDateController);
  ref.watch(scheduleEndDayListProvider.notifier).state = await database.getScheduleEndDay(firstDateController);
}

//表示する日付を文字列に変換
String newMonthDatePopFunc(WidgetRef ref, String newMonthPop, String newDatePop, DateTime newFirstDay) {
  if (newFirstDay.month < 10) {
    newMonthPop = '0${newFirstDay.month}';
  } else {
    newMonthPop = '${newFirstDay.month}';
  }
  if (newFirstDay.day < 10) {
    newDatePop = '0${newFirstDay.day}';
  } else {
    newDatePop = '${newFirstDay.day}';
  }
  
  return '${newFirstDay.year}/$newMonthPop/$newDatePop(${ref.watch(weekPopProvider)})';
}