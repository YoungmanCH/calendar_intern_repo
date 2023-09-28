import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/pop_add_provider.dart';
import '../../provider/pop_provider.dart';

void textSettingFunc(
  WidgetRef ref, String scheTitle, String scheComment) {
    final start = ref.watch(scheStartDateShowProvider);
    final end = ref.watch(scheEndDateShowProvider);
    scheTitle = ref.watch(titleAddProvider(scheTitle)).text;
    scheComment = ref.watch(commentAddProvider(scheComment)).text;

  if (ref.watch(titleAddProvider(scheTitle)).text.isNotEmpty &&
      ref.watch(commentAddProvider(scheComment)).text.isNotEmpty) {

    if(start.isBefore(end)) {
      Future(() {
        ref.watch(conditionJudgeProvider.notifier).state = true;
      });
    }else if (start.isAfter(end)){
      Future(() {
        ref.watch(conditionJudgeProvider.notifier).state = false;
      });
    }else if(ref.watch(switchProvider) == true) {
      Future(() {
        ref.watch(conditionJudgeProvider.notifier).state = true;
      });
    }else {
      Future(() {
        ref.watch(conditionJudgeProvider.notifier).state = false;
      });
    }
    
  } else {
    Future(() {
      ref.watch(conditionJudgeProvider.notifier).state = false;
    });
  }
}

Future<String> getStartTimeScheFunc(WidgetRef ref) async {
  final startDate = ref.watch(popSelectedStartShowProvider);
  return await ref
      .watch(popSelectedStartDateProvider(startDate.toString()).future);
}

Future<String> getEndTimeScheFunc(WidgetRef ref) async {
  final endDate = ref.watch(popSelectedEndShowProvider);
  return await ref
      .watch(popSelectedEndDateProvider(endDate.toString()).future);
}
