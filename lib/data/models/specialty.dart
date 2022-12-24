// import 'package:equatable/equatable.dart';
import 'package:work_schedule/data/models/model.dart';
import 'package:work_schedule/data/repository/specialty_repository.dart';

// class Specialty implements Model {
// class Specialty extends Model with EquatableMixin {
class Specialty extends Model {
  // late int _id = -22;
  late int _id;
  @override
  get id => _id;
  // int id;
  String name;

  // Specialty({ Map<String, dynamic>? map, required this.id, required this.name }) : super.fromMap(map);
  // Specialty.parameters({ required this.id, required this.name }) : super({});
  Specialty({ required this.name });
  // Specialty({ required this.id, required this.name });

  // Specialty(Map<String, dynamic> map) : super(map) {
  //   // return Specialty(
  //       id = map['id'];
  //       name = map['name'];
  //   // );
  // }
  factory Specialty.fromMap(Map<String, dynamic> map) {
    Specialty specialty = Specialty(
    // return Specialty(
      // id: map['id'],
      name: map['name'],
    );
    specialty._id = map['id'];

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
    return {
      SpecialtyRepository.columnId: _id,
      // SpecialtyRepository.columnId: id,
      SpecialtyRepository.columnName: name,
    };
  }

  @override
  String toString() {
    return 'Specialty{hashCode: $hashCode, id: $_id, name: $name}';
  }

  // ToDo OR start ______
  bool isEqualsSpecialties(Specialty other) {
    print('isEqualsSpecialties');
    print(runtimeType == other.runtimeType);
    print(_id == other.id);
    print(name == other.name);
    return identical(this, other)
        || runtimeType == other.runtimeType
            && _id == other.id
            && name == other.name;
  }
// ToDo OR -------
  // @override
  // int get hashCode => _id.hashCode ^ name.hashCode;
  //
  // @override
  // bool operator ==(Object other) {
  //   // return super == other;
  //   return identical(this, other)
  //       || other is Specialty
  //           && runtimeType == other.runtimeType
  //           && _id == other.id
  //           && name == other.name;
  // }
  //
  // @override
  // // TODO: implement props
  // List<Object?> get props => [_id, name];
}