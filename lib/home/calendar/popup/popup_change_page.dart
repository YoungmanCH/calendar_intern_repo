import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home_page.dart';
import '../../../database/database.dart';
import 'provider/pop_show_provider.dart';
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

//ref.watch, ref.listenは関数内で使用してはいけない。


//dataの取得は、futureProviderで行い、pageviewでのデータの変更はstateproviderで扱う。

class PopChangeWidget extends ConsumerStatefulWidget {
  const PopChangeWidget({super.key});

  @override
  PopChangeScreen createState() => PopChangeScreen();
}

class PopChangeScreen extends ConsumerState<PopChangeWidget> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final changePro = ref.watch(popupChangeValProvider);
    final index = changePro.id;
    final scheTitle = changePro.scheTitle;
    final scheEndDate = changePro.scheEndDate;
    final scheContent = changePro.scheContent;
    String scheStartDate = ref.read(scheStartDataChangeProvider).toString();

    //build後に実行される。どうしてもbuild内でProviderの状態を変更したい場合に用いる。
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        textSettingFunc(ref, scheTitle, scheContent);
      },
    );
  

    CupertinoDatePickerMode mode = CupertinoDatePickerMode.dateAndTime;      
    if(ref.watch(switchChangeProvider) == false) {
      mode = CupertinoDatePickerMode.dateAndTime;      
    }else {
      mode = CupertinoDatePickerMode.date;      
    }

    return MaterialApp(
      home: Scaffold(
        //キーボードが表示されると画面のサイズを変更する
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromARGB(248, 235, 234, 234),
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
                    ref.invalidate(scheduleFromDatetimeProvider);
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
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Center(
              child: Container(
                color: const Color.fromARGB(248, 235, 234, 234),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        color: Colors.white,
                        child: Focus(
                          onFocusChange: (hasFocus) {
                            if (hasFocus) {
                              ref.read(isTitleFocusedProvider.notifier).state = true;
                            } else {
                              ref.read(isTitleFocusedProvider.notifier).state = false;
                            }
                          },
                          child: Container(
                            width: 400,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ref.watch(isTitleFocusedProvider) ? Colors.blue : Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: TextFormField(
                              controller: ref.watch(titleEditingProvider(scheTitle)),
                              autofocus: true,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                hintText: 'タイトルを入力してください',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
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
                                      onChanged: (value) async{
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
                        child: Focus(
                          onFocusChange: (hasFocus) {
                            if (hasFocus) {
                              ref.read(isCommentFocusedProvider.notifier).state = true;
                            } else {
                              ref.read(isCommentFocusedProvider.notifier).state = false;
                            }
                          },
                          child: Container(
                            width: 400,
                            height: 160,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ref.watch(isCommentFocusedProvider) ? Colors.blue : Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: TextFormField(
                              controller: ref.read(commentEditingProvider(scheContent)),
                              maxLines: 6,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                hintText: 'コメントを入力してください',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
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
                          onPressed: () {
                            deleteScheduleFunc(context, ref);
                          }
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