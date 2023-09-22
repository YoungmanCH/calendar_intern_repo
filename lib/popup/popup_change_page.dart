import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home/home_page.dart';
import '../database/database.dart';
import 'function/pop_change_function.dart';
import 'provider/pop_change_provider.dart';

// option + shift+ f 

//Buildは毎度画面が描画されるたびに実行されるため、注意！

//基本的にProviderは、クラスの外で宣言する必要がある。マジで！

//Dartにおいて、型の設定は絶対必須。

//青文字、黄色文字の波線は極力減らすべし。

// .familyを使用することで、クラス外からクラス内の変数を引数として使用できるようになる。また、<>型を複数設定できるようになり、第一引数型はその変数の型を指す。

//futureProviderでデータの値を取得する場合は　await ref.read(popSelectedDateProvider(scheStartDate).future),　のように使用する。buildするときは、whenを使用する。

class PopChangeScreen extends ConsumerWidget {
  final int index;
  final DateTime firstDate;
  final String scheTitle;
  final bool scheJudge;
  final String scheStartDate;
  final String scheEndDate;
  final String scheContent;

  const PopChangeScreen({
    Key? key,
    required this.index,
    required this.firstDate, 
    required this.scheTitle, 
    required this.scheJudge, 
    required this.scheStartDate, 
    required this.scheEndDate, 
    required this.scheContent
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool switchJudge = ref.watch(switchChangeProvider);
    bool conditionJudge = ref.watch(conditionJudgeChangeProvider);

    textSettingFunc(ref, scheTitle, scheContent);

    return MaterialApp(
      home: Scaffold(
        appBar: CupertinoNavigationBar(
          backgroundColor: Colors.blue,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                padding: const EdgeInsets.only(bottom: 0),
                child: const Icon(
                  CupertinoIcons.clear,
                  color: Colors.white,
                ),
                onPressed: () => {
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
                              )
                            ),
                            child: const Text('編集を破棄'),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('キャンセル'),
                          ),
                        ],
                      );
                    }
                  ),
                }
              ),
              const Text(
                '予定の編集', 
                style: TextStyle(
                  color: Colors.white,
                )
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 5),
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  color: Colors.white,
                  onPressed: conditionJudge == false ? null : () async{
                    Navigator.push(
                      context, 
                      CupertinoPageRoute(builder: (context) => const HomeScreen())
                    );
                    final dateSche = ref.watch(datetimeJudgeChangeProvider);
                    DateTime datetimeJudgement = DateTime(dateSche.year, dateSche.month, dateSche.day);
                    final database = ref.watch(databaseProvider);
                    await database.updateSchedule(
                      index, 
                      ref.read(titleEditingProvider(scheTitle)).text, 
                      await ref.read(popSelectedChangeStartDateProvider(scheStartDate).future),
                      await ref.read(popSelectedChangeEndDateProvider(scheEndDate).future), 
                      ref.read(commentEditingProvider(scheContent)).text, 
                      datetimeJudgement, 
                      ref.read(switchChangeProvider.notifier).state,
                    );
                  },       
                  child: const Text(
                    '保存', 
                    style: TextStyle(
                      color: Colors.grey, 
                      fontSize: 12,
                    ),
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
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: 400,
                    height: 60,
                    child: CupertinoTextField(
                      // placeholder: 'タイトルを入力してください',
                      controller: ref.watch(titleEditingProvider(scheTitle)),
                    ),  
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                    width: 400,
                    height: 160,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
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
                              const Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text('終日',),    
                              ),
                              Switch(
                                value: switchJudge,
                                onChanged: (value) {
                                  switchJudge = value;
                                  ref.read(switchChangeProvider.notifier).state = switchJudge;
                                },
                              ),
                            ],
                          ),
                        ),
                        CupertinoButton(
                          child: Container(
                            decoration: const BoxDecoration(
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
                                const Padding(
                                  padding: EdgeInsets.only(top: 15, left: 15, bottom: 15,),
                                  child: Text('開始',),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, right: 15, bottom: 15,),
                                  child: FutureBuilder(
                                    future: getStartTimeScheFunc(ref),
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      return Text(snapshot.data.toString());
                                    }
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
                                  height: 300,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child:  CupertinoButton(
                                              child: const Text(
                                                'キャンセル',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 16,
                                                ),                                                
                                              ),
                                              onPressed: () async {
                                                Navigator.pop(context, CupertinoPageRoute(
                                                  builder: (context) => PopChangeScreen(
                                                    index: index,
                                                    firstDate:  firstDate, 
                                                    scheTitle: scheTitle, 
                                                    scheJudge: scheJudge, 
                                                    scheStartDate: scheStartDate, 
                                                    scheEndDate: scheEndDate, 
                                                    scheContent: scheContent
                                                  ),
                                                ),);
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
                                                onPressed: () async{ 
                                                  Navigator.pop(context, CupertinoPageRoute(
                                                    builder: (context) => PopChangeScreen(
                                                    index: index,
                                                    firstDate: firstDate, 
                                                    scheTitle: scheTitle, 
                                                    scheJudge: scheJudge, 
                                                    scheStartDate: scheStartDate, 
                                                    scheEndDate: scheEndDate, 
                                                    scheContent: scheContent
                                                  ),
                                                ));
                                              }
                                            ),
                                          ),                       
                                        ],
                                      ),
                                      SizedBox(
                                        height: 200,
                                        child: CupertinoDatePicker(
                                          backgroundColor: Colors.white,
                                          initialDateTime: DateTime.parse(scheStartDate),
                                          minuteInterval: 15,
                                          onDateTimeChanged: (DateTime newTime) async{      
                                            String month = newTime.month.toString();
                                            String day = newTime.day.toString();
                                            String hour = newTime.hour.toString();
                                            String minute = newTime.minute.toString();
                                            if (newTime.month < 10) {
                                              month = '0$month';
                                            }
                                            if (newTime.day < 10) {
                                              day = '0$day';
                                            }
                                            if (newTime.hour < 10) {
                                              hour = '0$hour';
                                            }
                                            if (newTime.minute < 10) {
                                              minute = '0$minute';
                                            }
                                            ref.read(scheStartDataChangeProvider.notifier).state = '${DateTime.parse(scheStartDate).year}-$month-$day $hour:$minute';
                                          },
                                          use24hFormat: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            );
                          },
                        ),
                        CupertinoButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 15, left: 15, bottom: 15,),
                                child: Text('終了',),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15, right: 15, bottom: 15,),
                                child: FutureBuilder(
                                  future: getEndTimeScheFunc(ref),
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    return Text(snapshot.data.toString());
                                  },
                                ),
                              ),
                            ],
                          ),
                          onPressed: () async{
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
                                            child:  CupertinoButton(
                                              child: const Text(
                                                'キャンセル',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              onPressed: () async {
                                                Navigator.pop(context, CupertinoPageRoute(
                                                  builder: (context) => PopChangeScreen(
                                                    index: index,
                                                    firstDate:  firstDate, 
                                                    scheTitle: scheTitle, 
                                                    scheJudge: scheJudge, 
                                                    scheStartDate: scheStartDate, 
                                                    scheEndDate: scheEndDate, 
                                                    scheContent: scheContent
                                                  ),
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
                                              onPressed: () async{ 
                                                Navigator.pop(
                                                  context, 
                                                  CupertinoPageRoute(
                                                    builder: (context) => PopChangeScreen(
                                                      index: index,
                                                      firstDate: firstDate, 
                                                      scheTitle: scheTitle, 
                                                      scheJudge: scheJudge, 
                                                      scheStartDate: scheStartDate, 
                                                      scheEndDate: scheEndDate, 
                                                      scheContent: scheContent
                                                    ),
                                                  ),
                                                );
                                                await ref.read(popSelectedChangeEndDateProvider(scheEndDate).future);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 200,
                                        child: CupertinoDatePicker(
                                          backgroundColor: Colors.white,
                                          initialDateTime: DateTime.parse(scheEndDate),
                                          minuteInterval: 15,
                                          onDateTimeChanged: (DateTime newTime) async{      
                                            String month = newTime.month.toString();
                                            String day = newTime.day.toString();
                                            String hour = newTime.hour.toString();
                                            String minute = newTime.minute.toString();
                                            if (newTime.month < 10) {
                                              month = '0$month';
                                            }
                                            if (newTime.day < 10) {
                                              day = '0$day';
                                            }
                                            if (newTime.hour < 10) {
                                              hour = '0$hour';
                                            }
                                            if (newTime.minute < 10) {
                                              minute = '0$minute';
                                            }
                                            ref.read(scheEndDataChangeProvider.notifier).state = '${DateTime.parse(scheEndDate).year}-$month-$day $hour:$minute';
                                          },
                                          use24hFormat: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
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
                      // placeholder: 'コメントを入力してください',
                      controller: ref.watch(commentEditingProvider(scheContent)),
                      maxLines: 6,
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