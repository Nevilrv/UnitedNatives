// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class MedicinesTableData extends DataClass
    implements Insertable<MedicinesTableData> {
  final int id;
  final String name;
  final String image;
  final String dose;
  final String time;
  MedicinesTableData(
      {@required this.id,
      @required this.name,
      @required this.image,
      @required this.dose,
      @required this.time});
  factory MedicinesTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return MedicinesTableData(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      image: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}image']),
      dose: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}dose']),
      time: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}time']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
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
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      dose: dose == null && nullToAbsent ? const Value.absent() : Value(dose),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
    );
  }

  factory MedicinesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return MedicinesTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      image: serializer.fromJson<String>(json['image']),
      dose: serializer.fromJson<String>(json['dose']),
      time: serializer.fromJson<String>(json['time']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'image': serializer.toJson<String>(image),
      'dose': serializer.toJson<String>(dose),
      'time': serializer.toJson<String>(time),
    };
  }

  MedicinesTableData copyWith(
          {int id, String name, String image, String dose, String time}) =>
      MedicinesTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        dose: dose ?? this.dose,
        time: time ?? this.time,
      );
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
  final Value<String> image;
  final Value<String> dose;
  final Value<String> time;
  const MedicinesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.image = const Value.absent(),
    this.dose = const Value.absent(),
    this.time = const Value.absent(),
  });
  MedicinesTableCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required String image,
    @required String dose,
    @required String time,
  })  : name = Value(name),
        image = Value(image),
        dose = Value(dose),
        time = Value(time);
  static Insertable<MedicinesTableData> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<String> image,
    Expression<String> dose,
    Expression<String> time,
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
      {Value<int> id,
      Value<String> name,
      Value<String> image,
      Value<String> dose,
      Value<String> time}) {
    return MedicinesTableCompanion(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        dose: dose ?? this.dose,
        time: time ?? this.time);
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

class $MedicinesTableTable extends MedicinesTable
    with TableInfo<$MedicinesTableTable, MedicinesTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $MedicinesTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedColumn<String> _name;
  @override
  GeneratedColumn<String> get name => _name ??= GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 5, maxTextLength: 50),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _imageMeta = const VerificationMeta('image');
  GeneratedColumn<String> _image;
  @override
  GeneratedColumn<String> get image =>
      _image ??= GeneratedColumn<String>('image', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _doseMeta = const VerificationMeta('dose');
  GeneratedColumn<String> _dose;
  @override
  GeneratedColumn<String> get dose =>
      _dose ??= GeneratedColumn<String>('dose', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _timeMeta = const VerificationMeta('time');
  GeneratedColumn<String> _time;
  @override
  GeneratedColumn<String> get time =>
      _time ??= GeneratedColumn<String>('time', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, image, dose, time];
  @override
  String get aliasedName => _alias ?? 'medicines_table';
  @override
  String get actualTableName => 'medicines_table';
  @override
  VerificationContext validateIntegrity(Insertable<MedicinesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image'], _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('dose')) {
      context.handle(
          _doseMeta, dose.isAcceptableOrUnknown(data['dose'], _doseMeta));
    } else if (isInserting) {
      context.missing(_doseMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time'], _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicinesTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    return MedicinesTableData.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $MedicinesTableTable createAlias(String alias) {
    return $MedicinesTableTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $MedicinesTableTable _medicinesTable;
  $MedicinesTableTable get medicinesTable =>
      _medicinesTable ??= $MedicinesTableTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [medicinesTable];
}
