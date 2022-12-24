import 'package:sqflite/sqflite.dart';

import 'package:work_schedule/data/models/specialty.dart';
import 'package:work_schedule/data/repository/mixins/foreign_repository.dart';
import 'package:work_schedule/data/repository/repository.dart';

class SpecialtyRepository extends Repository with ForeignRepository {
  // @override
  // String get databaseName => 'specialties.db';
  // @override
  // int get databaseVersion => 2;
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
  // ToDo temporarily
  List<Specialty> getSpecialties() {
    return [
      Specialty(name: 'Beautician'),
      Specialty(name: 'Manicure'),
      Specialty(name: 'Masseur'),
      // Specialty(id: 1, name: 'Beautician'),
      // Specialty(id: 2, name: 'Manicure'),
      // Specialty(id: 3, name: 'Masseur'),
      // Specialty({'id': 1, 'name': 'Beautician'}),
      // Specialty({'id': 2, 'name': 'Manicure'}),
      // Specialty({'id': 3, 'name': 'Masseur'}),
    ];
  }
  // @override
  // Future onConfigure(Database db) async {
  //   print('--onConfigure Specialty');
  //   // ForeignRepository foreignRepository = onConfigure(db) as ForeignRepository;
  //   // foreignRepository.onConfigure(db);
  //   await db.execute('PRAGMA foreign_keys = ON');
  //   // // // ToDo is need?
  //   // await onCreate(db, databaseVersion);
  //   // List<List<Object?>> result = await fillSpecialities();
  //   // print('result');
  //   // print(result);
  //   print('--onCreated Specialty');
  // }

  @override
  Future onCreate(Database db, int version) async {
    print('--onCreate Specialty');
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL
      )
    ''');
    print('...onCreated Specialty...');

    // fillSpecialities();
    List<List<Object?>> result = await fillSpecialities(databaseIn: db);
    // List<List<Object?>> result = await fillSpecialities();
    print('result fillSpecialities');
    print(result);
    print('...onCreated Specialty--');
  }

  @override
  Future onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('--onUpgrade Specialty');
    // fillSpecialities();
    print('...onUpgrade Specialty--');
  }

  Future<List<List<Object?>>> fillSpecialities({ Database? databaseIn }) async {
    // Specialty specialty;
    // List<Map<String, dynamic>> specialtiesMap = getSpecialtiesMap();
    //
    // print('getSpecialtiesMap(); for () { }');
    // for (int i = 0; i < specialtiesMap.length; i++) {
    // // for (Map<String, dynamic> specialtyMap in specialtiesMap) {
    //   specialty = Specialty.fromMapWithAlias(specialtiesMap[i]);
    //   // specialty = Specialty.fromMapWithAlias(specialtyMap);
    //   print(specialty);
    //   await insertSpecialty(specialty);
    //   await Future<void>.delayed(const Duration(milliseconds: 5000));
    // }

    print('getSpecialtiesMap().forEach');
    Set<Specialty> specialties = {};
    getSpecialtiesMap().forEach((Map<String, dynamic> employeeMap) {
      specialties.add(Specialty.fromMapWithAlias(employeeMap));
    });

    print('specialties to insertBatch');
    print(specialties);
    List<List<Object?>> result = await insertBatchSpecialties(specialties, databaseIn: databaseIn);
    print('result insertBatchSpecialties');
    print(result);

    // print('getSpecialties().forEach');
    // getSpecialtiesMap().forEach((Map<String, dynamic> specialtyMap) async {
    //   specialty = Specialty.fromMapWithAlias(specialtyMap);
    //   print(specialty);
    //   await insertSpecialty(specialty);
    //   await Future<void>.delayed(const Duration(milliseconds: 5000));
    // });
    // getSpecialties().forEach((Specialty specialty) {
    //   print('getSpecialties().forEach');
    //   print(specialty.name);
    //   insertSpecialty(specialty);
    // });
    return result;
  }

  // In ForeignRepository
  // @override
  // Future onConfigure(Database db) async {
  //   // Future _onConfigure(Database db) async {
  //   // static Future _onConfigure(Database db) async {
  //   print('--IN _onConfigure() Specialty--');
  //   await db.execute('PRAGMA foreign_keys = ON');
  // }

  Future<int> insertSpecialty(Specialty specialty) async {
    Database db = await _instance.database;
    return await db.insert(tableName, { 'name': specialty.name });
  }

  Future<List<List<Object?>>> insertBatchSpecialties(Set<Specialty> specialties, { Database? databaseIn }) async {
    print('--insertBatchSpecialties');
    Database db = databaseIn ?? await _instance.database;
    print('db');
    print(db);
    List<List<Object?>> results = [];
    print('results b');
    print(results);
    db.transaction((txn) async {
      // print('txn');
      // print(txn);
      Batch batch = txn.batch();
      // print('batch');
      // print(batch);
      for (Specialty specialty in specialties) {
        print('specialty.toMap()');
        print(specialty.toMap());
        batch.insert(tableName, specialty.toMap());
      }
      results.add(await batch.commit(noResult: false));
      print('results...');
      print(results);
    });

    return results;
  }

  Future<List<Specialty>> specialties({ limitIn = 100 }) async {
    Database db = await _instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName, limit: limitIn);

    // return List.generate(maps.length, (i) => Specialty(maps[i]));
    return List.generate(maps.length, (i) => Specialty.fromMap(maps[i]));
  }

  Future<Specialty> specialty(int specialtyId) async {
    Database db = await _instance.database;
    final List<Map<String, dynamic>> map = await db.query(
      tableName,
      where: '$columnId = ?',
      whereArgs: [specialtyId],
    );

    // return Specialty(map.last);
    return Specialty.fromMap(map.last);
  }

  Future<int> updateSpecialty(Specialty specialty) async {
    Database db = await _instance.database;
    Map<String, dynamic> specialtyMap = specialty.toMap();
    // OR
    // int id = specialty.toMap()['id'];
    return await db.update(
      tableName,
      // specialty.toMap(),
      specialtyMap,
      where: '$columnId = ?',
      whereArgs: [specialtyMap['id']],
      // OR
      // whereArgs: [specialty.id],
      // OR
      // whereArgs: [id],
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
      print('specialtyMap b');
      print(specialtyMap);
      specialtyMap[SpecialtyRepository.columnId] = await db.insert(tableName, specialtyMap);
      print('specialtyMap a');
      print(specialtyMap);
      print('specialty b');
      print(specialty);
      specialty = Specialty.fromMap(specialtyMap);
      print('specialtyMap a');
      print(specialtyMap);
      // specialty = await db.insert(tableName, specialtyMap);
    } else {
      await db.update(
          tableName,
          // 'specialty',
          specialtyMap,
          // specialty.toMap(),
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