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
final datetimeJudgeProvider = StateProvider<DateTime>((ref) => DateTime.now());

final popSelectedStartDateProvider = FutureProvider.family<String, String>(
  (ref, scheStartDate) async {
    DateTime datetimeStart = await DateTime.parse(scheStartDate);
    final scheStartData = await ref.watch(scheStartDataProvider);
    if (scheStartData != '') {
      datetimeStart = await DateTime.parse(scheStartData);
    }
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

    ref.watch(datetimeJudgeProvider.notifier).state =
        DateTime(datetimeStart.year, monthInit, dayInit, hourInit, minuteInit);
    if (ref.watch(switchProvider) == true) {
      datetimeData = '${datetimeStart.year}-$month-$day';
    }
    return datetimeData;
  },
);

final popSelectedEndDateProvider = FutureProvider.family<String, String>(
  (ref, scheEndDate) async {
    DateTime datetimeEnd = await DateTime.parse(scheEndDate);
    final scheEndData = await ref.watch(scheEndDataProvider);
    if (scheEndData != '') {
      datetimeEnd = await DateTime.parse(scheEndData);
    }
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
    ref.watch(datetimeJudgeProvider.notifier).state =
        DateTime(datetimeEnd.year, monthInit, dayInit, hourInit, minuteInit);
    if (ref.watch(switchProvider) == true) {
      datetimeData = '${datetimeEnd.year}-$month-$day';
    }
    return datetimeData;
  },
);

final scheStartDataProvider = StateProvider<String>((ref) => '');
final scheEndDataProvider = StateProvider<String>((ref) => '');
