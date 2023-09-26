import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/pop_add_provider.dart';
import '../../provider/pop_provider.dart';

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
