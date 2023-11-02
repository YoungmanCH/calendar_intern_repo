import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_provider.dart';
import 'calendar/calendar_provider.dart';
import 'calendar/calendar_page.dart';
import 'home_function.dart';


//pageView.builderはProviderで管理してはいけない。使いまわしたい場合は、クラスで継承させるように！
class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = getElapsedMonths(ref.watch(setDateProvider));
    DateTime firstDayController = ref.read(firstDayProvider);
    DateTime lastDayController = ref.read(lastDayProvider);

    final pageController = PageController(
      initialPage: ref.watch(homePageIndexProvider),
    );

    return MaterialApp(
      home: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('カレンダー', style: TextStyle(color: Colors.white,)),
          backgroundColor: Colors.blue,
        ),
        child: PageView.builder(
          controller: pageController,
          onPageChanged: (int page) {
            ref.watch(selectedCountMonthProvider.notifier).state = page;
            ref.watch(selectedDatePageProvider.notifier).state = getYearFromElapsedMonths(ref.watch(selectedCountMonthProvider));
            ref.watch(homePageIndexProvider.notifier).state = page;
          },
          itemBuilder: (context, index) {
            final currentDate = getYearFromElapsedMonths(index);

            firstDayController = DateTime(
              currentDate.year, 
              currentDate.month,
              1,
            );

            lastDayController = DateTime(
              currentDate.year, 
              currentDate.month + 1, 
              0,
            );

            return CalendarScreen(
              selectedMonth: selectedMonth,
              firstDay: firstDayController, 
              lastDay: lastDayController, 
              pageController: pageController,
            );
          }
        ),
      ),
    );
  }
}