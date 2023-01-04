import 'package:work_schedule/data/models/model.dart';
import 'package:work_schedule/data/models/specialty.dart';
import 'package:work_schedule/data/repository/employee_repository.dart';
import 'package:work_schedule/data/repository/specialty_repository.dart';

class Employee extends Model {
  late int _id;

  @override
  get id => _id;
  String name;
  late int _specialtyId;
  Specialty specialty;

  Employee({ required this.name, required this.specialty });

  factory Employee.fromMap(Map<String, dynamic> map) {
    Employee employee = Employee(
      name: map[EmployeeRepository.columnName],
      specialty: Specialty.fromMap(map),
    );
    employee._id = map[EmployeeRepository.columnId];
    employee._specialtyId = map[EmployeeRepository.columnSpecialtyId];

    return employee;
  }

  factory Employee.fromMapWithSpecialty(Map<String, dynamic> map) {
    Specialty specialty = Specialty.fromMapWithAlias(map);
    EmployeeRepository employeeRepository = EmployeeRepository();
    Employee employee = Employee(
        name: map['${employeeRepository.joinAlias}.${EmployeeRepository.columnName}'],
        specialty: specialty
    );
    employee._id = map['${employeeRepository.joinAlias}.${EmployeeRepository.columnId}'];
    employee._specialtyId = map['${employeeRepository.joinAlias}.${EmployeeRepository.columnSpecialtyId}'];

    return employee;
  }

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
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      EmployeeRepository.columnName: name,
      EmployeeRepository.columnSpecialtyId: _specialtyId,
    };

    if (_id != Model.idForCreating) {
      map[EmployeeRepository.columnId] = _id;
    }

    return map;
  }

  Map<String, dynamic> toMapWithSpecialty() {
    EmployeeRepository employeeRepository = EmployeeRepository();
    SpecialtyRepository specialtyRepository = SpecialtyRepository();
    Map<String, dynamic> map = {
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

  @override
  String toString() {
    return 'Employee{hashCode: $hashCode, id: $_id, name: $name, '
        'specialtyHashCode: ${specialty.hashCode}, specialty: ${specialty.name}, specialtyId: ${specialty.id}}';
  }


  bool isEqualsEmployees(Employee other) {
    return identical(this, other)
        || runtimeType == other.runtimeType
            && _id == other.id
            && name == other.name
            && specialty.isEqualsSpecialties(other.specialty);
  }

  void setSpecialtyId(int? specialtyId) {
    Map<String, dynamic>? specialtyMap = specialty.toMap();
    specialtyMap[SpecialtyRepository.columnId] = specialtyId;
    specialty = Specialty.fromMap(specialtyMap);
    _specialtyId = specialtyId!;
  }

  void setSpecialtyFull(int specialtyId) async {
    SpecialtyRepository specialtyRepository = SpecialtyRepository();
    specialty = await specialtyRepository.getSpecialty(specialtyId);
    _specialtyId = specialtyId;
  }
}
