import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/database.dart';

final scheTitleListProvider =
    FutureProvider.family<List, DateTime>((ref, firstDate) async {
  final database = ref.watch(databaseProvider);
  final List scheTitleList = await database.getScheduleTitle(firstDate);
  return scheTitleList;
});

final titleEditingProvider =
    Provider.family<TextEditingController, String>((ref, scheTitle) {
  return TextEditingController(text: scheTitle);
});
final commentEditingProvider =
    Provider.family<TextEditingController, String>((ref, scheContent) {
  return TextEditingController(text: scheContent);
});

final switchChangeProvider = StateProvider<bool>((ref) => false);
final conditionJudgeChangeProvider = StateProvider<bool>((ref) => false);

final popSelectedChangeStartDateProvider =
    FutureProvider.family<String, String>((ref, scheStartDate) async {
  DateTime datetimeStart = DateTime.parse(scheStartDate);
  final scheStartData = ref.watch(scheStartDataChangeProvider);
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
  String datetimeData =
      '${datetimeStart.year}-$month-$day $hour:$minute';

  ref.watch(dateTimeJudgeChangeProvider.notifier).updateDateTime(
    yearInit, 
    monthInit,
    dayInit,
    hourInit,
    minuteInit,
  );  
  if (ref.watch(switchChangeProvider) == true) {
    datetimeData = '${datetimeStart.year}-$month-$day';
  }

  // ref.invalidate(); //FutureProviderの値を更新する際に使用される。
  // datetimeJudge = DateTime(datetimeStart.year, monthInit, dayInit, hourInit, minuteInit);

  return datetimeData;
});

final popSelectedChangeEndDateProvider =
    FutureProvider.family<String, String>((ref, scheEndDate) async {
  DateTime datetimeEnd = DateTime.parse(scheEndDate);
  final scheEndData = ref.watch(scheEndDataChangeProvider);
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
    ref.watch(dateTimeJudgeChangeProvider.notifier).updateDateTime(
    yearInit, 
    monthInit,
    dayInit,
    hourInit,
    minuteInit,
  ); 
  if (ref.watch(switchChangeProvider) == true) {
    datetimeData = '${datetimeEnd.year}-$month-$day';
  }
  return datetimeData;
});

final scheStartDataChangeProvider = StateProvider<String>((ref) => '');
final scheEndDataChangeProvider = StateProvider<String>((ref) => '');

final dateTimeJudgeChangeProvider = NotifierProvider<DateTimeJudgeChangeNotifier, DateTime>(DateTimeJudgeChangeNotifier.new);
class DateTimeJudgeChangeNotifier extends Notifier <DateTime>{

  @override
  DateTime build() {
    return DateTime.now();
  }

  updateDateTime(int year, int month, int day, int hour, int minute) {
    // state = DateTime(year, month, day, hour, minute);
    return DateTime(year, month, day, hour, minute);
  }
}