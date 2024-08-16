import 'package:path/path.dart' as path1;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MedicineReminder {
  final int? id;
  final String name;
  final String image;
  final String dose;
  final String time;
  final int isEveryDay;

  const MedicineReminder({
    this.id,
    required this.name,
    required this.image,
    required this.dose,
    required this.time,
    required this.isEveryDay,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'dose': dose,
      'time': time,
      'isEveryDay': isEveryDay
    };
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = path1.join(documentsDirectory.path, 'MedicineReminder.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  void _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ReminderData (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        dose TEXT,
        image TEXT,
        time TEXT,
        isEveryDay INTEGER
      )
    ''');
  }

  Future<int> insertReminderDetails(MedicineReminder data) async {
    Database db = await database;
    return await db.insert('ReminderData', data.toMap());
  }

  Future<int> deleteMedicineReminder(int id) async {
    Database db = await database;
    return await db.delete('ReminderData', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getDataFromTable() async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query("ReminderData");
    return results;
  }

  Future<int> deleteData(int id, {required String tableName}) async {
    Database db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
