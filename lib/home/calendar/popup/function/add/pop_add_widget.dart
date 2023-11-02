import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../home_page.dart';
import '../../popup_add_page.dart';
import '../../provider/pop_add_provider.dart';
import 'pop_add_function.dart';

void appBarCancelFunc(BuildContext context, WidgetRef ref) {
  showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
                ref.read(scheStartDataProvider.notifier).state = '';
                ref.read(scheEndDataProvider.notifier).state = '';
                ref.read(titleAddProvider('')).clear();
                ref.read(commentAddProvider('')).clear();
                ref.read(switchProvider.notifier).state = false;
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

void startDatePickerFunc(BuildContext context, WidgetRef ref,
    DateTime popSelected, CupertinoDatePickerMode mode) {
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
                      onPressed: () {
                        Navigator.pop(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => PopAddScreen(popSelected: popSelected),
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
                      onPressed: () {
                        Navigator.pop(
                          context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  PopAddScreen(popSelected: popSelected),
                            )
                        );
                      }
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 200,
                child: FutureBuilder(
                  future: ref.watch(
                      popSelectedStartDateProvider(popSelected.toString())
                          .future),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return CupertinoDatePicker(
                      backgroundColor: Colors.white,
                      initialDateTime: ref.watch(scheStartDateShowProvider),
                      minuteInterval: 15,
                      onDateTimeChanged: (DateTime newTime) {
                        newTimeStartFunc(ref, newTime);
                      },
                      use24hFormat: true,
                      mode: mode,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      });
}

void endDatePickerFunc(BuildContext context, WidgetRef ref,
    DateTime popSelected, CupertinoDatePickerMode mode) {
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
                        onPressed: () {
                          Navigator.pop(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    PopAddScreen(popSelected: popSelected),
                              ));
                        }),
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
                                builder: (context) =>
                                    PopAddScreen(popSelected: popSelected),
                              ));
                          await ref.watch(
                              popSelectedEndDateProvider(popSelected.toString())
                                  .future);
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: 200,
                child: FutureBuilder(
                    future: getEndTimeScheFunc(ref),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      DateTime dateTime = ref.watch(scheStartDateShowProvider);
                      if (ref.watch(scheEndDateShowProvider).isBefore(DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          dateTime.hour + 1,
                          dateTime.minute))) {
                        ref.watch(scheEndDateShowProvider.notifier).state =
                            DateTime(
                                dateTime.year,
                                dateTime.month,
                                dateTime.day,
                                dateTime.hour + 1,
                                dateTime.minute);
                      }
                      return CupertinoDatePicker(
                        backgroundColor: Colors.white,
                        initialDateTime: ref.watch(scheEndDateShowProvider),
                        minuteInterval: 15,
                        minimumDate: DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          dateTime.hour + 1,
                          dateTime.minute,
                        ),
                        onDateTimeChanged: (DateTime newTime) async {
                          newTimeEndFunc(ref, newTime);
                        },
                        use24hFormat: true,
                        mode: mode,
                      );
                    }),
              ),
            ],
          ),
        );
      });
}
