import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'popup_add_page.dart';
import 'popup_change_page.dart';
import '../../../database/database.dart';
import 'provider/pop_provider.dart';
import 'provider/pop_add_provider.dart';
import 'provider/pop_change_provider.dart';
import 'function/show/pop_show_function.dart';

// command + . でcontainerなどで要素を囲える。

//ポップアップをページビューリストで管理できるようにしよう！

final queryexecutor = connectionDatabase();
final database = ScheduleDatabase(queryexecutor);

popupController(BuildContext context, WidgetRef ref) async{
  final year = ref.watch(setYearProvider);
  final month = ref.watch(setMonthProvider);
  final day = ref.watch(setDayProvider);
  DateTime catchSchedule = DateTime(year, month, day);
  final selectedDate = ref.watch(scheduleCatchProvider(catchSchedule));
  List scheduleTitleList = ref.watch(scheduleTitleListProvider);
  List scheduleJudgeList = ref.watch(scheduleJudgeListProvider);
  List scheduleStartDayList = ref.watch(scheduleStartDayListProvider);
  List scheduleEndDayList = ref.watch(scheduleEndDayListProvider);


   database.watchSchedule().listen((data) => debugPrint('watchSchedule: $data'));


  Future scheGetFunc(DateTime firstDateController) async {
    ref.watch(scheduleTitleListProvider.notifier).state = await database.getScheduleTitle(firstDateController);
    scheduleTitleList = ref.watch(scheduleTitleListProvider);

    ref.watch(scheduleJudgeListProvider.notifier).state = await database.getScheduleJudge(firstDateController);
    scheduleJudgeList = ref.watch(scheduleJudgeListProvider.notifier).state;

    ref.watch(scheduleStartDayListProvider.notifier).state = await database.getScheduleStartDay(firstDateController);
    scheduleStartDayList = ref.watch(scheduleStartDayListProvider.notifier).state;

    ref.watch(scheduleEndDayListProvider.notifier).state = await database.getScheduleEndDay(firstDateController);
    scheduleEndDayList = ref.watch(scheduleEndDayListProvider.notifier).state;
  }
  
    //Widget関数の代わりにclassで置き換える。
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

    Widget buildScheduleList(DateTime firstDateController) {
      if (ref.watch(scheExistJudgeProvider) == true) {
        return FutureBuilder(
          future: scheGetFunc(firstDateController),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            return SingleChildScrollView(
              child: Column(
                children: List.generate(
                  scheduleTitleList.length,
                  (index) => SizedBox(
                    height: 80,
                    width: 350,
                    child: CupertinoButton(
                      onPressed: () async{
                        final scheduleDataList =  await ref.read(scheduleListDateProvider(firstDateController).future);
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
                          ref.watch(scheStartDateChangeShowProvider.notifier).state = DateTime.parse(banana.startDay);
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
                                scheduleJudgeList[index], 
                                scheduleStartDayList[index], 
                                scheduleEndDayList[index]
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
                                scheduleTitleList[index],
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

    //こっちが大元
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
              bottom: 80,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.0), // 丸角の半径を設定
              child: SizedBox(
                height: 600,
                child: Container(
                  color: CupertinoColors.white,
                  child: CupertinoPopupSurface(
                    child: Center(
                    child: PageView.builder(
                      controller: ref.watch(pageControllerProvider2),
                      itemBuilder: (context, index) {
                        index = index - DateTime.now().month + 1;
                        final DateTime newFirstDay  = selectedDate.add(Duration(days: index));
                        print('newFirstDay: $newFirstDay');
                        scheJudgeFunc(ref, newFirstDay);
                        ref.watch(judgeWeekPopProvider.notifier).state = newFirstDay.weekday;

                      








                        // bool judgeHoliday = ref.watch(holidayJudgeProvider);
                        // //この下のコードは、実行されたりされなかったりするため、不完全である。
                        // //やりたいこと処理は、ポップアップを横移動した際に祝日の場合、テキストカラーを赤色にしたい！

                          //おそらくbuildの問題。関数を作成し呼び出すタイミングがbuildの後ではなく前にしなければならないのかも。

                          //後で、return 文よりも前に以下のコードを書くことで、治るかもしれない。ただ、nwFirstDayhはProviderで管理できるように変更する必要がある。



                    





                        // ref.watch(selectedWeekdayProvider(newFirstDay.weekday));
                        String newMonthPop = '';
                        String newDatePop = '';
                        if (newFirstDay.month < 10) {
                          newMonthPop = '0${newFirstDay.month}';
                        } else {
                          newMonthPop = '${newFirstDay.month}';
                        }
                        if (newFirstDay.day < 10) {
                          newDatePop = '0${newFirstDay.day}';
                        } else {
                          newDatePop = '${newFirstDay.day}';
                        }
                        switchFunc(ref, newFirstDay);

                        return FutureBuilder(
                          future: scheJudgeFunc(ref, newFirstDay),
                          builder: (BuildContext context, snapshot) {
                            return SizedBox(
                              height: 600,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20),
                                          child: Text(
                                            '${newFirstDay.year}/$newMonthPop/$newDatePop(${ref.watch(weekPopProvider)})',
                                            // '${newFirstDay.year}/$newMonthPop/$newDatePop($weekPop)',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: ref.watch(weekColorProvider),
                                              // color: weekColor,
                                            ),
                                          ),
                                        ),
                                        CupertinoButton(
                                          child: const Icon(Icons.add),
                                          onPressed: () async{
                                            ref.watch(popSelectedProvider.notifier).state = newFirstDay;
                                            final now = DateTime.now().hour;
                                            ref.watch(popSelectedStartShowProvider.notifier).state = DateTime(
                                              newFirstDay.year, 
                                              newFirstDay.month, 
                                              newFirstDay.day, 
                                              now,
                                            );
                                            ref.watch(popSelectedEndShowProvider.notifier).state = DateTime(
                                              newFirstDay.year, 
                                              newFirstDay.month, 
                                              newFirstDay.day, 
                                              now+1,
                                            );
                                            Navigator.push(context, CupertinoPageRoute(builder: (context) => PopAddScreen(
                                              popSelected: ref.watch(popSelectedProvider),
                                            )));
                            
                                            final dateOfParseStart = await ref.watch(popSelectedStartDateProvider(DateTime.now().toString()).future);
                                            final dateOfParseEnd = await ref.watch(popSelectedEndDateProvider(DateTime.now().toString()).future);
                                            final dateTimeStart = DateTime.parse(dateOfParseStart);
                                            final dateTimeEnd = DateTime.parse(dateOfParseEnd);
                                            ref.watch(scheStartDateShowProvider.notifier).state = DateTime(
                                              dateTimeStart.year, 
                                              dateTimeStart.month, 
                                              dateTimeStart.day, 
                                              dateTimeStart.hour,
                                            );
                                            ref.watch(scheEndDateShowProvider.notifier).state = DateTime(
                                              dateTimeEnd.year, 
                                              dateTimeEnd.month, 
                                              dateTimeEnd.day, 
                                              dateTimeEnd.hour+1,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),  
                                  Expanded(
                                    child: buildScheduleList(newFirstDay),
                                  ),
                                ],
                              ),
                            );
                          }
                        );
                      }
                    ),
                    ),
                  ),
                ),
              ),
            ),
        );
      },
    );
  }