import 'package:sqflite/sqflite.dart';

mixin ForeignRepository {
  String get joinAlias => 'alias';
  String get foreignKeyColumnName => 'alias_id';
  String get innerKeyColumnName => 'id';

  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }
}