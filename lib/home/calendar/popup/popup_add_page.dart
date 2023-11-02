import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home_page.dart';
import '../../../database/database.dart';
import 'provider/pop_show_provider.dart';
import 'provider/pop_add_provider.dart';
import 'function/add/pop_add_function.dart';
import 'function/add/pop_add_widget.dart';

//現在の問題は、ロールリストが日本語表記になっていない点である。

//pop_add_page.dart
// ConsumerStatefulWidget     //class PopAddPage
// ConsumerState              //class PopAddState

class PopAddScreen extends ConsumerWidget {
  final DateTime popSelected;

  const PopAddScreen({
    Key? key,
    required this.popSelected
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future(() {
      textSettingFunc(ref, '', ''); 
    });
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.dateAndTime;      
    if(ref.watch(switchProvider) == false) {
      mode = CupertinoDatePickerMode.dateAndTime;      
    }else {
      mode = CupertinoDatePickerMode.date;      
    }

    return MaterialApp(
      home: Scaffold(
        appBar: CupertinoNavigationBar(
          backgroundColor: Colors.blue,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: CupertinoButton(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: const Icon(CupertinoIcons.clear, color: Colors.white,),
                  onPressed: () => appBarCancelFunc(context, ref),
                ),
              ),
              const SizedBox(
                child: Text(
                  '予定の追加', 
                  style: TextStyle(
                    color: Colors.white,
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 5),
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  color: Colors.white,
                  disabledColor: const Color.fromARGB(248, 217, 215, 215),    
                  onPressed: ref.watch(conditionJudgeProvider) == false ? null : () async{
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => const HomeScreen()));
                    final dateSche = DateTime.parse(await ref.watch(popSelectedStartDateProvider(popSelected.toString()).future));
                    DateTime datetimeJudgement = DateTime(dateSche.year, dateSche.month, dateSche.day);
                    final database = ref.read(databaseProvider);
                    await database.addSchedule(
                      ref.watch(titleAddProvider('')).text,
                      await ref.watch(popSelectedStartDateProvider(ref.watch(scheStartDateShowProvider).toString()).future), 
                      await ref.watch(popSelectedEndDateProvider(ref.watch(scheEndDateShowProvider).toString()).future), 
                      ref.watch(commentAddProvider('')).text,
                      datetimeJudgement,
                      ref.watch(switchProvider),
                    );
                    ref.invalidate(scheduleFromDatetimeProvider);
                    ref.read(scheStartDataProvider.notifier).state = '';
                    ref.read(scheEndDataProvider.notifier).state = '';
                    ref.read(scheStartDateShowProvider.notifier).state = DateTime.now();
                    ref.read(scheEndDateShowProvider.notifier).state = DateTime.now();
                    ref.read(titleAddProvider('')).clear();
                    ref.read(commentAddProvider('')).clear();
                    ref.read(switchProvider.notifier).state = false;
                  },
                  child: const Text(
                    '保存', 
                    style: TextStyle( 
                      color:  Colors.black,
                      fontSize: 12,
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Localizations.override(
            context: context,
            locale: const Locale('ja'),
            child: Center(
              child: Container(
                color: const Color.fromARGB(248, 235, 234, 234),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: 400,
                        height: 60,
                        child: CupertinoTextField(
                          placeholder: 'タイトルを入力してください',
                          controller: ref.watch(titleAddProvider('')),
                          autofocus: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, right: 10, left: 10),
                      child: Container(
                        width: 600,
                        height: 180,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromARGB(248, 235, 234, 234),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: SizedBox(
                                height: 55,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        '終日',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Switch(
                                      value: ref.watch(switchProvider),
                                      onChanged: (value) {
                                        ref.watch(switchProvider.notifier).state = value;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color.fromARGB(248, 235, 234, 234),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: CupertinoButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '開始',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        )
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15),
                                        child: FutureBuilder(
                                          future: getStartTimeScheFunc(ref),
                                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            if (snapshot.hasData) {
                                              Future.delayed(Duration.zero, () {
                                                ref.watch(scheStartDateShowProvider.notifier).state = DateTime.parse(snapshot.data);
                                              });
                                            }
                                            return Text(snapshot.data.toString());
                                          }
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () => startDatePickerFunc(context, ref, popSelected, mode),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: CupertinoButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '終了',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      )
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      //ref.watch(scheEndDateShowProvider.select((date) これによって、scheEndSelaftedShowProviderの値を引数によって受け渡すことができる。
                                      child: Text(ref.watch(scheEndDateShowProvider.select((date) {
                                          var year = date.year.toString();
                                          var month = date.month.toString();
                                          var day = date.day.toString();
                                          var hour = date.hour.toString();
                                          var minute = date.minute.toString();
                                            if (date.month < 10) {
                                              month = '0$month';
                                            }
                                            if (date.day < 10) {
                                              day = '0$day';
                                            }
                                            if (date.hour < 10) {
                                              hour = '0$hour';
                                            }
                                            if (date.minute < 10) {
                                              minute = '0$minute';
                                            }
                                            if (ref.watch(switchProvider)) {
                                              return '$year-$month-$day';
                                           }
                                          final datetimeData = '${date.year}-$month-$day $hour:$minute';
                                          return datetimeData;
                                      }))),
                                    ),
                                  ],
                                ),
                                onPressed: () => endDatePickerFunc(context, ref, popSelected, mode),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        color: Colors.white,
                        width: 400,
                        height: 160,
                        child: CupertinoTextField(
                          placeholder: 'コメントを入力してください',
                          maxLines: 6,
                          controller: ref.read(commentAddProvider('')),
                        ),
                      ),
                    ),
                  ],
                ),     
              ),
            ),
          ),
        ),
      ),
    );
  }
}