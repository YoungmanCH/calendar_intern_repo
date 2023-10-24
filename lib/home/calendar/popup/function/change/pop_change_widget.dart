import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../database/database.dart';
import '../../../../home_page.dart';
import '../../popup_change_page.dart';
import '../../provider/pop_change_provider.dart';
import 'pop_change_function.dart';

void appBarCancelChangeFunc(BuildContext context, WidgetRef ref) {
  showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const HomeScreen(),
                  )),
              child: const Text('編集を破棄'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
        );
      });
}

void startDatePickerChangeFunc(
    BuildContext context,
    WidgetRef ref,
    int index,
    String scheTitle,
    String scheEndDate,
    String scheContent,
    CupertinoDatePickerMode mode) {
  showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: CupertinoButton(
                      child: const Text(
                        'キャンセル',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const PopChangeWidget(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CupertinoButton(
                        child: const Text(
                          '完了',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const PopChangeWidget(),
                            ));
                            DateTime dateTime = ref.watch(scheStartDateChangeShowProvider);
                            if (ref
                                    .watch(scheEndDateChangeShowProvider)
                                    .isBefore(dateTime.subtract(const Duration(hours: 1))) ||
                                ref
                                    .watch(scheEndDateChangeShowProvider)
                                    .isAtSameMomentAs(dateTime.subtract(const Duration(hours: 1)))) {

                              ref.watch(scheEndDateMinimunShowProvider.notifier).state = DateTime(
                                    dateTime.year,
                                    dateTime.month,
                                    dateTime.day,
                                    dateTime.hour + 1,
                                    dateTime.minute);
                              ref.watch(scheEndDateInitialShowProvider.notifier).state = DateTime(
                                    dateTime.year,
                                    dateTime.month,
                                    dateTime.day,
                                    dateTime.hour + 1,
                                    dateTime.minute);
                           }
                            }),
                  ),
                ],
              ),
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  backgroundColor: Colors.white,
                  initialDateTime: ref.watch(scheStartDateChangeShowProvider),
                  minuteInterval: 15,
                  onDateTimeChanged: (DateTime newTime) {
                    newTimeStartChangeFunc(ref, newTime);
                  },
                  use24hFormat: true,
                  mode: mode,
                ),
              ),
            ],
          ),
        );
      });
}

void endDatePickerChangeFunc(
    BuildContext context,
    WidgetRef ref,
    int index,
    String scheTitle,
    String scheEndDate,
    String scheContent,
    CupertinoDatePickerMode mode) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      
      DateTime dateTime = ref.watch(scheStartDateChangeShowProvider);
      if (ref
              .watch(scheEndDateChangeShowProvider)
              .isBefore(dateTime.subtract(const Duration(hours: 1))) ||
          ref
              .watch(scheEndDateChangeShowProvider)
              .isAtSameMomentAs(dateTime.subtract(const Duration(hours: 1)))) {

        ref.watch(scheEndDateMinimunShowProvider.notifier).state = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              dateTime.hour + 1,
              dateTime.minute);
        ref.watch(scheEndDateInitialShowProvider.notifier).state = DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              dateTime.hour + 1,
              dateTime.minute);
      }

      return Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: CupertinoButton(
                    child: const Text(
                      'キャンセル',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const PopChangeWidget(),
                          ));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CupertinoButton(
                    child: const Text(
                      '完了',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const PopChangeWidget(),
                        ),
                      );
                      await ref.read(
                          popSelectedChangeEndDateProvider(scheEndDate).future);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                backgroundColor: Colors.white,
                initialDateTime: ref.watch(scheEndDateInitialShowProvider),
                minimumDate: ref.watch(scheEndDateMinimunShowProvider),
                minuteInterval: 15,
                onDateTimeChanged: (DateTime newTime) {
                  newTimeEndChangeFunc(ref, newTime);
                  ref.watch(scheEndDateChangeShowProvider.notifier).state = newTime;
                },
                use24hFormat: true,
                mode: mode,
              ),
            ),
          ],
        ),
      );
    },
  );
}

void deleteScheduleFunc(BuildContext context, WidgetRef ref) {
  showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
                final database = ref.watch(databaseProvider);
                await database
                    .deleteSchedule(ref.watch(databaseGetDateProvider));
                await database.close();
              },
              child: const Text('編集を破棄'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
        );
      });
}
