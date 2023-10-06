import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:drift/drift.dart';
import 'start_page.dart';
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  const mainApp = MyApp();
  const scope = ProviderScope(child: mainApp);
  runApp(scope);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ja'),
      ],
      locale: const Locale('ja'),
      home: StartWidget(),
    );
  }
}


// MEMO

//Providerの中で、初期化処理、stateProviderの値を変更してはならない。

//laund.json file にて　 "noDebug": true,

//NotifierProvider

//StateProviderの値を　.notifier.stateで値を変更してもbuildされるまで値が変更されない。

// //大元
// class CalendarService {

//   //使用機能を切り出す。
//   addSchedule();
//   changeSchedule();

//   //Pageで機能を呼び出す。
//   calendarService.addSchedule();
// }

//ViewPageのみClassを使用するとわかりやすい。

//MVC
// StateNotifier Page毎に状態を管理させる。
//StateNotifierはStateProviderと違って、関数を持つことができ、またクラスの一種である。
// Page = View　見た目
//Controller = Function,Provider 機能