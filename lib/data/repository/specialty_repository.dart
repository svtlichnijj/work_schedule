import 'package:sqflite/sqflite.dart';

import 'package:work_schedule/data/providers/sqflite/mixins/soft_delete_repository.dart';
import 'package:work_schedule/data/providers/sqflite/work_schedule_sqflite_dao.dart';
import 'package:work_schedule/data/models/specialty.dart';

class SpecialtyRepository extends WorkScheduleSqfliteDao {
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
      { '$joinAlias.$columnId': 1, '$joinAlias.$columnName': 'Beautician' },
      { '$joinAlias.$columnId': 2, '$joinAlias.$columnName': 'Manicure' },
      { '$joinAlias.$columnId': 3, '$joinAlias.$columnName': 'Masseur' },
    ];
  }

  Future createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $rowCreateSoftDeleteColumn
      );
    ''');

    await fillSpecialties(databaseIn: db);
  }

  Future<List<List<Object?>>> fillSpecialties({ Database? databaseIn }) async {
    Set<Specialty> specialties = {};
    getSpecialtiesMap().forEach((Map<String, dynamic> employeeMap) {
      specialties.add(Specialty.fromMap(employeeMap));
    });
    List<List<Object?>> result = await insertBatchSpecialties(specialties, databaseIn: databaseIn);

    return result;
  }

  Future<int> insertSpecialty(Specialty specialty) async {
    Database db = await _instance.database;
    return await db.insert(tableName, specialty.toMap());
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

  Future<List<Specialty>> specialties({ String? nameLike, int? limitIn = 100, String? orderByIn = 'id DESC' }) async {
    Database db = await _instance.database;
    final List<Map<String, dynamic>> result;

    if (nameLike != null && nameLike.isNotEmpty) {
      result = await db.query(
        tableName,
        where: '${SoftDeleteRepository.onWhereNotDeleted()} AND $columnName LIKE ?',
        whereArgs: ["%$nameLike%"],
        limit: limitIn,
        orderBy: orderByIn,
      );
    } else {
      result = await db.query(
        tableName,
        where: SoftDeleteRepository.onWhereNotDeleted(),
        limit: limitIn,
        orderBy: orderByIn,
      );
    }

    return List.generate(result.length, (i) => Specialty.fromMap(result[i]));
  }

  Future<Specialty> getSpecialty(int specialtyId) async {
    Database db = await _instance.database;
    final List<Map<String, dynamic>> map = await db.query(
      tableName,
      where: '$columnId = ? AND ${SoftDeleteRepository.onWhereNotDeleted()}',
      whereArgs: [specialtyId],
    );

    return Specialty.fromMap(map.last);
  }

  Future<Specialty> upsertSpecialty(Specialty specialty) async {
    Database db = await _instance.database;
    Map<String, dynamic> specialtyMap = specialty.toMap();
    int? count = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $tableName WHERE id = ?',
        [specialty.id],
    ));

    if (count == 0) {
      specialtyMap[SpecialtyRepository.columnId] = await db.insert(tableName, specialtyMap);
      specialty = Specialty.fromMap(specialtyMap);
    } else {
      await db.update(
          tableName,
          specialtyMap,
          where: 'id = ?',
          whereArgs: [specialty.id],
      );
    }

    return specialty;
  }

  Future<int> updateSpecialty(Specialty specialty) async {
    Database db = await _instance.database;

    return await db.update(
      tableName,
      specialty.toMap(),
      where: '$columnId = ?',
      whereArgs: [specialty.id],
    );
  }

  Future<int> softDeleteSpecialty(int specialtyId) async {
    Database db = await _instance.database;
    return await db.update(
        tableName,
        { SoftDeleteRepository.columnDeletedAt: DateTime.now().millisecondsSinceEpoch },
        where: '$columnId = ?',
        whereArgs: [specialtyId]
    );
  }

  Future<int> deleteSpecialty(int specialtyId) async {
    Database db = await _instance.database;
    return await db.delete(
        tableName,
        where: '$columnId = ?',
        whereArgs: [specialtyId]
    );
  }
}
