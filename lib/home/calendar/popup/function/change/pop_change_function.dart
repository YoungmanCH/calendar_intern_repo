import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/pop_change_provider.dart';
import '../../provider/pop_provider.dart';

Future<void> textSettingFunc(
    WidgetRef ref, String scheTitle, String scheContent) async {
  if (ref.watch(titleEditingProvider(scheTitle)).text.isNotEmpty &&
      ref.watch(commentEditingProvider(scheContent)).text.isNotEmpty) {
    Future(() {
      ref.watch(conditionJudgeChangeProvider.notifier).state = true;
    });
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
