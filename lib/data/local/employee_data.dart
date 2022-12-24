import 'package:work_schedule/data/models/employee.dart';
import 'package:work_schedule/data/models/specialty.dart';

// ToDo Is need?
class EmployeeData {
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

  static List<Employee> getEmployees() {
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
}