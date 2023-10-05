import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/pop_change_provider.dart';
import '../../provider/pop_show_provider.dart';

void textSettingFunc(WidgetRef ref, String scheTitle, String scheContent) {
  final start = ref.watch(scheStartDateChangeShowProvider);
  final end = ref.watch(scheEndDateChangeShowProvider);
  if (ref.watch(titleEditingProvider(scheTitle)).text.isNotEmpty &&
      ref.watch(commentEditingProvider(scheContent)).text.isNotEmpty) {
    if (start.isBefore(end.subtract(const Duration(hours: 1))) ||
        start.isAtSameMomentAs(end.subtract(const Duration(hours: 1)))) {
      Future(() {
        ref.watch(conditionJudgeChangeProvider.notifier).state = true;
      });
    } else if (start.isAfter(end)) {
      Future(() {
        ref.watch(conditionJudgeChangeProvider.notifier).state = false;
      });
    } else if (ref.watch(switchChangeProvider) == true) {
      Future(() {
        ref.watch(conditionJudgeChangeProvider.notifier).state = true;
      });
    } else {
      Future(() {
        ref.watch(conditionJudgeChangeProvider.notifier).state = false;
      });
    }
  } else {
    Future(() {
      ref.watch(conditionJudgeChangeProvider.notifier).state = false;
    });
  }
}

Future<String> getStartTimeScheFunc(WidgetRef ref) async {
  final startDate = ref.watch(popSelectedStartShowProvider);
  return await ref
      .watch(popSelectedChangeStartDateProvider(startDate.toString()).future);
}

Future<String> getEndTimeScheFunc(WidgetRef ref) async {
  final popSelected = ref.watch(popSelectedEndShowProvider);
  return await ref
      .watch(popSelectedChangeEndDateProvider(popSelected.toString()).future);
}

void newTimeStartChangeFunc(WidgetRef ref, DateTime newTime) {
  String month = newTime.month.toString();
  String day = newTime.day.toString();
  String hour = newTime.hour.toString();
  String minute = newTime.minute.toString();
  if (newTime.month < 10) {
    month = '0$month';
  }
  if (newTime.day < 10) {
    day = '0$day';
  }
  if (newTime.hour < 10) {
    hour = '0$hour';
  }
  if (newTime.minute < 10) {
    minute = '0$minute';
  }
  ref.read(scheStartDataChangeProvider.notifier).state =
      '${newTime.year}-$month-$day $hour:$minute';
}

void newTimeEndChangeFunc(WidgetRef ref, DateTime newTime) {
  String month = newTime.month.toString();
  String day = newTime.day.toString();
  String hour = newTime.hour.toString();
  String minute = newTime.minute.toString();
  if (newTime.month < 10) {
    month = '0$month';
  }
  if (newTime.day < 10) {
    day = '0$day';
  }
  if (newTime.hour < 10) {
    hour = '0$hour';
  }
  if (newTime.minute < 10) {
    minute = '0$minute';
  }
  ref.watch(scheEndDataChangeProvider.notifier).state =
      '${newTime.year}-$month-$day $hour:$minute';
}
