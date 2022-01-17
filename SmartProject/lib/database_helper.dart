import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'alarm.dart';

class DBProvider {

  static late Database database;

  static Future<Database> initDB() async {
    return openDatabase(
        join(await getDatabasesPath(), "SmartAlarms.db"),
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Alarms ("
            "id INTEGER PRIMARY KEY,"
            "time TEXT,"
            "enabled INTEGER"
            ")"
          );
    });
  }

  static Future<List<Alarm>> retrieveAlarms() async {
    final List<Map<String, Object?>> queryResult = await database.query('Alarms');
    return queryResult.map((e) => Alarm.fromMap(e)).toList();
  }

  static Future<void> insertAlarm(Alarm a) async {
    await database.insert(
      'Alarms',
      a.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateAlarm(Alarm a) async {
    await database.update(
      'Alarms',
      a.toMap(),
      where: 'id = ?',
      whereArgs: [a.id],
    );
  }

  static Future<void> deleteAlarm(Alarm a) async {
    await database.delete(
      'Alarms',
      where: 'id = ?',
      whereArgs: [a.id],
    );
  }

}