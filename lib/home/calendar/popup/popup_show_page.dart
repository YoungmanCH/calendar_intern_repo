import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'popup_add_page.dart';
import 'provider/pop_show_provider.dart';
import 'provider/pop_add_provider.dart';
import 'function/show/pop_show_function.dart';
import 'function/show/pop_show_widget.dart';

Future popupController(BuildContext context, WidgetRef ref) async{
  DateTime catchSchedule = DateTime(
    ref.watch(setYearProvider),
    ref.watch(setMonthProvider),
    ref.watch(setDayProvider),
  );
  final selectedDate = ref.watch(scheduleCatchProvider(catchSchedule));
  
  //データベースのスケジュール一覧をコンソールに表示
  // database.watchSchedule().listen((data) => debugPrint('watchSchedule: $data'));

  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 700,
        child: PageView.builder(
          controller: ref.watch(pageControllerProvider2),
          itemBuilder: (context, index) {
            index = index - DateTime.now().month + 1;
            final DateTime newFirstDay  = selectedDate.add(Duration(days: index));
            Future(() {
              ref.watch(judgeWeekPopProvider.notifier).state = newFirstDay.weekday;
              scheJudgeFunc(ref, newFirstDay);
              switchFunc(ref, newFirstDay);
            });
            String newMonthPop = '';
            String newDatePop = '';
            return Padding(
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
                bottom: 80,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: SizedBox(
                  height: 700,
                  child: Container(
                    color: CupertinoColors.white,
                    child: CupertinoPopupSurface(
                      child: Center(
                        child: FutureBuilder(
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
                                            newMonthDatePopFunc(ref, newMonthPop, newDatePop, newFirstDay),
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: ref.watch(weekColorProvider),
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
                                    child: buildScheduleList(ref, newFirstDay),
                                  ),
                                ],
                              ),
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
        ),
      );
    }
  );
}