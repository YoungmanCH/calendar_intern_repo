import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_provider.dart';
import 'calendar/calendar_page.dart';

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

    final PageController pageController = ref.read(pageControllerProvider);
    DateTime firstDayController = ref.read(firstDayProvider);
    DateTime lastDayController = ref.read(lastDayProvider);

    return CupertinoApp(
      home: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('カレンダー', style: TextStyle(color: Colors.white,)),
          backgroundColor: Colors.blue,
        ),
        child: PageView.builder(
          controller: pageController,
          onPageChanged: (int page) {
            ref.read(currentPageProvider.notifier).state = page;
          },
          itemBuilder: (context, index) {
            DateTime currentDate = DateTime(
              DateTime.now().year, 
              index + 1, 
              1,
            );

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
              firstDay: firstDayController, 
              lastDay: lastDayController, 
              pageController: pageController
            );
          }
        ),
      ),
    );
  }
}