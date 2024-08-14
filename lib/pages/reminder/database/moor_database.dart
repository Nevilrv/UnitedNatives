import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
part 'moor_database.g.dart';

class MedicinesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 5, max: 50)();
  TextColumn get image => text().nullable()();
  TextColumn get dose => text().nullable()();
  TextColumn get time => text().nullable()();
}

@DriftDatabase(tables: [MedicinesTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(NativeDatabase(File('db.sqlite'), logStatements: true));

  @override
  int get schemaVersion => 1;

  Future<List<MedicinesTableData>> getAllMedicines() =>
      select(medicinesTable).get();
  Future insertMedicine(MedicinesTableData medicine) =>
      into(medicinesTable).insert(medicine);
  Future updateMedicine(MedicinesTableData medicine) =>
      update(medicinesTable).replace(medicine);
  Future deleteMedicine(MedicinesTableData medicine) =>
      delete(medicinesTable).delete(medicine);
}
