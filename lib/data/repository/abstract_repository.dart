import 'package:sqflite/sqflite.dart';

abstract class AbstractRepository {
  String get databaseName;
  int get databaseVersion;

  Future<Database> get database;

  // // this opens the database (and creates it if it doesn't exist)
  // _initDatabase(String filePath);
  //
  Future onCreate(Database db, int version);
  // Future _onCreate(Database db, int version);
}