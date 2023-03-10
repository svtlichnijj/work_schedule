import 'package:work_schedule/data/models/model.dart';
import 'package:work_schedule/data/repository/specialty_repository.dart';

class Specialty extends Model {
  late int _id;

  @override
  get id => _id;
  String name;

  Specialty({ required this.name });

  factory Specialty.fromMap(Map<String, dynamic> map) {
    Specialty specialty = Specialty(
      name: map[SpecialtyRepository.columnName],
    );
    specialty._id = map[SpecialtyRepository.columnId];

    return specialty;
  }

  factory Specialty.fromMapWithAlias(Map<String, dynamic> map) {
    SpecialtyRepository specialtyRepository = SpecialtyRepository();
    Specialty specialty = Specialty(
      name: map['${specialtyRepository.joinAlias}.name'],
    );
    specialty._id = map['${specialtyRepository.joinAlias}.id'];

    return specialty;
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      SpecialtyRepository.columnName: name,
    };

    if (_id != Model.idForCreating) {
      map[SpecialtyRepository.columnId] = _id;
    }

    return map;
  }

  @override
  String toString() {
    return 'Specialty{hashCode: $hashCode, id: $_id, name: $name}';
  }

  bool isEqualsSpecialties(Specialty other) {
    return identical(this, other)
        || runtimeType == other.runtimeType
            && _id == other.id
            && name == other.name;
  }
}
