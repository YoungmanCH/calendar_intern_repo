import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final switchProvider = StateProvider<bool>((ref) => false);
final titleAddProvider =
    Provider.family<TextEditingController, String>((ref, scheTitle) {
  return TextEditingController(text: scheTitle);
});
final commentAddProvider =
    Provider.family<TextEditingController, String>((ref, scheContent) {
  return TextEditingController(text: scheContent);
});
final conditionJudgeProvider = StateProvider<bool>((ref) => false);

final popSelectedStartDateProvider = FutureProvider.family<String, String>(
  (ref, scheStartDate) async {
    DateTime datetimeStart = DateTime.parse(scheStartDate);
    final scheStartData = ref.watch(scheStartDataProvider);
    if (scheStartData != '') {
      datetimeStart = DateTime.parse(scheStartData);
    }
    int yearInit = datetimeStart.year;
    int monthInit = datetimeStart.month;
    int dayInit = datetimeStart.day;
    int hourInit = datetimeStart.hour;
    int minuteInit = datetimeStart.minute;
    String month = datetimeStart.month.toString();
    String day = datetimeStart.day.toString();
    String hour = datetimeStart.hour.toString();
    String minute = datetimeStart.minute.toString();
    if (datetimeStart.month < 10) {
      month = '0$monthInit';
    }
    if (datetimeStart.day < 10) {
      day = '0$dayInit';
    }
    if (datetimeStart.hour < 10) {
      hour = '0$hourInit';
    }
    if (datetimeStart.minute < 10) {
      minute = '0$minuteInit';
    }

    String datetimeData = '${datetimeStart.year}-$month-$day $hour:$minute';

    ref.watch(dateTimeJudgeProvider.notifier).updateDateTime(
          yearInit,
          monthInit,
          dayInit,
          hourInit,
          minuteInit,
        );

    if (ref.watch(switchProvider) == true) {
      datetimeData = '${datetimeStart.year}-$month-$day';
    }
    return datetimeData;
  },
);

final popSelectedEndDateProvider = FutureProvider.family<String, String>(
  (ref, scheEndDate) async {
    DateTime datetimeEnd = DateTime.parse(scheEndDate);
    final scheEndData = ref.watch(scheEndDataProvider);
    if (scheEndData != '') {
      datetimeEnd = DateTime.parse(scheEndData);
    }
    int yearInit = datetimeEnd.year;
    int monthInit = datetimeEnd.month;
    int dayInit = datetimeEnd.day;
    int hourInit = datetimeEnd.hour;
    int minuteInit = datetimeEnd.minute;
    String month = datetimeEnd.month.toString();
    String day = datetimeEnd.day.toString();
    String hour = datetimeEnd.hour.toString();
    String minute = datetimeEnd.minute.toString();
    if (datetimeEnd.month < 10) {
      month = '0$monthInit';
    }
    if (datetimeEnd.day < 10) {
      day = '0$dayInit';
    }
    if (datetimeEnd.hour < 10) {
      hour = '0$hourInit';
    }
    if (datetimeEnd.minute < 10) {
      minute = '0$minuteInit';
    }
    String datetimeData = '${datetimeEnd.year}-$month-$day $hour:$minute';
    ref.watch(dateTimeJudgeProvider.notifier).updateDateTime2(
          yearInit,
          monthInit,
          dayInit,
          hourInit,
          minuteInit,
        );
    if (ref.watch(switchProvider) == true) {
      datetimeData = '${datetimeEnd.year}-$month-$day';
    }
    return datetimeData;
  },
);

final scheStartDataProvider = StateProvider<String>((ref) => '');
final scheStartDateShowProvider =
    StateProvider<DateTime>((ref) => DateTime.now());
final scheEndDateShowProvider =
    StateProvider<DateTime>((ref) => DateTime.now());
final scheEndDataProvider = StateProvider<String>((ref) => '');

final dateTimeJudgeProvider = NotifierProvider<DateTimeJudgeNotifier, DateTime>(
    DateTimeJudgeNotifier.new);

class DateTimeJudgeNotifier extends Notifier<DateTime> {
  //build() コードが初期化コードである。
  @override
  DateTime build() {
    return DateTime.now();
  }

  updateDateTime(int year, int month, int day, int hour, int minute) {
    // state = DateTime(year, month, day, hour, minute);
    return DateTime(year, month, day, hour, minute);
  }

  updateDateTime2(int year, int month, int day, int hour, int minute) {
    // state = DateTime(year, month, day, hour, minute);
    return DateTime(year, month, day, hour, minute);
  }
}
