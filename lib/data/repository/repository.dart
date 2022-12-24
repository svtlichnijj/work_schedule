import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:work_schedule/data/repository/abstract_repository.dart';

abstract class Repository implements AbstractRepository {
  @override
  String get databaseName => 'work_schedule.db';

  @override
  int get databaseVersion => 1;

  static late Database _database;

  String get tableName;

  @override
  Future<Database> get database async {
    try {
      if (_database != null) return _database;
    } catch (_) {
      _database = await _initDatabase(databaseName);
    }

    return _database;
  }

  _initDatabase(String filePath) async {
    String path = join(await getDatabasesPath(), filePath);

    return await openDatabase(
      path,
      version: databaseVersion,
      onConfigure: onConfigure,
      onUpgrade: onUpgrade,
      onCreate: onCreate,
      onOpen: onOpen,
    );
  }

  Future onConfigure(Database db) async => {};

  Future onUpgrade(Database db, int oldVersion, int newVersion) async => {};

  FutureOr<void> onOpen(Database db) async => {};

  void destructor() {
    _database.close();
  }
}
