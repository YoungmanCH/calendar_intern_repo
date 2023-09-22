import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/pop_add_provider.dart';
import '../provider/pop_provider.dart';

//この関数を呼び出す際に引数を空文字などにすると、初期値が空文字として認識される。
Future<void> textSettingFunc(
    WidgetRef ref, String scheTitle, String scheComment) async {
  if (ref.watch(titleAddProvider(scheTitle)).text.isNotEmpty &&
      ref.watch(commentAddProvider(scheComment)).text.isNotEmpty) {
    Future(() {
      ref.read(conditionJudgeProvider.notifier).state = true;
    });
  } else {
    Future(() {
      ref.read(conditionJudgeProvider.notifier).state = false;
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
