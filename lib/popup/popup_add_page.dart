import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home/home_page.dart';
import '../database/database.dart';
import 'provider/pop_add_provider.dart';
import 'function/pop_add_function.dart';

class PopAddScreen extends ConsumerWidget {
  final DateTime popSelected;

  PopAddScreen({required this.popSelected});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool switchJudge = ref.watch(switchProvider);
    bool conditionJudge = ref.watch(conditionJudgeProvider);
    
    textSettingFunc(ref, '', ''); 

    return MaterialApp(
      home: Scaffold(
        appBar: CupertinoNavigationBar(
          backgroundColor: Colors.blue,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: CupertinoButton(
                  child: Icon(CupertinoIcons.clear, color: Colors.white,),
                  padding: EdgeInsets.only(bottom: 0),
                  onPressed: () => {
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
                                    builder: (context) => HomeScreen(),
                                  ),
                                );
                                ref.read(scheStartDataProvider.notifier).state = '';
                                ref.read(scheEndDataProvider.notifier).state = '';
                                ref.read(titleAddProvider('')).clear();
                                ref.read(commentAddProvider('')).clear();
                                ref.read(switchProvider.notifier).state = false;
                              },
                              child: Text('編集を破棄'),
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () => Navigator.pop(context),
                              child: Text('キャンセル'),
                            ),
                          ],
                        );
                      }
                    ),
                  }
                ),
              ),
              Container(
                child: Text('予定の追加', style: TextStyle(color: Colors.white,)),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(right: 10, bottom: 5),
                  child: CupertinoButton(
                    child: Text('保存', style: TextStyle(color: Colors.grey, fontSize: 12,)),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    color: Colors.white,
                    onPressed: conditionJudge == false ? null : () async{
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => HomeScreen()));
                      final dataSche = await ref.read(datetimeJudgeProvider);
                      DateTime datetimeJudgement = DateTime(dataSche.year, dataSche.month, dataSche.day);
                      print('datetimeJudgement: ${datetimeJudgement}');  

                      final database = ref.read(databaseProvider);
                      await database.addSchedule(
                        ref.read(titleAddProvider('')).text,
                        await ref.read(popSelectedStartDateProvider(popSelected.toString()).future), 
                        await ref.read(popSelectedEndDateProvider(popSelected.toString()).future), 
                        ref.read(commentAddProvider('')).text,
                        datetimeJudgement, 
                        ref.read(switchProvider.notifier).state
                      );
                      database.watchSchedule().listen((data) => print('watchSchedule: ${data}'));
                      ref.read(scheStartDataProvider.notifier).state = '';
                      ref.read(scheEndDataProvider.notifier).state = '';
                      ref.read(titleAddProvider('')).clear();
                      ref.read(commentAddProvider('')).clear();
                      ref.read(switchProvider.notifier).state = false;
                    },
                    disabledColor: Colors.grey,       
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: Container(
            color: const Color.fromARGB(248, 235, 234, 234),
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Container(
                      width: 400,
                      height: 60,
                      child: CupertinoTextField(
                        placeholder: 'タイトルを入力してください',
                        controller: ref.read(titleAddProvider('')),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40, right: 10, left: 10),
                    child: Container(
                      width: 600,
                      height: 180,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Container(
                                      child: Text(
                                        '終日',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Switch(
                                    value: switchJudge,
                                    onChanged: (value) {
                                      switchJudge = value;
                                      ref.read(switchProvider.notifier).state = switchJudge;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CupertinoButton(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Container(
                                      child: Text(
                                        '開始',
                                        style: TextStyle(color: Colors.black,)
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: FutureBuilder(
                                        future: getStartTimeScheFunc(ref),
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                          return Text(snapshot.data.toString());
                                        }
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                     child: Container(
                                      height: 300,
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(left: 10),
                                                    child:  CupertinoButton(
                                                      child: Text(
                                                        'キャンセル',
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context, CupertinoPageRoute(
                                                          builder: (context) => PopAddScreen(popSelected: popSelected),
                                                        ));
                                                      }
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(right: 10),
                                                    child: CupertinoButton(
                                                      child: Text(
                                                        '完了',
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context, CupertinoPageRoute(
                                                          builder: (context) => PopAddScreen(popSelected: popSelected),
                                                        ));
                                                        ref.read(popSelectedStartDateProvider(popSelected.toString()).future);
                                                      }
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 200,
                                            child: FutureBuilder(
                                              future: ref.watch(popSelectedStartDateProvider(popSelected.toString()).future),
                                              // future: getStartTimeScheFunc(ref),
                                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                DateTime initTime = DateTime.now();
                                                if(snapshot.hasData) {
                                                  initTime = DateTime.parse(snapshot.data);
                                                  print('initTime: ${initTime}');
                                                }else {
                                                  initTime = popSelected;
                                                }
                                                return CupertinoDatePicker(
                                                  backgroundColor: Colors.white,
                                                  initialDateTime: initTime,
                                                  onDateTimeChanged: (DateTime newTime) {      
                                                    String month = newTime.month.toString();
                                                    String day = newTime.day.toString();
                                                    String hour = newTime.hour.toString();
                                                    String minute = newTime.minute.toString();
                                                    if (newTime.month < 10) {
                                                      month = '0${month}';
                                                    }
                                                    if (newTime.day < 10) {
                                                      day = '0${day}';
                                                    }
                                                    if (newTime.hour < 10) {
                                                      hour = '0${hour}';
                                                    }
                                                    if (newTime.minute < 10) {
                                                      minute = '0${minute}';
                                                    }
                                                    
                                                    ref.read(scheStartDataProvider.notifier).state = '${popSelected.year}-${month}-${day} ${hour}:${minute}';
                                                  },
                                                  use24hFormat: true,
                                                );
                                              },
                                            ),
                                          ), 
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              );
                            }
                          ),
                          CupertinoButton(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Container(
                                      child: Text(
                                        '終了',
                                        style: TextStyle(color: Colors.black,)
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: FutureBuilder(
                                        future: getEndTimeScheFunc(ref),
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                          return Text(snapshot.data.toString());
                                        }
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                     child: Container(
                                      height: 300,
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(left: 10),
                                                    child:  CupertinoButton(
                                                      child: Text(
                                                        'キャンセル',
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context, CupertinoPageRoute(
                                                          builder: (context) => PopAddScreen(popSelected: popSelected),
                                                        ));
                                                      }
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(right: 10),
                                                    child: CupertinoButton(
                                                      child: Text(
                                                        '完了',
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      onPressed: () async{
                                                        Navigator.pop(context, CupertinoPageRoute(
                                                          builder: (context) => PopAddScreen(popSelected: popSelected),
                                                        ));
                                                        await ref.read(popSelectedEndDateProvider(popSelected.toString()).future);
                                                      }
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 200,
                                            child: FutureBuilder(
                                              future: getEndTimeScheFunc(ref),
                                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                DateTime initTime = DateTime.now();
                                                if(snapshot.hasData) {
                                                  initTime = DateTime.parse(snapshot.data);
                                                  print('initTime: ${initTime}');
                                                }else {
                                                  initTime = popSelected;
                                                }
                                                return CupertinoDatePicker(
                                                  backgroundColor: Colors.white,
                                                  initialDateTime: initTime,
                                                  onDateTimeChanged: (DateTime newTime) async{    
                                                    String month = newTime.month.toString();
                                                    String day = newTime.day.toString();
                                                    String hour = newTime.hour.toString();
                                                    String minute = newTime.minute.toString();
                                                    if (newTime.month < 10) {
                                                      month = '0${month}';
                                                    }
                                                    if (newTime.day < 10) {
                                                      day = '0${day}';
                                                    }
                                                    if (newTime.hour < 10) {
                                                      hour = '0${hour}';
                                                    }
                                                    if (newTime.minute < 10) {
                                                      minute = '0${minute}';
                                                    }
                                                    
                                                    ref.read(scheEndDataProvider.notifier).state = '${popSelected.year}-${month}-${day} ${hour}:${minute}';
                                                  },
                                                  use24hFormat: true,
                                                );
                                              }
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              );
                            }
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
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
                ),
              ],
            ),     
          ),
        ),
      ),
    );
  }
}