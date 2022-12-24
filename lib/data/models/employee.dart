// import 'package:equatable/equatable.dart';

// import 'package:work_schedule/data/local/nullable.dart';
import 'package:work_schedule/data/models/model.dart';
import 'package:work_schedule/data/models/specialty.dart';
import 'package:work_schedule/data/repository/employee_repository.dart';
import 'package:work_schedule/data/repository/specialty_repository.dart';
// import 'package:work_schedule/data/repository/specialty_repository.dart';

// class Employee extends Model with EquatableMixin {
class Employee extends Model {
  static const int newEmployeeId = 0;
  late int _id;
  // late int _id = -2;
  // late int _id = newEmployeeId;
  @override
  get id => _id;
  // int id = newEmployeeId;
  // final int id;
  late String name;
  // final String name;
  late int _specialtyId;
  Specialty specialty;
  // final Specialty specialty;

  // Employee.parameters({ required this.id, required this.name, required this.specialtyId }) : super({});
  Employee({ required this.name, required this.specialty });
  // Employee({ required this.name, required this.specialtyId });
  // Employee({ required this.id, required this.name, required this.specialtyId });
  // factory Employee.beforeSave({ id, name, specialtyId }) => Employee(id: 0, name: name, specialtyId: specialtyId);
  // Employee({ required this.id, required this.name, required this.specialty });

  // // Employee(Map<String, dynamic> map) : this.parameters({id: id, name: name, specialtyId}) {
  // Employee(Map<String, dynamic> map) : super(map) {
  //   // return Employee(
  //       id = map['id'];
  //       name = map['name'];
  //       // specialtyId = map[SpecialtyRepository.columnId];
  //       specialtyId = map['specialty_id'];
  //   // );
  // }
  factory Employee.fromMap(Map<String, dynamic> map) {
    print('Employee.fromMap in...');
    print(map);
    Employee employee = Employee(
    // return Employee(
        // _id: map['id'],
        name: map[EmployeeRepository.columnName],
        // name: map['name'],
        // _specialtyId: map['specialty_id'],
        // specialty: map['specialty'],
        specialty: Specialty.fromMap(map),
    );
    employee._id = map[EmployeeRepository.columnId];
    // employee._id = map['id'];
    employee._specialtyId = map[EmployeeRepository.columnSpecialtyId];
    // employee._specialtyId = map['specialty_id'];

    return employee;
  }

  factory Employee.fromMapWithSpecialty(Map<String, dynamic> map) {
    // print('map in fromMapWithSpecialty');
    // print(map);
    // employee.specialty = Specialty.fromMap(map);
    // SpecialtyRepository specialtyRepository = SpecialtyRepository();
    Specialty specialty = Specialty.fromMapWithAlias(map);
    // employee.specialty = Specialty(
    //     id: map['${specialtyRepository.joinAlias}.id'],
    //     name: map['${specialtyRepository.joinAlias}.name']
    // );
    EmployeeRepository employeeRepository = EmployeeRepository();
    // Employee employee = Employee.fromMap(map);
    Employee employee = Employee(
        // _id: map['${employeeRepository.joinAlias}.id'],
        name: map['${employeeRepository.joinAlias}.${EmployeeRepository.columnName}'],
        // name: map['${employeeRepository.joinAlias}.name'],
        // specialtyId: map['${employeeRepository.joinAlias}.specialty_id'],
        specialty: specialty
    );
    employee._id = map['${employeeRepository.joinAlias}.${EmployeeRepository.columnId}'];
    // employee._id = map['${employeeRepository.joinAlias}.id'];
    employee._specialtyId = map['${employeeRepository.joinAlias}.${EmployeeRepository.columnSpecialtyId}'];
    // employee._specialtyId = map['${employeeRepository.joinAlias}.specialty_id'];

    return employee;
  }

  // Employee copyWith({
  //   int id, String name, Specialty specialty
  // }) {
  //   Employee employee = Employee(
  //     // id: id ?? this.id,
  //     name: name ?? this.name,
  //     specialty: specialty ?? this.specialty
  // );
  //   return employee;
  // }

  // Employee copyWithImproved({
  //   Nullable<int> id, Nullable<String> name, Nullable<String> specialty
  // }) => Employee(
  //   // id: id == null ? this.id : id.value == null ? null : id.value,
  //   name: name == null ? this.name : name.value == null ? null : name.value,
  //   specialty: specialty == null ? this.specialty : specialty.value == null ? null : specialty.value,
  // );

  factory Employee.empty() {
    EmployeeRepository employeeRepository = EmployeeRepository();
    SpecialtyRepository specialtyRepository = SpecialtyRepository();
    return Employee.fromMapWithSpecialty({
      '${employeeRepository.joinAlias}.${EmployeeRepository.columnId}': Model.idForCreating,
      '${employeeRepository.joinAlias}.${EmployeeRepository.columnName}': '',
      '${employeeRepository.joinAlias}.${EmployeeRepository.columnSpecialtyId}': Model.idForCreating,
      '${specialtyRepository.joinAlias}.${SpecialtyRepository.columnId}': Model.idForCreating,
      '${specialtyRepository.joinAlias}.${SpecialtyRepository.columnName}': ''
    });
  }

  @override
  // Convert a Employee into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
    // return {
    //   EmployeeRepository.columnId: _id,
    //   EmployeeRepository.columnId: id,
      EmployeeRepository.columnName: name,
      EmployeeRepository.columnSpecialtyId: _specialtyId,
    };

    if (_id != Model.idForCreating) {
    // if (_id != newEmployeeId) {
      map[EmployeeRepository.columnId] = _id;
    }

    print('map out');
    print(map);
    return map;
  }

  Map<String, dynamic> toMapWithSpecialty() {
    EmployeeRepository employeeRepository = EmployeeRepository();
    SpecialtyRepository specialtyRepository = SpecialtyRepository();
    Map<String, dynamic> map = {
      // '${employeeRepository.joinAlias}.${EmployeeRepository.columnId}': _id,
      '${employeeRepository.joinAlias}.${EmployeeRepository.columnName}': name,
      '${employeeRepository.joinAlias}.${EmployeeRepository.columnSpecialtyId}': _specialtyId,
      '${specialtyRepository.joinAlias}.${SpecialtyRepository.columnId}': specialty.id,
      '${specialtyRepository.joinAlias}.${SpecialtyRepository.columnName}': specialty.name,
    };

    if (_id != Model.idForCreating) {
      map['${employeeRepository.joinAlias}.${EmployeeRepository.columnId}'] = _id;
    }

    return map;
  }

  // Implement toString to make it easier to see information about
  // each employee when using the print statement.
  @override
  String toString() {
    return 'Employee{hashCode: $hashCode, id: $_id, name: $name, specialtyHashCode: ${specialty.hashCode}, specialty: ${specialty.name}, specialtyId: ${specialty.id}}';
    // return 'Employee{id: $_id, name: $name, specialty: ${specialty.name}}';
    // return 'Employee{id: $_id, name: $name, specialty: $_specialtyId}';
  }


  // ToDo OR start ______
  // @override
  // // List<Object> get props => [name, specialty];
  // List<Object> get props => [_id, name, specialty];
  // ToDo OR -------
  bool isEqualsEmployees(Employee other) {
    print('isEqualsEmployees');
    print(runtimeType == other.runtimeType);
    print(_id == other.id);
    print(name == other.name);
    print(specialty == other.specialty);
    return identical(this, other)
        || runtimeType == other.runtimeType
            && _id == other.id
            && name == other.name
            && specialty.isEqualsSpecialties(other.specialty);
  }
  // ToDo OR -------
  // @override
  // int get hashCode => _id.hashCode ^ name.hashCode ^ specialty.hashCode;
  //
  // @override
  // bool operator ==(Object other) {
  //   print('@override operator ==other');
  //   // print(other);
  //   // print(other.runtimeType);
  //   // print('...where...');
  //   // print(identical(this, other));
  //   // print('...where2');
  //   // print(other is Employee);
  //   if (other is Employee && runtimeType == other.runtimeType) {
  //     // print(other.name);
  //     // print(other.specialty);
  //     // print('...where3');
  //     // print(name == other.name);
  //     // print('...where4');
  //     // print(specialty == other.specialty);
  //     // print('...where');
  //   }
  //   return identical(this, other)
  //       || other is Employee
  //           && runtimeType == other.runtimeType
  //           && _id == other.id
  //           && name == other.name
  //           && specialty == other.specialty;
  // }
  // ToDo OR end ^^^^^^

  void setSpecialtyId(int? specialtyId) {
    Map<String, dynamic>? specialtyMap = specialty.toMap();
    print('specialtyMap b');
    print(specialtyMap);
    specialtyMap[SpecialtyRepository.columnId] = specialtyId;
    print('specialtyMap a');
    print(specialtyMap);
    specialty = Specialty.fromMap(specialtyMap);
    _specialtyId = specialtyId!;
  }

  void setSpecialtyFull(int specialtyId) async {
    SpecialtyRepository specialtyRepository = SpecialtyRepository();
    print('specialty b set');
    print(specialty);
    specialty = await specialtyRepository.specialty(specialtyId);
    print('specialty a set');
    print(specialty);
    _specialtyId = specialtyId;
  }

  static Employee setSpecialty(Employee employee, int? specialtyId) {
    Map<String, dynamic>? specialtyMap = employee.specialty.toMap();
    print('specialtyMap b');
    print(specialtyMap);
    specialtyMap[SpecialtyRepository.columnId] = specialtyId;
    print('specialtyMap a');
    print(specialtyMap);
    employee.specialty = Specialty.fromMap(specialtyMap);
    employee._specialtyId = specialtyId!;

    return employee;
  }

}