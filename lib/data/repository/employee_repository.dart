import 'package:sqflite/sqflite.dart';

import 'package:work_schedule/data/models/employee.dart';
import 'package:work_schedule/data/providers/sqflite/mixins/soft_delete_repository.dart';
import 'package:work_schedule/data/providers/sqflite/work_schedule_sqflite_dao.dart';
import 'package:work_schedule/data/repository/specialty_repository.dart';

class EmployeeRepository extends WorkScheduleSqfliteDao {
  @override
  String get tableName => 'employees_table';

  @override
  String get joinAlias => 'employee';

  @override
  String get foreignKeyColumnName => columnSpecialtyId;

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnSpecialtyId = 'specialty_id';

  static final EmployeeRepository _instance = EmployeeRepository._();

  factory EmployeeRepository() {
    return _instance;
  }

  EmployeeRepository._();

  List<Map<String, dynamic>> getEmployeesMap() {
    return [
      {
        'employee.id': 1,
        'employee.name': 'Ann',
        'employee.specialty_id': 1,
        'specialty.id': 1,
        'specialty.name': 'Beautician'
      },
      {
        'employee.id': 2,
        'employee.name': 'Lisa',
        'employee.specialty_id': 2,
        'specialty.id': 2,
        'specialty.name': 'Manicure'
      },
      {
        'employee.id': 3,
        'employee.name': 'Sony',
        'employee.specialty_id': 3,
        'specialty.id': 3,
        'specialty.name': 'Masseur'
      },
      {
        'employee.id': 4,
        'employee.name': 'Ann2',
        'employee.specialty_id': 3,
        'specialty.id': 3,
        'specialty.name': 'Masseur'
      },
      {
        'employee.id': 5,
        'employee.name': 'Lisa2',
        'employee.specialty_id': 1,
        'specialty.id': 1,
        'specialty.name': 'Beautician'
      },
      {
        'employee.id': 6,
        'employee.name': 'Sony2',
        'employee.specialty_id': 2,
        'specialty.id': 2,
        'specialty.name': 'Manicure'
      },
      {
        'employee.id': 7,
        'employee.name': 'Ann3',
        'employee.specialty_id': 2,
        'specialty.id': 2,
        'specialty.name': 'Manicure'
      },
      {
        'employee.id': 8,
        'employee.name': 'Lisa3',
        'employee.specialty_id': 3,
        'specialty.id': 3,
        'specialty.name': 'Masseur'
      },
      {
        'employee.id': 9,
        'employee.name': 'Sony3',
        'employee.specialty_id': 1,
        'specialty.id': 1,
        'specialty.name': 'Beautician'
      },
    ];
  }

  Future createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnSpecialtyId INTEGER NOT NULL,
        $rowCreateSoftDeleteColumn,
        FOREIGN KEY ($columnSpecialtyId) REFERENCES ${SpecialtyRepository().tableName} (${SpecialtyRepository.columnId}) 
          ON DELETE NO ACTION ON UPDATE NO ACTION
      );
    ''');

    await fillEmployees(databaseIn: db);
  }

  Future<List<List<Object?>>> fillEmployees({ Database? databaseIn }) async {
    Set<Employee> employees = {};
    getEmployeesMap().forEach((Map<String, dynamic> employeeMap) {
      employees.add(Employee.fromMapWithSpecialty(employeeMap));
    });
    List<List<Object?>> result = await insertBatchEmployees(employees, databaseIn: databaseIn);

    return result;
  }

  Future<int> insertEmployee(Employee employee) async {
    Database db = await _instance.database;
    return await db.insert(tableName, employee.toMap());
  }

  Future<List<List<Object?>>> insertBatchEmployees(Set<Employee> employees, { Database? databaseIn }) async {
    Database db = databaseIn ?? await _instance.database;
    List<List<Object?>> results = [];
    db.transaction((txn) async {
      Batch batch = txn.batch();
      for (Employee employee in employees) {
        batch.insert(tableName, employee.toMap());
      }

      results.add(await batch.commit(noResult: false));
    });

    return results;
  }

  Future<List<Employee>> employees({ String? nameLike, int? limitIn = 100, String? orderByIn = 'id DESC' }) async {
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

    return List.generate(result.length, (i) => Employee.fromMap(result[i]));
  }

  String _querySelectWithSpecialties() {
    SpecialtyRepository specialtyRepository = SpecialtyRepository();

    return '''
      SELECT 
        $joinAlias.id AS '$joinAlias.id',
        $joinAlias.name AS '$joinAlias.name',
        $joinAlias.specialty_id AS '$joinAlias.specialty_id',
        ${specialtyRepository.joinAlias}.id AS '${specialtyRepository.joinAlias}.id',
        ${specialtyRepository.joinAlias}.name AS '${specialtyRepository.joinAlias}.name'
        FROM $tableName AS $joinAlias
      INNER JOIN ${specialtyRepository.tableName} as ${specialtyRepository.joinAlias}
        ON $joinAlias.$foreignKeyColumnName = ${specialtyRepository.joinAlias}.${specialtyRepository.innerKeyColumnName}
    ''';
  }

  Future<List<Employee>> fetchEmployeesWithSpecialties() async {
    Database db = await _instance.database;
    String rawQuery = '''
      ${_querySelectWithSpecialties()}
      WHERE ${SoftDeleteRepository.onWhereNotDeleted(alias: joinAlias)}
    ''';
    final List<Map<String, dynamic>> maps = await db.rawQuery(rawQuery);

    return List.generate(maps.length, (i) => Employee.fromMapWithSpecialty(maps[i]));
  }

  Future<Employee> getEmployee(int employeeId) async {
    Database db = await _instance.database;
    final List<Map<String, dynamic>> map = await db.query(
      tableName,
      where: '$columnId = ? AND ${SoftDeleteRepository.onWhereNotDeleted()}',
      whereArgs: [employeeId],
    );

    return Employee.fromMap(map.last);
  }

  Future<Employee> employeeWithSpecialty(int employeeId) async {
    Database db = await _instance.database;
    String rawQuery = '''
      ${_querySelectWithSpecialties()}
      WHERE $joinAlias.$columnId = ? 
        AND ${SoftDeleteRepository.onWhereNotDeleted(alias: joinAlias)}
    ''';
    final List<Map<String, dynamic>> map = await db.rawQuery(rawQuery, [employeeId]);

    return Employee.fromMapWithSpecialty(map.last);
  }

  Future<int?> employeesCount() async {
    Database db = await _instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  Future<int> updateEmployee(Employee employee) async {
    Database db = await _instance.database;

    return await db.update(
      tableName,
      employee.toMap(),
      where: '$columnId = ?',
      whereArgs: [employee.id],
    );
  }

  Future<int> softDeleteEmployee(int employeeId) async {
    Database db = await _instance.database;
    return await db.update(
        tableName,
        { SoftDeleteRepository.columnDeletedAt: DateTime.now().millisecondsSinceEpoch },
        where: '$columnId = ?',
        whereArgs: [employeeId]
    );
  }

  Future<int> deleteEmployee(int employeeId) async {
    Database db = await _instance.database;
    return await db.delete(
        tableName,
        where: '$columnId = ?',
        whereArgs: [employeeId]
    );
  }
}
