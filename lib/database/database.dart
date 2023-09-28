import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'database.g.dart';

final databaseProvider =
    Provider((_) => ScheduleDatabase(connectionDatabase()));
final streamDataProvider =
    StreamProvider<List>((ref) => ref.watch(databaseProvider).watchSchedule());

final scheduleListDateProvider = FutureProvider.family
    .autoDispose<List<ScheduleRecord>, DateTime>((ref, scheduleDate) {
  return ref.watch(databaseProvider).getScheduleListDate(scheduleDate);
});
// autoDisposeを使わない場合は、invalidateを使用する。

// final futureDataProvider = FutureProvider<List>((ref) => ref.watch(databaseProvider).getScheduleTitle());

@DataClassName('ScheduleRecord')
class ScheduleTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get startDay => text()();
  TextColumn get endDay => text()();
  TextColumn get content => text()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get judge => boolean()();
}

@DriftDatabase(tables: [ScheduleTable])
class ScheduleDatabase extends _$ScheduleDatabase {
  ScheduleDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  Future<List> getSchedule() {
    return select(scheduleTable).get();
  }

  Future<List<ScheduleRecord>> getScheduleListDate(
      DateTime scheduleDate) async {
    final results = await (select(scheduleTable)
          ..where((t) => t.date.equals(scheduleDate)))
        .get();
    return results;
  }

  Future<List> getScheduleTitle(DateTime scheduleDate) async {
    final results = await (select(scheduleTable)
          ..where((t) => t.date.equals(scheduleDate)))
        .get();
    List getList = [];
    for (final result in results) {
      getList.add(result.title);
    }
    return getList;
  }

  Future<List> getScheduleStartDay(DateTime scheduleDate) async {
    final results = await (select(scheduleTable)
          ..where((t) => t.date.equals(scheduleDate)))
        .get();
    List getList = [];
    for (final result in results) {
      getList.add(result.startDay);
    }
    return getList;
  }

  Future<List> getScheduleEndDay(DateTime scheduleDate) async {
    final results = await (select(scheduleTable)
          ..where((t) => t.date.equals(scheduleDate)))
        .get();
    List getList = [];
    for (final result in results) {
      getList.add(result.endDay);
    }
    return getList;
  }

  Future<List> getScheduleContent(DateTime scheduleDate) async {
    final results = await (select(scheduleTable)
          ..where((t) => t.date.equals(scheduleDate)))
        .get();
    List getList = [];
    for (final result in results) {
      getList.add(result.content);
    }
    return getList;
  }

  Future<List> getScheduleJudge(DateTime scheduleDate) async {
    final results = await (select(scheduleTable)
          ..where((t) => t.date.equals(scheduleDate)))
        .get();
    List getList = [];
    for (final result in results) {
      getList.add(result.judge);
    }
    return getList;
  }

  Stream<List> watchSchedule() {
    return select(scheduleTable).watch();
  }

  Future<void> addSchedule(String title, String startDay, String endDay,
      String content, DateTime date, bool judge) async {
    final companion = ScheduleTableCompanion(
      title: Value(title),
      startDay: Value(startDay),
      endDay: Value(endDay),
      content: Value(content),
      date: Value(date),
      judge: Value(judge),
    );
    await into(scheduleTable).insert(companion);
  }

  Future<void> updateSchedule(int id, String title, String startDay,
      String endDay, String content, DateTime date, bool judge) async {
    await (update(scheduleTable)..where((t) => t.id.equals(id))).write(
      //多分、 .write の代わりに　.replaceを用いても良い。
      ScheduleTableCompanion(
        id: Value(id),
        title: Value(title),
        startDay: Value(startDay),
        endDay: Value(endDay),
        content: Value(content),
        date: Value(date),
        judge: Value(judge),
      ),
    );
  }

  Future<void> deleteSchedule(DateTime scheduleDate) async {
    await (delete(scheduleTable)..where((t) => t.date.equals(scheduleDate))).go();
  }

}

LazyDatabase connectionDatabase() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'database.db'));

    // await file.delete();

    return NativeDatabase(file);
  });
}
