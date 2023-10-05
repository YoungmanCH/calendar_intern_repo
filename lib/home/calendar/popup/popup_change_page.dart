import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home_page.dart';
import '../../../database/database.dart';
import 'provider/pop_change_provider.dart';
import 'function/change/pop_change_function.dart';
import 'function/change/pop_change_widget.dart';

// option + shift+ f 

//Buildは毎度画面が描画されるたびに実行されるため、注意！

//基本的にProviderは、クラスの外で宣言する必要がある。マジで！

//Dartにおいて、型の設定は絶対必須。

//青文字、黄色文字の波線は極力減らすべし。

//futureProviderでデータの値を取得する場合は　await ref.read(popSelectedDateProvider(scheStartDate).future),　のように使用する。buildするときは、whenを使用する。

// command + . でcontainerなどで要素を囲える。

class PopChangeScreen extends ConsumerWidget {
  final int index;
  final String scheTitle;
  final String scheEndDate;
  final String scheContent;

  const PopChangeScreen({
    Key? key,
    required this.index,
    required this.scheTitle, 
    required this.scheEndDate, 
    required this.scheContent
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String scheStartDate = ref.read(scheStartDataChangeProvider).toString();
    Future(() {
      textSettingFunc(ref, scheTitle, scheContent);
    });

    CupertinoDatePickerMode mode = CupertinoDatePickerMode.dateAndTime;      
    if(ref.watch(switchChangeProvider) == false) {
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
              CupertinoButton(
                padding: const EdgeInsets.only(bottom: 0),
                child: const Icon(
                  CupertinoIcons.clear,
                  color: Colors.white,
                ),
                onPressed: () => appBarCancelChangeFunc(context, ref),
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
                  onPressed: ref.watch(conditionJudgeChangeProvider) == false ? null : () async{
                    Navigator.push(
                      context, 
                      CupertinoPageRoute(builder: (context) => const HomeScreen())
                    );
                    final dateSche =  DateTime.parse(await ref.watch(popSelectedChangeStartDateProvider(scheStartDate).future));
                    DateTime datetimeJudgement = DateTime(dateSche.year, dateSche.month, dateSche.day);
                    final database = ref.watch(databaseProvider);
                    await database.updateSchedule(
                      index, 
                      ref.watch(titleEditingProvider(scheTitle)).text, 
                      await ref.watch(popSelectedChangeStartDateProvider(scheStartDate).future),
                      await ref.watch(popSelectedChangeEndDateProvider(scheEndDate).future), 
                      ref.watch(commentEditingProvider(scheContent)).text, 
                      datetimeJudgement, 
                      ref.watch(switchChangeProvider.notifier).state,
                    );
                  },       
                  child: const Text(
                    '保存', 
                    style: TextStyle(
                      color: Color.fromARGB(255, 222, 222, 222), 
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
                  padding: const EdgeInsets.only(top: 40, right: 15, left: 15),
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
                                  padding: EdgeInsets.only(left: 15,),
                                  child: Text(
                                    '終日',
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),    
                                ),
                                Switch(
                                  value: ref.watch(switchChangeProvider),
                                  onChanged: (value) {
                                    ref.watch(switchChangeProvider.notifier).state = value;
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
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15,),
                                    child: FutureBuilder(
                                      future: getStartTimeScheFunc(ref),
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          Future.delayed(Duration.zero, () {
                                            ref.watch(scheStartDateChangeShowProvider.notifier).state = DateTime.parse(snapshot.data);
                                          });
                                        }
                                        return Text(snapshot.data.toString());
                                      }
                                    ),    
                                  ),
                                ],
                              ),
                              onPressed: () {
                                startDatePickerChangeFunc(
                                  context,
                                  ref,
                                  index,
                                  scheTitle,
                                  scheEndDate,
                                  scheContent,
                                  mode
                                );
                              }
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
                                  style: TextStyle(color: Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15,),
                                  child: FutureBuilder(
                                    future: getEndTimeScheFunc(ref),
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      Future.delayed(Duration.zero, () {
                                        ref.watch(scheEndDateChangeShowProvider.notifier).state = DateTime.parse(snapshot.data);
                                      });
                                      return Text(snapshot.data.toString());
                                    },
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async{
                              endDatePickerChangeFunc(
                                context,
                                ref,
                                index,
                                scheTitle,
                                scheEndDate,
                                scheContent,
                                mode,
                              );
                            },
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
                      // placeholder: 'コメントを入力してください',
                      controller: ref.watch(commentEditingProvider(scheContent)),
                      maxLines: 6,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Container(
                    color: Colors.white,
                    width: 400,
                    height: 60,
                    child: CupertinoButton(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: const Text(
                        'この予定を削除',
                        style: TextStyle(
                          color: CupertinoColors.systemRed,
                        ),
                      ),
                      onPressed: () => deleteScheduleFunc(context, ref),
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