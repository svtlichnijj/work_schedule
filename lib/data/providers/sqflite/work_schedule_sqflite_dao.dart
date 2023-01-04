import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:work_schedule/data/providers/sqflite/mixins/foreign_repository.dart';
import 'package:work_schedule/data/providers/sqflite/mixins/soft_delete_repository.dart';
import 'package:work_schedule/data/providers/sqflite/abstract_sqflite_provider.dart';
import 'package:work_schedule/data/providers/sqflite/service_dao.dart';
import 'package:work_schedule/data/repository/employee_repository.dart';
import 'package:work_schedule/data/repository/specialty_repository.dart';

abstract class WorkScheduleSqfliteDao extends AbstractSqfliteProvider with ForeignRepository, SoftDeleteRepository {
  @override
  String get databaseName => 'work_schedule.db';

  @override
  Future onCreate(Database db, int version) async {
    SpecialtyRepository specialtyDao = SpecialtyRepository();
    await specialtyDao.createTable(db, version);

    EmployeeRepository employeeRepository = EmployeeRepository();
    await employeeRepository.createTable(db, version);

    ServiceDao serviceDao = ServiceDao();
    await serviceDao.createTable(db, version);
  }
}