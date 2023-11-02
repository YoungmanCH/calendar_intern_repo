import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/pop_show_provider.dart';
import '../../../../../database/database.dart';
import 'package:holiday_jp/holiday_jp.dart' as holiday_jp;

//assert:デバッグの際にエラーを出すもの。throwみたいなもの。

final queryexecutor = connectionDatabase();
final database = ScheduleDatabase(queryexecutor);

Future scheJudgeFunc(WidgetRef ref, DateTime firstDateController) async {
  await database.getScheduleList().then((data) {
    final dates = data.map((record) => record.date).toList();
    if (dates.contains(firstDateController)) {
      ref.watch(scheExistJudgeProvider.notifier).state = true;
    } else {
      ref.watch(scheExistJudgeProvider.notifier).state = false;
    }
  });
}

Future<bool> scheJudgeFunc2(WidgetRef ref, DateTime firstDateController) async {
  bool judge = false;
  await database.getScheduleList().then((data) {
    final dates = data.map((record) => record.date).toList();
    //cast<>　で型を変換する。
    final hasData = dates.cast<DateTime>().any((element) =>
        element.day == firstDateController.day &&
        element.year == firstDateController.year &&
        element.month == firstDateController.month);

    if (hasData) {
      ref.watch(scheExistJudgeProvider.notifier).state = true;
      judge = true;
    } else {
      ref.watch(scheExistJudgeProvider.notifier).state = false;
      judge = false;
    }
    // if (dates.contains(firstDateController)) {
    //   ref.watch(scheExistJudgeProvider.notifier).state = true;
    //   judge = true;
    // }else {
    //   ref.watch(scheExistJudgeProvider.notifier).state = false;
    //   judge = false;
    // }
  });
  return judge;
}

///スラッシュは三つにすることで、カーソルを合わせるとそのコメントも表示される。（ドキュメンテーション）

///祝日を一覧取得 休日かどうか
bool holidayJudge(DateTime day) {
  return holiday_jp.isHoliday(day);
}

//データベースの中身を各リストに追加
Future scheGetFunc(WidgetRef ref, DateTime firstDateController) async {
  ref.watch(scheduleTitleListProvider.notifier).state =
      await database.getScheduleTitle(firstDateController);
  ref.watch(scheduleJudgeListProvider.notifier).state =
      await database.getScheduleJudge(firstDateController);
  ref.watch(scheduleStartDayListProvider.notifier).state =
      await database.getScheduleStartDay(firstDateController);
  ref.watch(scheduleEndDayListProvider.notifier).state =
      await database.getScheduleEndDay(firstDateController);
}

//表示する日付を文字列に変換
String newMonthDatePopFunc(
  DateTime newFirstDay,
) {
  String newMonthPop;
  if (newFirstDay.month < 10) {
    newMonthPop = '0${newFirstDay.month}';
  } else {
    newMonthPop = '${newFirstDay.month}';
  }
  String newDatePop;
  if (newFirstDay.day < 10) {
    newDatePop = '0${newFirstDay.day}';
  } else {
    newDatePop = '${newFirstDay.day}';
  }
  final weekdayString = weekdayToJP(newFirstDay.weekday);
  return '${newFirstDay.year}/$newMonthPop/$newDatePop($weekdayString)';
}

/// //祝日の際のカラー設定
String weekdayToJP(int weekday) {
  if (weekday < 1 && 7 < weekday) {
    throw Exception("曜日コードが不正です");
  }
  return ['月', '火', '水', '木', '金', '土', '日'][weekday - 1];
}

Color dayToColor(DateTime day) {
  final isholiday = holidayJudge(day);
  if (isholiday) {
    return Colors.red;
  }

  final bool isSaturday = day.weekday == 6;
  final bool isSunday = day.weekday == 7;
  if (isSaturday) {
    return Colors.blue;
  }
  if (isSunday) {
    return Colors.red;
  }

  return Colors.black;
}
