import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/pop_change_provider.dart';
import '../../provider/pop_show_provider.dart';
import '../../../../../database/database.dart';

///enddateの値を変更！！
String endDate(DateTime datetimeEnd, bool switchChange) {
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
  if (switchChange == true) {
    datetimeData = '${datetimeEnd.year}-$month-$day';
  }
  return datetimeData;
}
    
Future <void> textSettingFunc(WidgetRef ref, String scheTitle, String scheContent) async{
  final start = ref.watch(scheStartDateChangeShowProvider);
  final end = ref.watch(scheEndDateChangeShowProvider);
  // final TextEditingController titleController = ref.read(titleEditingProvider(scheTitle));
  // final TextEditingController commentController = ref.read(commentEditingProvider(scheContent));
  //   titleController.addListener(() {
  //   ref.watch(appleProvider.notifier).state = true;
  // });
  // commentController.addListener(() {
  //   ref.watch(apple2Provider.notifier).state = true;
  // });

  final id = ref.read(popupChangeValProvider).id;

    final database = ref.read(databaseProvider);
    final schedule = await database.getSchedule(id);
    
    String newStartDay = '';
    String newEndDay = '';
    if (schedule != null) {
      newStartDay = endDate(ref.watch(scheStartDateChangeShowProvider), schedule.judge);
      newEndDay = endDate(ref.watch(scheEndDateChangeShowProvider), schedule.judge);
    }

    // ref.listen<bool>(
    //   switchChangeProvider,
    //   ((preValue, newValue) {
    //     if (preValue != newValue) {
    //       ref.watch(apple3Provider.notifier).state = true;
    //     }
    //   })
    // );

    // ref.listen<DateTime>(
    //   scheStartDateChangeShowProvider,
    //   ((preValue, newValue) {
    //     if (preValue == newValue) {
    //       ref.watch(apple4Provider.notifier).state = false;
    //     } else {
    //       ref.watch(apple4Provider.notifier).state = true;
    //     }
    //   })
    // );

//関数として作るときは、それぞれの関数の役割を分けるべrきである。


  bool startChangedJudge = (newStartDay != schedule?.startDay);
  bool endChangeJudge = (newEndDay != schedule?.endDay);
  bool titleChangeJudge = (ref.read(titleEditingProvider(scheTitle)).text != schedule?.title);
  bool contentChangeJudge = (ref.read(commentEditingProvider(scheContent)).text != schedule?.content);
  bool switchChangedJudge = (ref.watch(switchChangeProvider) != schedule?.judge);

  if(titleChangeJudge || contentChangeJudge|| switchChangedJudge || startChangedJudge || endChangeJudge)  {

  if (ref.watch(titleEditingProvider(scheTitle)).text.isNotEmpty &&
      ref.watch(commentEditingProvider(scheContent)).text.isNotEmpty) {
    if (start.isBefore(end.subtract(const Duration(hours: 1))) ||
        start.isAtSameMomentAs(end.subtract(const Duration(hours: 1)))) {
        ref.watch(conditionJudgeChangeProvider.notifier).state = true;
    } else if (start.isAfter(end)) {
        ref.watch(conditionJudgeChangeProvider.notifier).state = false;
    } else if (ref.watch(switchChangeProvider) == true) {
        ref.watch(conditionJudgeChangeProvider.notifier).state = true;
    } else {
        ref.watch(conditionJudgeChangeProvider.notifier).state = false;
    }
  } else {
      ref.watch(conditionJudgeChangeProvider.notifier).state = false;
  }
  }else {
    ref.watch(conditionJudgeChangeProvider.notifier).state = false;
  }
  if (!ref.watch(switchChangeProvider)) {
    if (ref.watch(scheStartDateChangeShowProvider) == ref.watch(scheEndDateChangeShowProvider)) {
      ref.watch(conditionJudgeChangeProvider.notifier).state = true;
    }
  }

  // titleController.addListener(() {
  //   ref.watch(appleProvider.notifier).state = true;
  // });
  // commentController.addListener(() {
  //   ref.watch(apple2Provider.notifier).state = true;
  // });
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
