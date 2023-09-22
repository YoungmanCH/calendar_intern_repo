import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'start_page.dart';
void main() {
  const mainApp = MyApp();
  const scope = ProviderScope(child: mainApp);
  runApp(scope);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: StartWidget(),
    );
  }
}

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






  
  
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Flutter Demo',
  //     theme: ThemeData(
  //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  //       useMaterial3: true,
  //     ),
  //     home: const MyHomePage(title: 'Flutter Demo Home Page'),
  //   );
  // }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
