import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../popup_change_page.dart';
import '../../../../../database/database.dart';
import '../../provider/pop_show_provider.dart';
import '../../provider/pop_change_provider.dart';
import 'pop_show_function.dart';

Widget buildScheduleList(WidgetRef ref, DateTime firstDateController) {
  if (ref.watch(scheExistJudgeProvider) == true) {
    return FutureBuilder(
      future: scheGetFunc(ref, firstDateController),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        return SingleChildScrollView(
          child: Column(
            children: List.generate(
              ref.watch(scheduleTitleListProvider).length,
              (index) => SizedBox(
                height: 80,
                width: 350,
                child: CupertinoButton(
                  onPressed: () async{
                    final scheduleDataList =  await ref.watch(scheduleListDateProvider(firstDateController).future);
                    final banana = scheduleDataList[index];
                    Future.delayed(Duration.zero, () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => PopChangeScreen(
                          index: banana.id,
                          scheTitle: banana.title,
                          scheEndDate: banana.endDay,
                          scheContent: banana.content,
                        )),
                      );
                      ref.watch(scheStartDataChangeProvider.notifier).state = DateTime.parse(banana.startDay).toString();
                      ref.watch(scheEndDataChangeProvider.notifier).state = DateTime.parse(banana.endDay).toString();
                      // ref.watch(scheStartDateChangeShowProvider.notifier).state = DateTime.parse(banana.startDay);
                      ref.watch(databaseGetDateProvider.notifier).state = banana.date;
                      final fruits = DateTime.parse(banana.startDay);
                      final fruits2 = DateTime.parse(banana.endDay);
                      ref.watch(popSelectedStartShowProvider.notifier).state = DateTime(
                        fruits.year, 
                        fruits.month, 
                        fruits.day,
                        fruits.hour,
                        fruits.minute,
                      );
                      ref.watch(popSelectedEndShowProvider.notifier).state = DateTime(
                        fruits2.year, 
                        fruits2.month, 
                        fruits2.day,
                        fruits2.hour,
                        fruits2.minute,
                      );
                      ref.watch(switchChangeProvider.notifier).state = banana.judge;
                    });
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 70,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: buildTime(
                            ref.watch(scheduleJudgeListProvider)[index],
                            ref.watch(scheduleStartDayListProvider)[index],
                            ref.watch(scheduleEndDayListProvider)[index],
                          ),
                        ),
                      ),
                      Container(
                        width: 4,
                        height: 50,
                        color: Colors.blue,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: SizedBox(
                          width: 200,
                          child: Text(
                            ref.watch(scheduleTitleListProvider)[index],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }else {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text('予定がありません。'),
          ),
        ],
      ),
    );
  }
}


Widget buildTime(bool judge, String start, String end) {
  if(judge == false) {
    DateTime startDateTime = DateTime.parse(start);
    DateTime endDateTime = DateTime.parse(end);
    String startDateTimeStringHour = '';
    String startDateTimeStringMinute = '';
    String endDateTimeStringHour = '';
    String endDateTimeStringMinute = '';

    if (startDateTime.hour < 10) {
      startDateTimeStringHour = '0${startDateTime.hour}';
    } else {
      startDateTimeStringHour = '${startDateTime.hour}';
    }
    if (startDateTime.minute < 10) {
      startDateTimeStringMinute = '0${startDateTime.minute}';
    } else {
      startDateTimeStringMinute = '${startDateTime.minute}';
    }
    if (endDateTime.hour < 10) {
      endDateTimeStringHour = '0${endDateTime.hour}';
    } else {
      endDateTimeStringHour = '${endDateTime.hour}';
    }
    if (endDateTime.minute < 10) {
      endDateTimeStringMinute = '0${endDateTime.minute}';
    } else {
      endDateTimeStringMinute = '${endDateTime.minute}';
    }
    String startTime = '$startDateTimeStringHour:$startDateTimeStringMinute';
    String endTime = '$endDateTimeStringHour:$endDateTimeStringMinute';

    return Column(
      children: [
        Text(startTime),
        Text(endTime),
      ],
    );
  }
  else {
    return const Align(
      alignment: Alignment.center,
      child: Text('終日'),
    );
  }
}

