import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';

final selectedDateProvider = Provider.family<DateTime, DateTime>((ref, DateTime selectedDate) => selectedDate);
final selectedWeekdayProvider = Provider.family<int, int>((ref, int weekday) => weekday);
final selectedWeekdayStringProvider = StateProvider<String>((ref) => '');
final selectedWeekColorProvider = StateProvider<Color>((ref) => Colors.black);

final currentPageProvider = StateProvider<int>((ref) => DateTime.now().month -1);
final pageControllerProvider2 = Provider<PageController>((ref) {
  final currentPage = ref.watch(currentPageProvider);
  return PageController(initialPage: currentPage);
});

final firstDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final scheExistJudgeProvider = StateProvider<bool>((ref) => false);
final scheduleTitleListProvider2 = FutureProvider.family<List,DateTime>((ref, firstDate) async{
  final database = ref.watch(databaseProvider);
    final scheTitleList = await database.getScheduleTitle(firstDate);
    return scheTitleList;
  }
);

final scheduleTitleListProvider = StateProvider<List>((ref) => []);
final scheduleJudgeListProvider = StateProvider<List>((ref) => []);
final scheduleStartDayListProvider = StateProvider<List>((ref) => []);
final scheduleEndDayListProvider = StateProvider<List>((ref) => []);
final scheduleContentListProvider = StateProvider<List>((ref) => []);

final popSelectedProvider = StateProvider<DateTime>((ref) => DateTime.now());