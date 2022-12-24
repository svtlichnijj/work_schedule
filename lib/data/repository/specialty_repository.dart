import 'package:sqflite/sqflite.dart';

import 'package:work_schedule/data/models/specialty.dart';
import 'package:work_schedule/data/repository/mixins/foreign_repository.dart';
import 'package:work_schedule/data/repository/repository.dart';

class SpecialtyRepository extends Repository with ForeignRepository {
  @override
  String get tableName => 'specialties_table';

  @override
  String get joinAlias => 'specialty';

  static const columnId = 'id';
  static const columnName = 'name';

  static final SpecialtyRepository _instance = SpecialtyRepository._();

  factory SpecialtyRepository() {
    return _instance;
  }

  SpecialtyRepository._();

  List<Map<String, dynamic>> getSpecialtiesMap() {
    return [
      { 'specialty.id': 1, 'specialty.name': 'Beautician' },
      { 'specialty.id': 2, 'specialty.name': 'Manicure' },
      { 'specialty.id': 3, 'specialty.name': 'Masseur' },
    ];
  }

  @override
  Future onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL
      )
    ''');

    await fillSpecialities(databaseIn: db);
  }

  Future<List<List<Object?>>> fillSpecialities({ Database? databaseIn }) async {
    Set<Specialty> specialties = {};
    getSpecialtiesMap().forEach((Map<String, dynamic> employeeMap) {
      specialties.add(Specialty.fromMapWithAlias(employeeMap));
    });

    List<List<Object?>> result = await insertBatchSpecialties(specialties, databaseIn: databaseIn);

    return result;
  }

  Future<int> insertSpecialty(Specialty specialty) async {
    Database db = await _instance.database;
    return await db.insert(tableName, { 'name': specialty.name});
  }

  Future<List<List<Object?>>> insertBatchSpecialties(Set<Specialty> specialties, { Database? databaseIn }) async {
    Database db = databaseIn ?? await _instance.database;
    List<List<Object?>> results = [];
    db.transaction((txn) async {
      Batch batch = txn.batch();
      for (Specialty specialty in specialties) {
        batch.insert(tableName, specialty.toMap());
      }

      results.add(await batch.commit(noResult: false));
    });

    return results;
  }

  Future<List<Specialty>> specialties({ limitIn = 100 }) async {
    Database db = await _instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName, limit: limitIn);

    return List.generate(maps.length, (i) => Specialty.fromMap(maps[i]));
  }

  Future<Specialty> specialty(int specialtyId) async {
    Database db = await _instance.database;
    final List<Map<String, dynamic>> map = await db.query(
      tableName,
      where: '$columnId = ?',
      whereArgs: [specialtyId],
    );

    return Specialty.fromMap(map.last);
  }

  Future<int> updateSpecialty(Specialty specialty) async {
    Database db = await _instance.database;
    Map<String, dynamic> specialtyMap = specialty.toMap();

    return await db.update(
      tableName,
      specialtyMap,
      where: '$columnId = ?',
      whereArgs: [specialtyMap['id']],
    );
  }

  Future<Specialty> upsertSpecialty(Specialty specialty) async {
    Database db = await _instance.database;
    Map<String, dynamic> specialtyMap = specialty.toMap();
    int? count = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $tableName WHERE name = ?',
        [specialty.name]
    ));

    if (count == 0) {
      specialtyMap[SpecialtyRepository.columnId] = await db.insert(tableName, specialtyMap);
      specialty = Specialty.fromMap(specialtyMap);
    } else {
      await db.update(
          tableName,
          specialtyMap,
          where: 'id = ?',
          whereArgs: [specialty.id]
      );
    }

    return specialty;
  }

  Future<int> deleteSpecialty(int id) async {
    Database db = await _instance.database;
    return await db.delete(
        tableName,
        where: '$columnId = ?',
        whereArgs: [id]
    );
  }
}
