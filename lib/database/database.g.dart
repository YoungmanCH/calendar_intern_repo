// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ScheduleTableTable extends ScheduleTable
    with TableInfo<$ScheduleTableTable, ScheduleRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduleTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _startDayMeta =
      const VerificationMeta('startDay');
  @override
  late final GeneratedColumn<String> startDay = GeneratedColumn<String>(
      'start_day', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _endDayMeta = const VerificationMeta('endDay');
  @override
  late final GeneratedColumn<String> endDay = GeneratedColumn<String>(
      'end_day', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _judgeMeta = const VerificationMeta('judge');
  @override
  late final GeneratedColumn<bool> judge =
      GeneratedColumn<bool>('judge', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("judge" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, startDay, endDay, content, date, judge];
  @override
  String get aliasedName => _alias ?? 'schedule_table';
  @override
  String get actualTableName => 'schedule_table';
  @override
  VerificationContext validateIntegrity(Insertable<ScheduleRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('start_day')) {
      context.handle(_startDayMeta,
          startDay.isAcceptableOrUnknown(data['start_day']!, _startDayMeta));
    } else if (isInserting) {
      context.missing(_startDayMeta);
    }
    if (data.containsKey('end_day')) {
      context.handle(_endDayMeta,
          endDay.isAcceptableOrUnknown(data['end_day']!, _endDayMeta));
    } else if (isInserting) {
      context.missing(_endDayMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('judge')) {
      context.handle(
          _judgeMeta, judge.isAcceptableOrUnknown(data['judge']!, _judgeMeta));
    } else if (isInserting) {
      context.missing(_judgeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      startDay: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_day'])!,
      endDay: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_day'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      judge: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}judge'])!,
    );
  }

  @override
  $ScheduleTableTable createAlias(String alias) {
    return $ScheduleTableTable(attachedDatabase, alias);
  }
}

class ScheduleRecord extends DataClass implements Insertable<ScheduleRecord> {
  final int id;
  final String title;
  final String startDay;
  final String endDay;
  final String content;
  final DateTime date;
  final bool judge;
  const ScheduleRecord(
      {required this.id,
      required this.title,
      required this.startDay,
      required this.endDay,
      required this.content,
      required this.date,
      required this.judge});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['start_day'] = Variable<String>(startDay);
    map['end_day'] = Variable<String>(endDay);
    map['content'] = Variable<String>(content);
    map['date'] = Variable<DateTime>(date);
    map['judge'] = Variable<bool>(judge);
    return map;
  }

  ScheduleTableCompanion toCompanion(bool nullToAbsent) {
    return ScheduleTableCompanion(
      id: Value(id),
      title: Value(title),
      startDay: Value(startDay),
      endDay: Value(endDay),
      content: Value(content),
      date: Value(date),
      judge: Value(judge),
    );
  }

  factory ScheduleRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleRecord(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      startDay: serializer.fromJson<String>(json['startDay']),
      endDay: serializer.fromJson<String>(json['endDay']),
      content: serializer.fromJson<String>(json['content']),
      date: serializer.fromJson<DateTime>(json['date']),
      judge: serializer.fromJson<bool>(json['judge']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'startDay': serializer.toJson<String>(startDay),
      'endDay': serializer.toJson<String>(endDay),
      'content': serializer.toJson<String>(content),
      'date': serializer.toJson<DateTime>(date),
      'judge': serializer.toJson<bool>(judge),
    };
  }

  ScheduleRecord copyWith(
          {int? id,
          String? title,
          String? startDay,
          String? endDay,
          String? content,
          DateTime? date,
          bool? judge}) =>
      ScheduleRecord(
        id: id ?? this.id,
        title: title ?? this.title,
        startDay: startDay ?? this.startDay,
        endDay: endDay ?? this.endDay,
        content: content ?? this.content,
        date: date ?? this.date,
        judge: judge ?? this.judge,
      );
  @override
  String toString() {
    return (StringBuffer('ScheduleRecord(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startDay: $startDay, ')
          ..write('endDay: $endDay, ')
          ..write('content: $content, ')
          ..write('date: $date, ')
          ..write('judge: $judge')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, startDay, endDay, content, date, judge);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleRecord &&
          other.id == this.id &&
          other.title == this.title &&
          other.startDay == this.startDay &&
          other.endDay == this.endDay &&
          other.content == this.content &&
          other.date == this.date &&
          other.judge == this.judge);
}

class ScheduleTableCompanion extends UpdateCompanion<ScheduleRecord> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> startDay;
  final Value<String> endDay;
  final Value<String> content;
  final Value<DateTime> date;
  final Value<bool> judge;
  const ScheduleTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.startDay = const Value.absent(),
    this.endDay = const Value.absent(),
    this.content = const Value.absent(),
    this.date = const Value.absent(),
    this.judge = const Value.absent(),
  });
  ScheduleTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String startDay,
    required String endDay,
    required String content,
    required DateTime date,
    required bool judge,
  })  : title = Value(title),
        startDay = Value(startDay),
        endDay = Value(endDay),
        content = Value(content),
        date = Value(date),
        judge = Value(judge);
  static Insertable<ScheduleRecord> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? startDay,
    Expression<String>? endDay,
    Expression<String>? content,
    Expression<DateTime>? date,
    Expression<bool>? judge,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (startDay != null) 'start_day': startDay,
      if (endDay != null) 'end_day': endDay,
      if (content != null) 'content': content,
      if (date != null) 'date': date,
      if (judge != null) 'judge': judge,
    });
  }

  ScheduleTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? startDay,
      Value<String>? endDay,
      Value<String>? content,
      Value<DateTime>? date,
      Value<bool>? judge}) {
    return ScheduleTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      startDay: startDay ?? this.startDay,
      endDay: endDay ?? this.endDay,
      content: content ?? this.content,
      date: date ?? this.date,
      judge: judge ?? this.judge,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startDay.present) {
      map['start_day'] = Variable<String>(startDay.value);
    }
    if (endDay.present) {
      map['end_day'] = Variable<String>(endDay.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (judge.present) {
      map['judge'] = Variable<bool>(judge.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startDay: $startDay, ')
          ..write('endDay: $endDay, ')
          ..write('content: $content, ')
          ..write('date: $date, ')
          ..write('judge: $judge')
          ..write(')'))
        .toString();
  }
}

abstract class _$ScheduleDatabase extends GeneratedDatabase {
  _$ScheduleDatabase(QueryExecutor e) : super(e);
  late final $ScheduleTableTable scheduleTable = $ScheduleTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [scheduleTable];
}
