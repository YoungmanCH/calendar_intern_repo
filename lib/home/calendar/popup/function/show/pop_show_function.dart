import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/pop_provider.dart';
// import '../../../home/home_provider.dart';
import '../../../../../database/database.dart';
import 'package:holiday_jp/holiday_jp.dart' as holiday_jp;

final queryexecutor = connectionDatabase();
final database = ScheduleDatabase(queryexecutor);

scheJudgeFunc(WidgetRef ref, DateTime firstDateController) async{
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

bool judgePageDateFunc(DateTime day) {
  return holiday_jp.isHoliday(day);
}

