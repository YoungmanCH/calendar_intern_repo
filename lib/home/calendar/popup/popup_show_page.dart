import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'popup_add_page.dart';
import 'provider/pop_show_provider.dart';
import 'provider/pop_add_provider.dart';
import 'provider/pop_change_provider.dart';
import 'function/show/pop_show_function.dart';
import 'function/show/pop_show_widget.dart';

int getElapsedDays(DateTime date) {
  final baseDate = DateTime(1970, 1, 1);
  //引き算
  // elapsedDays = | selectedDate - baseDate |
  // 2023/10/25 - 1970/01/01 = 19000日
  final elapsedDays = date.difference(baseDate).inDays;
  return elapsedDays;
}

DateTime getDateFromElapsedDays (int elapsedDays) {
  final baseDate = DateTime(1970, 1, 1);
  // resultElapsedDate = baseDate + 16Line of elapsedDays 
  // 2023/10/25 = 1970//01/01 + 19000日 
  final resultElapsedDate = baseDate.add(Duration(days: elapsedDays));
  return resultElapsedDate;
}

Future popupController(BuildContext context, WidgetRef ref) async {
  DateTime catchSchedule = DateTime(
    ref.watch(setYearProvider),
    ref.watch(setMonthProvider),
    ref.watch(setDayProvider),
  );


  //データベースのスケジュール一覧をコンソールに表示
  // database.watchSchedule().listen((data) => debugPrint('watchSchedule: $data'));

  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 700,
        child: PageView.builder(
          controller: ref.watch(pageControllerProvider2(getElapsedDays(catchSchedule))),
          itemBuilder: (context, index) {
            final elapsedDays = getDateFromElapsedDays(index);
            return SuchedulePopup(
              selectedDatetime: elapsedDays,
            );
          },
        ),
      );
    }
  );
}

class SuchedulePopup extends ConsumerWidget {
  const SuchedulePopup({required this.selectedDatetime, super.key});

  final DateTime selectedDatetime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
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
                child: SizedBox(
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
                                newMonthDatePopFunc(selectedDatetime),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: dayToColor(selectedDatetime),
                                ),
                              ),
                            ),
                            CupertinoButton(
                              child: const Icon(Icons.add),
                              onPressed: () async {
                                ref.watch(popSelectedProvider.notifier).state =
                                    selectedDatetime;
                                final now = DateTime.now().hour;
                                ref.watch(
                                        popSelectedStartShowProvider.notifier)
                                    .state = DateTime(
                                  selectedDatetime.year,
                                  selectedDatetime.month,
                                  selectedDatetime.day,
                                  now,
                                );
                                ref
                                    .watch(popSelectedEndShowProvider.notifier)
                                    .state = DateTime(
                                  selectedDatetime.year,
                                  selectedDatetime.month,
                                  selectedDatetime.day,
                                  now + 1,
                                );
                                ref
                                    .watch(scheEndDateChangeShowProvider.notifier)
                                    .state = DateTime(
                                  selectedDatetime.year,
                                  selectedDatetime.month,
                                  selectedDatetime.day,
                                  now + 1,
                                );
                                ref.watch(scheEndDateShowProvider.notifier).state = DateTime(
                                   selectedDatetime.year,
                                  selectedDatetime.month,
                                  selectedDatetime.day,
                                  now + 1,
                                );
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => PopAddScreen(
                                              popSelected: ref
                                                  .watch(popSelectedProvider),
                                            )));

                                final dateOfParseStart = await ref.watch(
                                    popSelectedStartDateProvider(
                                            DateTime.now().toString())
                                        .future);
                                final dateTimeStart =
                                    DateTime.parse(dateOfParseStart);

                                ref
                                    .watch(scheStartDateShowProvider.notifier)
                                    .state = DateTime(
                                  dateTimeStart.year,
                                  dateTimeStart.month,
                                  dateTimeStart.day,
                                  dateTimeStart.hour,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ScheduleList(selectedDatetime),
                      ),
                    ],
                  ),
                ),
                // }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
