import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../popup_change_page.dart';
import '../../../../../database/database.dart';
import '../../provider/pop_show_provider.dart';
import '../../provider/pop_change_provider.dart';

class SucheduleItem extends StatelessWidget {
  const SucheduleItem({
    required this.startDay,
    required this.endDay,
    required this.scheduleTitle,
    required this.onPressed,
    required this.isAllday,
    super.key,
  });

  final DateTime startDay;
  final DateTime endDay;
  final String scheduleTitle;

  /// 終日かどうか
  final bool isAllday;

  ///onPressedですら、コールバック関数ですらも継承の引数とすることことが出来る。
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 350,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromARGB(248, 235, 234, 234),
            width: 0.8,
          ),
        ),
      ),
      child: CupertinoButton(
        onPressed: onPressed,
        child: Row(
          children: [
            SizedBox(
              width: 70,
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: buildTime(
                  isAllday,
                  startDay,
                  endDay,
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
                  scheduleTitle,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//あとで書き換える。　(textSettingFunc)
// final scheduleProvider =
//     FutureProvider.family<ScheduleRecord, int>((ref, id) {
//   final db = ref.read(databaseProvider);
//   return db.getSchedule(id);
// });

class ScheduleList extends ConsumerWidget {
  const ScheduleList(this.firstDateController, {super.key});
  final DateTime firstDateController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedlueAsync =
        ref.watch(scheduleFromDatetimeProvider(firstDateController));
    return schedlueAsync.when(
      data: (records) {
        if (records.isEmpty) {
          return Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color.fromARGB(248, 235, 234, 234),
                  width: 1.0,
                ),
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text('予定がありません。'),
                  ),
                ],
              ),
            ),
          );
        }

        //ListViewにはデフォルトで、paddingが自動で設定されていることがある。

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return SucheduleItem(
              startDay: DateTime.parse(record.startDay),
              endDay: DateTime.parse(record.endDay),
              scheduleTitle: record.title,
              isAllday: record.judge,
              onPressed: () async {
                final scheduleDataList = await ref.watch(
                    scheduleListDateProvider(firstDateController).future);
                final banana = scheduleDataList[index];

                //これは、view用であり、コントローラーで使ってはならない。
                final lemon = ref.watch(popupChangeValProvider.notifier);
                lemon.initialize(
                  banana.id,
                  banana.title,
                  banana.endDay,
                  banana.content,
                  banana.judge,
                );

                ref.watch(switchChangeProvider.notifier).state = banana.judge;

                Future.delayed(Duration.zero, () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const PopChangeWidget(),
                    ),
                  );

                  //あとでNotifierに書き換える！！！！！！

                  ref.watch(scheStartDataChangeProvider.notifier).state =
                      DateTime.parse(banana.startDay).toString();
                  ref.watch(scheEndDataChangeProvider.notifier).state =
                      DateTime.parse(banana.endDay).toString();
                  ref.watch(scheStartDateChangeShowProvider.notifier).state =
                      DateTime.parse(banana.startDay);
                  ref.watch(scheEndDateChangeShowProvider.notifier).state =
                      DateTime.parse(banana.endDay);
                  ref.watch(scheEndDateInitialShowProvider.notifier).state =
                      DateTime.parse(banana.endDay);
                  final initTime = DateTime.parse(banana.startDay);
                  if (ref.watch((switchChangeProvider)) == false) {
                    ref.watch(scheEndDateMinimunShowProvider.notifier).state =
                        DateTime(initTime.year, initTime.month, initTime.day,
                            initTime.hour + 1);
                  } else {
                    ref.watch(scheEndDateMinimunShowProvider.notifier).state =
                        DateTime(initTime.year, initTime.month, initTime.day,
                            initTime.hour);
                  }

                  ref.watch(databaseGetDateProvider.notifier).state =
                      banana.date;
                  final fruits = DateTime.parse(banana.startDay);
                  final fruits2 = DateTime.parse(banana.endDay);
                  ref.watch(popSelectedStartShowProvider.notifier).state =
                      DateTime(
                    fruits.year,
                    fruits.month,
                    fruits.day,
                    fruits.hour,
                    fruits.minute,
                  );

                  ref.watch(popSelectedEndShowProvider.notifier).state =
                      DateTime(
                    fruits2.year,
                    fruits2.month,
                    fruits2.day,
                    fruits2.hour,
                    fruits2.minute,
                  );
                });
              },
            );
          },
        );
      },
      error: (_, __) => const SizedBox(),
      loading: () => const SizedBox(),
    );
  }
}

Widget buildTime(bool judge, DateTime startDateTime, DateTime endDateTime) {
  if (judge == false) {
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
        Text(
          startTime, 
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        Text(
          endTime,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );
  } else {
    return const Align(
      alignment: Alignment.center,
      child: Text(
        '終日',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
