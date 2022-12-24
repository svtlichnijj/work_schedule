import 'package:sqflite/sqflite.dart';

mixin ForeignRepository {
  String get joinAlias => 'alias';
  String get foreignKeyColumnName => 'alias_id';
  String get innerKeyColumnName => 'id';

  Future onConfigure(Database db) async {
    print('--onConfigure $joinAlias');
    // Future _onConfigure(Database db) async {
    // static Future _onConfigure(Database db) async {
    // print('--IN _onConfigure(--$joinAlias');
    await db.execute('PRAGMA foreign_keys = ON');
    print('..onConfigure $joinAlias--');
  }
}