// import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

// import 'package:work_schedule/data/local/employee_data.dart';
import 'package:work_schedule/data/models/employee.dart';
import 'package:work_schedule/data/models/specialty.dart';
import 'package:work_schedule/data/repository/mixins/foreign_repository.dart';
import 'package:work_schedule/data/repository/mixins/soft_delete_repository.dart';
import 'package:work_schedule/data/repository/repository.dart';
import 'package:work_schedule/data/repository/specialty_repository.dart';

// class EmployeeRepository extends StatelessWidget {
// class EmployeeRepository implements Repository {
class EmployeeRepository extends Repository with ForeignRepository, SoftDeleteRepository {
  // @override
  // String get databaseName => 'employees.db';
  // static const _databaseName = 'employees.db';
  // @override
  // int get databaseVersion => 2;
  // static const _databaseVersion = 1;

  @override
  String get tableName => 'employees_table';
  // static const table = 'employees_table';

  @override
  String get joinAlias => 'employee';
  @override
  String get foreignKeyColumnName => columnSpecialtyId;

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnSpecialtyId = 'specialty_id';

  // OR start ---vvv---
  static final EmployeeRepository _instance = EmployeeRepository._privateConstructor();

  factory EmployeeRepository() {
    return _instance;
  }

  // For FOREIGN KEY
  EmployeeRepository._privateConstructor();
  // OR ------
  // static EmployeeRepository? _instance;
  //
  // EmployeeRepository._() {
  //   // initialization and stuff
  // }
  //
  // factory EmployeeRepository() {
  //   _instance ??= EmployeeRepository._();
  //   return _instance!;
  // }
  // OR end ---^^^---

  final SpecialtyRepository _specialtyRepository = SpecialtyRepository();
  // late SpecialtyRepository _specialtyRepository;

  // // only have a single app-wide reference to the database
  // static late Database _database;

  // Future<Database> get database async {
  //   try {
  //     print('--IN--');
  //     if (_database != null) return _database;
  //   } catch (_) {
  //     print('Exception');
  //     // lazily instantiate the db the first time it is accessed
  //     _database = await _initDatabase(_databaseName);
  //   }
  //
  //   print('_database');
  //   print(_database);
  //   return _database;
  // }


  // final Future<Database> _database;

  // ToDo temporarily
  List<Map<String, dynamic>> getEmployeesMap() {
    return [
      { 'employee.id': 1, 'employee.name': 'Ann', 'employee.specialty_id': 1, 'specialty.id': 1, 'specialty.name': 'Beautician' },
      { 'employee.id': 2, 'employee.name': 'Lisa', 'employee.specialty_id': 2, 'specialty.id': 2, 'specialty.name': 'Manicure' },
      { 'employee.id': 3, 'employee.name': 'Sony', 'employee.specialty_id': 3, 'specialty.id': 3, 'specialty.name': 'Masseur' },
      { 'employee.id': 4, 'employee.name': 'Ann2', 'employee.specialty_id': 3, 'specialty.id': 3, 'specialty.name': 'Masseur' },
      { 'employee.id': 5, 'employee.name': 'Lisa2', 'employee.specialty_id': 1, 'specialty.id': 1, 'specialty.name': 'Beautician' },
      { 'employee.id': 6, 'employee.name': 'Sony2', 'employee.specialty_id': 2, 'specialty.id': 2, 'specialty.name': 'Manicure' },
      { 'employee.id': 7, 'employee.name': 'Ann3', 'employee.specialty_id': 2, 'specialty.id': 2, 'specialty.name': 'Manicure' },
      { 'employee.id': 8, 'employee.name': 'Lisa3', 'employee.specialty_id': 3, 'specialty.id': 3, 'specialty.name': 'Masseur' },
      { 'employee.id': 9, 'employee.name': 'Sony3', 'employee.specialty_id': 1, 'specialty.id': 1, 'specialty.name': 'Beautician' },
    ];
  }
  // ToDo temporarily
  List<Employee> getEmployees() {
    return [
      // Employee(id: 1, name: 'Ann', specialty: 1),
      // Employee(id: 2, name: 'Lisa', specialty: 2),
      // Employee(id: 3, name: 'Sony', specialty: 3),
      // Employee(id: 4, name: 'Ann2', specialty: 3),
      // Employee(id: 5, name: 'Lisa2', specialty: 1),
      // Employee(id: 6, name: 'Sony2', specialty: 2),
      // Employee(id: 7, name: 'Ann3', specialty: 2),
      // Employee(id: 8, name: 'Lisa3', specialty: 3),
      // Employee(id: 9, name: 'Sony3', specialty: 1),
      Employee(name: 'Ann', specialty: Specialty(name: 'Beautician')),
      Employee(name: 'Lisa', specialty: Specialty(name: 'Manicure')),
      Employee(name: 'Sony', specialty: Specialty(name: 'Masseur')),
      Employee(name: 'Ann2', specialty: Specialty(name: 'Masseur')),
      Employee(name: 'Lisa2', specialty: Specialty(name: 'Beautician')),
      Employee(name: 'Sony2', specialty: Specialty(name: 'Manicure')),
      Employee(name: 'Ann3', specialty: Specialty(name: 'Manicure')),
      Employee(name: 'Lisa3', specialty: Specialty(name: 'Masseur')),
      Employee(name: 'Sony3', specialty: Specialty(name: 'Beautician')),
      // Employee(name: 'Ann', _specialtyId: 1),
      // Employee(name: 'Lisa', _specialtyId: 2),
      // Employee(name: 'Sony', _specialtyId: 3),
      // Employee(name: 'Ann2', _specialtyId: 3),
      // Employee(name: 'Lisa2', _specialtyId: 1),
      // Employee(name: 'Sony2', _specialtyId: 2),
      // Employee(name: 'Ann3', _specialtyId: 2),
      // Employee(name: 'Lisa3', _specialtyId: 3),
      // Employee(name: 'Sony3', _specialtyId: 1),
      // Employee(id: 1, name: 'Ann', specialtyId: 1),
      // Employee(id: 2, name: 'Lisa', specialtyId: 2),
      // Employee(id: 3, name: 'Sony', specialtyId: 3),
      // Employee(id: 4, name: 'Ann2', specialtyId: 3),
      // Employee(id: 5, name: 'Lisa2', specialtyId: 1),
      // Employee(id: 6, name: 'Sony2', specialtyId: 2),
      // Employee(id: 7, name: 'Ann3', specialtyId: 2),
      // Employee(id: 8, name: 'Lisa3', specialtyId: 3),
      // Employee(id: 9, name: 'Sony3', specialtyId: 1),
      // Employee(id: 1, name: 'Ann', specialty: Specialty(id: 1, name: 'Beautician')),
      // Employee(id: 2, name: 'Lisa', specialty: Specialty(id: 2, name: 'Manicure')),
      // Employee(id: 3, name: 'Sony', specialty: Specialty(id: 3, name: 'Masseur')),
      // Employee(id: 4, name: 'Ann2', specialty: Specialty(id: 3, name: 'Masseur')),
      // Employee(id: 5, name: 'Lisa2', specialty: Specialty(id: 1, name: 'Beautician')),
      // Employee(id: 6, name: 'Sony2', specialty: Specialty(id: 2, name: 'Manicure')),
      // Employee(id: 7, name: 'Ann3', specialty: Specialty(id: 2, name: 'Manicure')),
      // Employee(id: 8, name: 'Lisa3', specialty: Specialty(id: 3, name: 'Masseur')),
      // Employee(id: 9, name: 'Sony3', specialty: Specialty(id: 1, name: 'Beautician')),
      // Employee({'id': 1, 'name': 'Ann', 'specialty': Specialty({'id': 1, 'name': 'Beautician'})}),
      // Employee({'id': 2, 'name': 'Lisa', 'specialty': Specialty({'id': 2, 'name': 'Manicure'})}),
      // Employee({'id': 3, 'name': 'Sony', 'specialty': Specialty({'id': 3, 'name': 'Masseur'})}),
      // Employee({'id': 4, 'name': 'Ann2', 'specialty': Specialty({'id': 3, 'name': 'Masseur'})}),
      // Employee({'id': 5, 'name': 'Lisa2', 'specialty': Specialty({'id': 1, 'name': 'Beautician'})}),
      // Employee({'id': 6, 'name': 'Sony2', 'specialty': Specialty({'id': 2, 'name': 'Manicure'})}),
      // Employee({'id': 7, 'name': 'Ann3', 'specialty': Specialty({'id': 2, 'name': 'Manicure'})}),
      // Employee({'id': 8, 'name': 'Lisa3', 'specialty': Specialty({'id': 3, 'name': 'Masseur'})}),
      // Employee({'id': 9, 'name': 'Sony3', 'specialty': Specialty({'id': 1, 'name': 'Beautician'})}),
    ];
  }

  // @override
  // Future<Widget> build(BuildContext context) async {
  //   return init();
  // }

  // this opens the database (and creates it if it doesn't exist)
  // _initDatabase(String filePath) async {
  //   String path = join(await getDatabasesPath(), filePath);
  //   Database database;
  //   database = await openDatabase(
  //   // return await openDatabase(
  //     path,
  //     version: _databaseVersion,
  //     onCreate: _onCreate,
  //     onConfigure: _onConfigure,
  //   );
  //
  //   return database;
  // }

  // @override
  // Future onConfigure(Database db) async {
  //   print('--onConfigure Employee');
  //   // ForeignRepository foreignRepository = onConfigure(db) as ForeignRepository;
  //   // foreignRepository.onConfigure(db);
  //   await db.execute('PRAGMA foreign_keys = ON');
  //   // // ToDo is need?
  //   // await _specialtyRepository.onCreate(db, databaseVersion);
  //   // List<List<Object?>> result = await _specialtyRepository.fillSpecialities();
  //   // print('result');
  //   // print(result);
  //   print('...onConfigure Employee--');
  // }

  @override
  // SQL code to create the database table
  Future onCreate(Database db, int version) async {
  // Future _onCreate(Database db, int version) async {
    print('--onCreate Employee');
    // _specialtyRepository = SpecialtyRepository();
    // await db.execute('''DROP TABLE $table''');
    // print('onCreate 2');
    // await db.execute('''TRUNCATE TABLE $table''');
    // print('onCreate 3');
    // ToDo is need?
    await _specialtyRepository.onCreate(db, version);
    // await _specialtyRepository.database;
    print('...onCreated Employee...');

    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnSpecialtyId INTEGER NOT NULL,
        $onCreateRow
        FOREIGN KEY ($columnSpecialtyId) REFERENCES ${_specialtyRepository.tableName} (${SpecialtyRepository.columnId}) 
          ON DELETE NO ACTION ON UPDATE NO ACTION
      )
    ''');
    print('...onCreated Employee...---');

    // await fillEmployees();
    List<List<Object?>> result = await fillEmployees(databaseIn: db);
    // List<List<Object?>> result = await fillEmployees();
    print('result fillEmployees');
    print(result);
    // databaseVersion = () => 2;
    print('...onCreated Employee--');
  }

  @override
  Future onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('--onUpgrade Employee');
    // await _specialtyRepository.fillSpecialities();
    print('...onUpgrade... Employee--');
    // await fillEmployees();
    print('...onUpgrade Employee--');
  }

  Future<List<List<Object?>>> fillEmployees({ Database? databaseIn }) async {
    // Employee employee;
    // List<Map<String, dynamic>> employeesMap = getEmployeesMap();
    //
    // print('getEmployees(); for () { }');
    // for (int i = 0; i < employeesMap.length; i++) {
    // // for (Map<String, dynamic> employeeMap in employeesMap) {
    //   employee = Employee.fromMapWithSpecialty(employeesMap[i]);
    //   // employee = Employee.fromMapWithSpecialty(employeeMap);
    //   print(employee);
    //   await insertEmployee(employee);
    //   await Future<void>.delayed(const Duration(milliseconds: 2500));
    // }

    print('getEmployeesMap().forEach');
    Set<Employee> employees = {};
    getEmployeesMap().forEach((Map<String, dynamic> employeeMap) {
      employees.add(Employee.fromMapWithSpecialty(employeeMap));
    });

    print('employees to insertBatch');
    print(employees);
    List<List<Object?>> result = await insertBatchEmployees(employees, databaseIn: databaseIn);
    print('result insertBatchEmployees');
    print(result);

    // print('getEmployees().forEach');
    // // EmployeeData().getEmployeesMap().forEach((Map<String, dynamic> employeeMap) {
    // getEmployeesMap().forEach((Map<String, dynamic> employeeMap) async {
    //   employee = Employee.fromMapWithSpecialty(employeeMap);
    // // EmployeeData().getEmployees().forEach((Employee employee) {
    // // getEmployees().forEach((Employee employee) {
    //   print(employee);
    //   await insertEmployee(employee);
    //   await Future<void>.delayed(const Duration(milliseconds: 2500));
    // });

    return result;
  }

  // In ForeignRepository
  // @override
  // Future onConfigure(Database db) async {
  // // Future _onConfigure(Database db) async {
  // // static Future _onConfigure(Database db) async {
  //   print('--IN _onConfigure() Employee --');
  //   await db.execute('PRAGMA foreign_keys = ON');
  // }
  // Future<EmployeeRepository> init() async {
  //   // Avoid errors caused by flutter upgrade.
  //   // Importing 'package:flutter/widgets.dart' is required.
  //   WidgetsFlutterBinding.ensureInitialized();
  //   // Open the database and store the reference.
  //   _database = openDatabase(
  //     // Set the path to the database. Note: Using the `join` function from the
  //     // `path` package is best practice to ensure the path is correctly
  //     // constructed for each platform.
  //     join(await getDatabasesPath(), 'employee_database.db'),
  //     onCreate: (db, version) {
  //       // Run the CREATE TABLE statement on the database.
  //       return db.execute(
  //         'CREATE TABLE employees(id INTEGER PRIMARY KEY, name TEXT, specialty TEXT)',
  //       );
  //     },
  //     // Set the version. This executes the onCreate function and provides a
  //     // path to perform database upgrades and downgrades.
  //     version: 1,
  //   );
  //
  //   getEmployees().forEach((Employee employee) {
  //     insertEmployee(employee);
  //   });
  //
  //   return this;
  // }

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertEmployee(Employee employee) async {
    Database db = await _instance.database;
    return await db.insert(tableName, employee.toMap());
    // return await db.insert(tableName, { 'name': employee.name, 'specialty': employee.specialtyId });
  }
  // OR
  // // Define a function that inserts employees into the database
  // Future<void> insertEmployee(Employee employee) async {
  //   // Get a reference to the database.
  //   final db = await _database;
  //
  //   // Insert the Employee into the correct table. You might also specify the
  //   // `conflictAlgorithm` to use in case the same employee is inserted twice.
  //   //
  //   // In this case, replace any previous data.
  //   await db.insert(
  //     'employees',
  //     employee.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  Future<List<List<Object?>>> insertBatchEmployees(Set<Employee> employees, { Database? databaseIn }) async {
    Database db = databaseIn ?? await _instance.database;
    List<List<Object?>> results = [];
    db.transaction((txn) async {
      Batch batch = txn.batch();
      for (Employee employee in employees) {
        batch.insert(tableName, employee.toMap());
      }
      results.add(await batch.commit());
      print('results...');
      print(results);
    });

    return results;
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Employee>> employees({ int? limitIn = 100, String? orderByIn = 'id DESC' }) async {
  // Future<List<Map<String, dynamic>>> employees({ limitIn = 100 }) async {
    Database db = await _instance.database;
    // Query the table for all The Employees.
    final List<Map<String, dynamic>> maps = await db.query(
        tableName,
        limit: limitIn,
        orderBy: orderByIn,
    );

    // Convert the List<Map<String, dynamic> into a List<Employee>.
    // return List.generate(maps.length, (i) => Employee(maps[i]));
    return List.generate(maps.length, (i) => Employee.fromMap(maps[i]));
    // return List.generate(maps.length, (i) {
    //   return Employee.fromMap(maps[i]);
    //   return Employee(
    //     id: maps[i]['id'],
    //     name: maps[i]['name'],
    //     specialty: maps[i]['specialty'],
    //   );
    // });
  }
  // // A method that retrieves all the employees from the employees table.
  // Future<List<Employee>> employees() async {
  //   // Get a reference to the database.
  //   final db = await _database;
  //
  //   // Query the table for all The Employees.
  //   final List<Map<String, dynamic>> maps = await db.query('employees');
  //
  //   // Convert the List<Map<String, dynamic> into a List<Employee>.
  //   return List.generate(maps.length, (i) {
  //     return Employee(
  //       id: maps[i]['id'],
  //       name: maps[i]['name'],
  //       specialty: maps[i]['specialty'],
  //     );
  //   });
  // }

  String _querySelectWithSpecialties () {
    SpecialtyRepository specialtyRepository = SpecialtyRepository();

    return '''
      SELECT 
        $joinAlias.id AS '$joinAlias.id',
        $joinAlias.name AS '$joinAlias.name',
        $joinAlias.specialty_id AS '$joinAlias.specialty_id',
        ${specialtyRepository.joinAlias}.id AS '${specialtyRepository.joinAlias}.id',
        ${specialtyRepository.joinAlias}.name AS '${specialtyRepository.joinAlias}.name'
      -- SELECT $joinAlias.*, ${specialtyRepository.joinAlias}.*
        FROM $tableName AS $joinAlias
      INNER JOIN ${specialtyRepository.tableName} as ${specialtyRepository.joinAlias}
        ON $joinAlias.$foreignKeyColumnName = ${specialtyRepository.joinAlias}.${specialtyRepository.innerKeyColumnName}
    ''';
  }

  Future<List<Employee>> fetchEmployeesWithSpecialties() async {
    Database db = await _instance.database;
    // SpecialtyRepository specialtyRepository = SpecialtyRepository();
    String rawQuery = '''
      ${_querySelectWithSpecialties()}
      WHERE ${SoftDeleteRepository.onWhereNotDeleted(alias: joinAlias)}
    ''';
    // print('rawQuery');
    // print(rawQuery);

    final List<Map<String, dynamic>> maps = await db.rawQuery(rawQuery);

    // print('maps');
    // print(maps);
    // print('map.first');
    // print(maps.first);
    return List.generate(maps.length, (i) => Employee.fromMapWithSpecialty(maps[i]));
  }

  Future<Employee> employee(int employeeId) async {
    Database db = await _instance.database;
    final List<Map<String, dynamic>> map = await db.query(
      tableName,
      where: '$columnId = ? AND ${SoftDeleteRepository.onWhereNotDeleted()}',
      whereArgs: [employeeId],
    );

    // return Employee(map.last);
    return Employee.fromMap(map.last);
  }

  Future<Employee> employeeWithSpecialty(int employeeId) async {
    Database db = await _instance.database;
    // SpecialtyRepository specialtyRepository = SpecialtyRepository();
    String rawQuery = '''
      ${_querySelectWithSpecialties()}
      WHERE $joinAlias.$columnId = ? 
        AND ${SoftDeleteRepository.onWhereNotDeleted(alias: joinAlias)}
    ''';
    print('rawQuery');
    print(rawQuery);

    final List<Map<String, dynamic>> map = await db.rawQuery(rawQuery, [employeeId]);
    print('map last');
    print(map);

    return Employee.fromMapWithSpecialty(map.last);
  }

  // Queries rows based on the argument received
  Future<List<Map<String, dynamic>>> employeesLike(name) async {
    Database db = await _instance.database;
    return await db.query(tableName, where: "$columnName LIKE '%$name%'");
  }
  
  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> employeesCount() async {
    Database db = await _instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateEmployee(Employee employee) async {
    Database db = await _instance.database;
    Map<String, dynamic> employeeMap = employee.toMap();
    // OR
    // int id = employee.toMap()['id'];
    return await db.update(
        tableName,
        // employee.toMap(),
        employeeMap,
        where: '$columnId = ?',
        whereArgs: [employeeMap['id']],
        // OR
        // whereArgs: [employee.id],
        // OR
        // whereArgs: [id],
    );
  }
  // Future<void> updateEmployee(Employee employee) async {
  //   // Get a reference to the database.
  //   final db = await _database;
  //
  //   // Update the given Employee.
  //   await db.update(
  //     'employees',
  //     employee.toMap(),
  //     // Ensure that the Employee has a matching id.
  //     where: 'id = ?',
  //     // Pass the Employee's id as a whereArg to prevent SQL injection.
  //     whereArgs: [employee.id],
  //   );
  // }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteEmployee(int employeeId) async {
    Database db = await _instance.database;
    return await db.delete(
        tableName,
        where: '$columnId = ?',
        whereArgs: [employeeId]
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

  // Future<void> deleteEmployee(int id) async {
  //   // Get a reference to the database.
  //   final db = await _database;
  //
  //   // Remove the Employee from the database.
  //   await db.delete(
  //     'employees',
  //     // Use a `where` clause to delete a specific employee.
  //     where: 'id = ?',
  //     // Pass the Employee's id as a whereArg to prevent SQL injection.
  //     whereArgs: [id],
  //   );
  // }
}