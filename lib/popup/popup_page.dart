import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'popup_add_page.dart';
import 'popup_change_page.dart';
import '../database/database.dart';
import 'provider/pop_provider.dart';
import 'provider/pop_add_provider.dart';

// command + . でcontainerなどで要素を囲える。

final queryexecutor = connectionDatabase();
final database = ScheduleDatabase(queryexecutor);

class PopupScreen extends ConsumerWidget {
  final DateTime selectedDate;

  const PopupScreen({
    Key? key,
    required this.selectedDate, 
  }) : super(key: key);

  popupFunction(BuildContext context, WidgetRef ref) async{

    String weekPop = '';
    Color weekColor = Colors.black;
    int judgeWeekPop = selectedDate.weekday;

    bool scheExistJudge = false;
    List scheduleTitleList = ref.watch(scheduleTitleListProvider);
    List scheduleJudgeList = ref.watch(scheduleJudgeListProvider);
    List scheduleStartDayList = ref.watch(scheduleStartDayListProvider);
    List scheduleEndDayList = ref.watch(scheduleEndDayListProvider);

    scheJudgeFunc(DateTime firstDateController) async{
      await database.getSchedule().then((data){
        final dates = data.map((record) => record.date).toList();                  
        if (dates.contains(firstDateController)) {
          ref.read(scheExistJudgeProvider.notifier).state = true;
          scheExistJudge = ref.watch(scheExistJudgeProvider);
        }else {
          ref.read(scheExistJudgeProvider.notifier).state = false;
          scheExistJudge = ref.watch(scheExistJudgeProvider);
        }
      });
    }
    
    //祝日の際にカラー変更は未設定なので、後でやりましょう。
    void switchFunc() {

      switch (judgeWeekPop){
        case 1:
          weekPop = '月';
          weekColor = Colors.black;
          break;
        case 2:
          weekPop = '火';
          weekColor = Colors.black;
          break;
        case 3:
          weekPop = '水';
          weekColor = Colors.black;
          break;
        case 4:
          weekPop = '木';
          weekColor = Colors.black;
          break;
        case 5:
          weekPop = '金';
          weekColor = Colors.black;
          break;
        case 6:
          weekPop = '土';
          weekColor = Colors.blue;
          break;
        case 7:
          weekPop = '日';
          weekColor = Colors.red;
          break;
        default: 
          debugPrint('error about firstDay');
          break;
      }
    }
    switchFunc();

    Future scheGetFunc(DateTime firstDateController) async {
      ref.read(scheduleTitleListProvider.notifier).state = await database.getScheduleTitle(firstDateController);
      scheduleTitleList = ref.read(scheduleTitleListProvider);

      ref.read(scheduleJudgeListProvider.notifier).state = await database.getScheduleJudge(firstDateController);
      scheduleJudgeList = ref.read(scheduleJudgeListProvider.notifier).state;


      ref.read(scheduleStartDayListProvider.notifier).state = await database.getScheduleStartDay(firstDateController);
      scheduleStartDayList = ref.read(scheduleStartDayListProvider.notifier).state;


      ref.read(scheduleEndDayListProvider.notifier).state = await database.getScheduleEndDay(firstDateController);
      scheduleEndDayList = ref.read(scheduleEndDayListProvider.notifier).state;
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

    Widget buildScheduleList(DateTime firstDateController) {
      if (scheExistJudge == true) {
        return FutureBuilder(
          future: scheGetFunc(firstDateController),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            return SingleChildScrollView(
              child: Column(
                children: List.generate(
                  scheduleTitleList.length,
                  (index) => SizedBox(
                    height: 80,
                    child: CupertinoButton(
                      onPressed: () async{
                        final scheduleDataList =  await ref.read(scheduleListDateProvider(firstDateController).future);
                        final banana = scheduleDataList[index];
                        Future.delayed(Duration.zero, () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(builder: (context) => PopChangeScreen(
                              index: banana.id,
                              firstDate: firstDateController,
                              scheTitle: banana.title,
                              scheJudge: banana.judge,
                              scheStartDate: banana.startDay,
                              scheEndDate: banana.endDay,
                              scheContent: banana.content,
                            )),
                          );
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
                            child: Text(scheduleTitleList[index]),
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
                      itemBuilder: (context, index){
                        index = index - DateTime.now().month + 1;
                        final DateTime newFirstDay  = selectedDate.add(Duration(days: index));
                        scheJudgeFunc(newFirstDay);
                        ref.watch(selectedWeekdayProvider(newFirstDay.weekday));
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
                        switchFunc();

                        return FutureBuilder(
                          future: scheJudgeFunc(newFirstDay),
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
                                            '${newFirstDay.year}/$newMonthPop/$newDatePop($weekPop)',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: weekColor,
                                            ),
                                          ),
                                        ),
                                        CupertinoButton(
                                          child: const Icon(Icons.add),
                                          onPressed: () async{
                                            ref.read(popSelectedProvider.notifier).state = newFirstDay;
                                            final now = DateTime.now().hour;
                                            ref.watch(popSelectedStartShowProvider.notifier).state = DateTime(
                                              newFirstDay.year, 
                                              newFirstDay.month, 
                                              newFirstDay.day, 
                                              now
                                            );
                                            ref.watch(popSelectedEndShowProvider.notifier).state = DateTime(
                                              newFirstDay.year, 
                                              newFirstDay.month, 
                                              newFirstDay.day, 
                                              now+1
                                            );
                                            Navigator.push(context, CupertinoPageRoute(builder: (context) => PopAddScreen(
                                              popSelected: ref.read(popSelectedProvider),
                                            )));
                            
                                            final dateOfParse = await ref.watch(popSelectedEndDateProvider(DateTime.now().toString()).future);
                                            final dateTime = DateTime.parse(dateOfParse);
                                            ref.watch(scheStartDateShowProvider.notifier).state = DateTime(
                                              dateTime.year, 
                                              dateTime.month, 
                                              dateTime.day, 
                                              dateTime.hour+1
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),  
                                  Expanded(
                                    child: buildScheduleList(newFirstDay),
                                  ),
                                  // if(scheExistJudge == true)
                                  //   buildScheduleList(newFirstDay),
                                  // if(scheExistJudge == false) 
                                  //   Expanded(
                                  //     child: buildScheduleList(newFirstDay),
                                  //   ),
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

  @override
  Widget build (BuildContext context, WidgetRef ref) {

    return CupertinoApp(
      home: CupertinoPageScaffold(
        child: Center(
          child: CupertinoButton(
            child: const Text('Text'),
            onPressed: () {
              debugPrint('おまけ');
            },
          ),
        ),
      ),
    );
  }
}