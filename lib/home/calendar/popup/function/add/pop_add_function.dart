import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/pop_add_provider.dart';
import '../../provider/pop_show_provider.dart';

void textSettingFunc(WidgetRef ref, String scheTitle, String scheComment) {
  final start = ref.watch(scheStartDateShowProvider);
  final end = ref.watch(scheEndDateShowProvider);
  if (ref.watch(titleAddProvider(scheTitle)).text.isNotEmpty &&
      ref.watch(commentAddProvider(scheComment)).text.isNotEmpty) {
    if (start.isBefore(end.subtract(const Duration(hours: 1))) ||
        start.isAtSameMomentAs(end.subtract(const Duration(hours: 1)))) {
      Future(() {
        ref.watch(conditionJudgeProvider.notifier).state = true;
      });
    } else if (start.isAfter(end)) {
      Future(() {
        ref.watch(conditionJudgeProvider.notifier).state = false;
      });
    } else if (ref.watch(switchProvider) == true) {
      Future(() {
        ref.watch(conditionJudgeProvider.notifier).state = true;
      });
    } else {
      Future(() {
        ref.watch(conditionJudgeProvider.notifier).state = false;
      });
    }
  } else {
    Future(() {
      ref.watch(conditionJudgeProvider.notifier).state = false;
    });
  }
}

Future<String> getStartTimeScheFunc(WidgetRef ref) async {
  final startDate = ref.watch(popSelectedStartShowProvider);
  return await ref
      .watch(popSelectedStartDateProvider(startDate.toString()).future);
}

Future<String> getEndTimeScheFunc(WidgetRef ref) async {
  final endDate = ref.watch(popSelectedEndShowProvider);
  return await ref.watch(popSelectedEndDateProvider(endDate.toString()).future);
}

void newTimeStartFunc(WidgetRef ref, DateTime newTime) {
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
  ref.watch(scheStartDataProvider.notifier).state =
      '${newTime.year}-$month-$day $hour:$minute';
}

void newTimeEndFunc(WidgetRef ref, DateTime newTime) {
  String month = newTime.month.toString();
  String day = newTime.day.toString();
  String hour = (newTime.hour).toString();
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
  ref.watch(scheEndDataProvider.notifier).state =
      '${newTime.year}-$month-$day $hour:$minute';
}
