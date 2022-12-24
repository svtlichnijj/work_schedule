import 'package:sqflite/sqflite.dart';

import 'package:work_schedule/data/repository/repository.dart';

class ServiceRepository extends Repository {
  @override
  String get databaseName => 'services.db';

  @override
  get tableName => 'services_table';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnDuration = 'duration';

  static final ServiceRepository _instance = ServiceRepository._();

  factory ServiceRepository() {
    return _instance;
  }

  ServiceRepository._();

  @override
  Future onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL
        $columnDuration INT UNSIGNED NOT NULL DEFAULT '0'
      )
    ''');
  }
}
