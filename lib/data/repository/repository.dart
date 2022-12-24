import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:work_schedule/data/repository/abstract_repository.dart';

// abstract class Repository extends AbstractRepository {
abstract class Repository implements AbstractRepository {
// class Repository implements AbstractRepository {
// class Repository {
// abstract class Repository {
  @override
  String get databaseName => 'work_schedule.db';
//   late final String _databaseName;
  // static const _databaseName;
  // late final int _databaseVersion = 1;
  // static const _databaseVersion = 1;
  @override
  int get databaseVersion => 1;
  // only have a single app-wide reference to the database
  static late Database _database;

  String get tableName;

  // Repository._privateConstructor();
  //
  // static final Repository instance = Repository._privateConstructor();

  @override
  Future<Database> get database async {
    // print('--IN get database --$tableName');
    try {
      // print('_database b');
      // print(_database);
      // if (_database != null) return _database;
      if (_database == null) {}
    } catch (_) {
      // print('Exception');
      // lazily instantiate the db the first time it is accessed
      _database = await _initDatabase(databaseName);
    }

    // print('_database.getVersion()');
    // print(await _database.getVersion());
    // print('_database a');
    // print(_database);
    // OR
    // _database ??= _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase(String filePath) async {
    // print('--IN _initDatabase for $filePath');
    String path = join(await getDatabasesPath(), filePath);
    // Database database;
    // database = await openDatabase(
    // print('databaseVersion');
    // print(databaseVersion);
    return await openDatabase(
      path,
      version: databaseVersion,
      onConfigure: onConfigure,
      // onConfigure: _onConfigure,
      onUpgrade: onUpgrade,
      onCreate: onCreate,
      // onCreate: _onCreate,
      onOpen: onOpen,
      singleInstance: true,
    );
    //
    // return database;
  }

  Future onConfigure(Database db) async => {};
  // Future _onConfigure(Database db);
  // Future onCreate(Database db, int version);
  // Future _onCreate(Database db, int version);

  Future onUpgrade(Database db, int oldVersion, int newVersion) async => {};
  FutureOr<void> onOpen(Database db) async => {};

  void destructor(){
    _database.close();
  }
}