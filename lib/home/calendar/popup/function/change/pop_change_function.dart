import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/pop_change_provider.dart';
import '../../provider/pop_provider.dart';

void textSettingFunc(
  WidgetRef ref, String scheTitle, String scheContent) {
    final start = ref.watch(scheStartDateChangeShowProvider);
    final end = ref.watch(scheEndDateChangeShowProvider);
  if (ref.watch(titleEditingProvider(scheTitle)).text.isNotEmpty &&
      ref.watch(commentEditingProvider(scheContent)).text.isNotEmpty) {
    if(start.isBefore(end)) {
      Future(() {
        ref.watch(conditionJudgeChangeProvider.notifier).state = true;
      });
    }else if (start.isAfter(end)){
      Future(() {
        ref.watch(conditionJudgeChangeProvider.notifier).state = false;
      });
    }else if(ref.watch(switchChangeProvider) == true) {
      Future(() {
        ref.watch(conditionJudgeChangeProvider.notifier).state = true;
      });
    }else {
      Future(() {
        ref.watch(conditionJudgeChangeProvider.notifier).state = false;
      });
    }
  } else {
    Future(() {
      ref.watch(conditionJudgeChangeProvider.notifier).state = false;
    });
  }
}

Future<String> getStartTimeScheFunc(WidgetRef ref) async {
  final startDate = ref.watch(popSelectedStartShowProvider);
  return await ref
      .watch(popSelectedChangeStartDateProvider(startDate.toString()).future);
}

Future<String> getEndTimeScheFunc(WidgetRef ref) async {
  final popSelected = ref.watch(popSelectedEndShowProvider);
  return await ref
      .watch(popSelectedChangeEndDateProvider(popSelected.toString()).future);
}
