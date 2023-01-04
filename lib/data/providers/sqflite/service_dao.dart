import 'package:sqflite/sqflite.dart';

import 'package:work_schedule/data/providers/sqflite/mixins/soft_delete_repository.dart';
import 'package:work_schedule/data/providers/sqflite/work_schedule_sqflite_dao.dart';
import 'package:work_schedule/data/models/service.dart';
import 'package:work_schedule/data/repository/service_repository.dart';

class ServiceDao extends WorkScheduleSqfliteDao {
  @override
  String get tableName => 'services_table';

  static final ServiceDao _instance = ServiceDao._();

  factory ServiceDao() {
    return _instance;
  }

  ServiceDao._();

  List<Map<String, dynamic>> getServicesMap() {
    return [
      {
        ServiceRepository.columnId: 1,
        ServiceRepository.columnName: 'Hour',
        ServiceRepository.columnDuration: 3600
      },
      {
        ServiceRepository.columnId: 2,
        ServiceRepository.columnName: 'Half-hour',
        ServiceRepository.columnDuration: 1800
      },
      {
        ServiceRepository.columnId: 3,
        ServiceRepository.columnName: 'Three-hour',
        ServiceRepository.columnDuration: 10800
      },
    ];
  }

  Future createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        ${ServiceRepository.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${ServiceRepository.columnName} TEXT NOT NULL,
        ${ServiceRepository.columnDuration} INT UNSIGNED NOT NULL DEFAULT '0',
        $rowCreateSoftDeleteColumn
      );
    ''');

    await fillServices(databaseIn: db);
  }

  Future<List<List<Object?>>> fillServices({ Database? databaseIn }) async {
    Set<Service> services = {};
    getServicesMap().forEach((Map<String, dynamic> employeeMap) {
      services.add(Service.fromMap(employeeMap));
    });
    List<List<Object?>> result = await insertBatchServices(services, databaseIn: databaseIn);

    return result;
  }

  Future<int> createService(Service service) async {
    Database db = await _instance.database;
    return await db.insert(tableName, service.toMap());
  }

  Future<List<List<Object?>>> insertBatchServices(Set<Service> services, { Database? databaseIn }) async {
    Database db = databaseIn ?? await _instance.database;
    List<List<Object?>> results = [];
    db.transaction((txn) async {
      Batch batch = txn.batch();
      for (Service service in services) {
        batch.insert(tableName, service.toMap());
      }

      results.add(await batch.commit(noResult: false));
    });

    return results;
  }

  Future<List<Service>> getServices({ String? nameLike, int? limitIn = 100, String? orderByIn = 'id DESC' }) async {
    Database db = await _instance.database;
    final List<Map<String, dynamic>> result;

    if (nameLike != null && nameLike.isNotEmpty) {
      result = await db.query(
        tableName,
        where: '${SoftDeleteRepository.onWhereNotDeleted()} AND ${ServiceRepository.columnName} LIKE ?',
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

    return List.generate(result.length, (i) => Service.fromMap(result[i]));
  }

  Future<Service> getService(int serviceId) async {
    Database db = await _instance.database;
    final List<Map<String, dynamic>> map = await db.query(
      tableName,
      where: '${ServiceRepository.columnId} = ? AND ${SoftDeleteRepository.onWhereNotDeleted()}',
      whereArgs: [serviceId],
    );

    return Service.fromMap(map.last);
  }

  Future<int> updateService(Service service) async {
    final db = await _instance.database;

    var result = await db.update(
      tableName, service.toMap(),
      where: 'id = ?',
      whereArgs: [service.id],
    );

    return result;
  }

  Future<int> softDeleteService(int serviceId) async {
    Database db = await _instance.database;
    return await db.update(
        tableName,
        { SoftDeleteRepository.columnDeletedAt: DateTime.now().millisecondsSinceEpoch },
        where: '${ServiceRepository.columnId} = ?',
        whereArgs: [serviceId]
    );
  }

  Future<int> deleteService(int serviceId) async {
    Database db = await _instance.database;
    return await db.delete(
        tableName,
        where: '${ServiceRepository.columnId} = ?',
        whereArgs: [serviceId]
    );
  }
}
