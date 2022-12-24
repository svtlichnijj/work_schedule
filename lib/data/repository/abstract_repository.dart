import 'package:sqflite/sqflite.dart';

abstract class AbstractRepository {
  String get databaseName;
  int get databaseVersion;

  Future<Database> get database;

  Future onCreate(Database db, int version);
}