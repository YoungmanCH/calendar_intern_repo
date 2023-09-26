import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentPageProvider =
    StateProvider<int>((ref) => DateTime.now().month - 1);

final pageControllerProvider = Provider<PageController>((ref) {
  final currentPage = ref.watch(currentPageProvider);
  return PageController(initialPage: currentPage);
});

final firstDayProvider = StateProvider<DateTime>((ref) => DateTime.now());
final lastDayProvider = StateProvider<DateTime>((ref) => DateTime.now());
