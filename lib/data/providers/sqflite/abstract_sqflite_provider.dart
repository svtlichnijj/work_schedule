import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class AbstractSqfliteProvider {
  String get databaseName;

  int get databaseVersion => 1;

  static late Database _database;

  String get tableName;

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
      onCreate: onCreate,
      onUpgrade: onUpgrade,
      onOpen: onOpen,
    );
  }

  Future onConfigure(Database db) async => {};

  Future onCreate(Database db, int version);

  Future onUpgrade(Database db, int oldVersion, int newVersion) async => {};

  FutureOr<void> onOpen(Database db) async => {};

  void destructor() {
    _database.close();
  }
}
