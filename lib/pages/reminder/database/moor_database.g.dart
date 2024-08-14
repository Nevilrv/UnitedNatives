// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// ignore_for_file: type=lint
class $MedicinesTableTable extends MedicinesTable
    with TableInfo<$MedicinesTableTable, MedicinesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicinesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 5, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _doseMeta = const VerificationMeta('dose');
  @override
  late final GeneratedColumn<String> dose = GeneratedColumn<String>(
      'dose', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
      'time', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, image, dose, time];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicines_table';
  @override
  VerificationContext validateIntegrity(Insertable<MedicinesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    if (data.containsKey('dose')) {
      context.handle(
          _doseMeta, dose.isAcceptableOrUnknown(data['dose']!, _doseMeta));
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicinesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicinesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
      dose: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dose']),
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time']),
    );
  }

  @override
  $MedicinesTableTable createAlias(String alias) {
    return $MedicinesTableTable(attachedDatabase, alias);
  }
}

class MedicinesTableData extends DataClass
    implements Insertable<MedicinesTableData> {
  final int id;
  final String name;
  final String? image;
  final String? dose;
  final String? time;
  const MedicinesTableData(
      {required this.id, required this.name, this.image, this.dose, this.time});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || dose != null) {
      map['dose'] = Variable<String>(dose);
    }
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<String>(time);
    }
    return map;
  }

  MedicinesTableCompanion toCompanion(bool nullToAbsent) {
    return MedicinesTableCompanion(
      id: Value(id),
      name: Value(name),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      dose: dose == null && nullToAbsent ? const Value.absent() : Value(dose),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
    );
  }

  factory MedicinesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicinesTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      image: serializer.fromJson<String?>(json['image']),
      dose: serializer.fromJson<String?>(json['dose']),
      time: serializer.fromJson<String?>(json['time']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'image': serializer.toJson<String?>(image),
      'dose': serializer.toJson<String?>(dose),
      'time': serializer.toJson<String?>(time),
    };
  }

  MedicinesTableData copyWith(
          {int? id,
          String? name,
          Value<String?> image = const Value.absent(),
          Value<String?> dose = const Value.absent(),
          Value<String?> time = const Value.absent()}) =>
      MedicinesTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image.present ? image.value : this.image,
        dose: dose.present ? dose.value : this.dose,
        time: time.present ? time.value : this.time,
      );
  MedicinesTableData copyWithCompanion(MedicinesTableCompanion data) {
    return MedicinesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      image: data.image.present ? data.image.value : this.image,
      dose: data.dose.present ? data.dose.value : this.dose,
      time: data.time.present ? data.time.value : this.time,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicinesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('image: $image, ')
          ..write('dose: $dose, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, image, dose, time);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicinesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.image == this.image &&
          other.dose == this.dose &&
          other.time == this.time);
}

class MedicinesTableCompanion extends UpdateCompanion<MedicinesTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> image;
  final Value<String?> dose;
  final Value<String?> time;
  const MedicinesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.image = const Value.absent(),
    this.dose = const Value.absent(),
    this.time = const Value.absent(),
  });
  MedicinesTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.image = const Value.absent(),
    this.dose = const Value.absent(),
    this.time = const Value.absent(),
  }) : name = Value(name);
  static Insertable<MedicinesTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? image,
    Expression<String>? dose,
    Expression<String>? time,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (image != null) 'image': image,
      if (dose != null) 'dose': dose,
      if (time != null) 'time': time,
    });
  }

  MedicinesTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? image,
      Value<String?>? dose,
      Value<String?>? time}) {
    return MedicinesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      dose: dose ?? this.dose,
      time: time ?? this.time,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (dose.present) {
      map['dose'] = Variable<String>(dose.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicinesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('image: $image, ')
          ..write('dose: $dose, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MedicinesTableTable medicinesTable = $MedicinesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [medicinesTable];
}

typedef $$MedicinesTableTableCreateCompanionBuilder = MedicinesTableCompanion
    Function({
  Value<int> id,
  required String name,
  Value<String?> image,
  Value<String?> dose,
  Value<String?> time,
});
typedef $$MedicinesTableTableUpdateCompanionBuilder = MedicinesTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String?> image,
  Value<String?> dose,
  Value<String?> time,
});

class $$MedicinesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicinesTableTable,
    MedicinesTableData,
    $$MedicinesTableTableFilterComposer,
    $$MedicinesTableTableOrderingComposer,
    $$MedicinesTableTableCreateCompanionBuilder,
    $$MedicinesTableTableUpdateCompanionBuilder> {
  $$MedicinesTableTableTableManager(
      _$AppDatabase db, $MedicinesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$MedicinesTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$MedicinesTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<String?> dose = const Value.absent(),
            Value<String?> time = const Value.absent(),
          }) =>
              MedicinesTableCompanion(
            id: id,
            name: name,
            image: image,
            dose: dose,
            time: time,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> image = const Value.absent(),
            Value<String?> dose = const Value.absent(),
            Value<String?> time = const Value.absent(),
          }) =>
              MedicinesTableCompanion.insert(
            id: id,
            name: name,
            image: image,
            dose: dose,
            time: time,
          ),
        ));
}

class $$MedicinesTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $MedicinesTableTable> {
  $$MedicinesTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get image => $state.composableBuilder(
      column: $state.table.image,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get dose => $state.composableBuilder(
      column: $state.table.dose,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get time => $state.composableBuilder(
      column: $state.table.time,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$MedicinesTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $MedicinesTableTable> {
  $$MedicinesTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get image => $state.composableBuilder(
      column: $state.table.image,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get dose => $state.composableBuilder(
      column: $state.table.dose,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get time => $state.composableBuilder(
      column: $state.table.time,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MedicinesTableTableTableManager get medicinesTable =>
      $$MedicinesTableTableTableManager(_db, _db.medicinesTable);
}
