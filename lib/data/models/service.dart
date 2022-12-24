import 'package:work_schedule/data/models/model.dart';
import 'package:work_schedule/data/repository/service_repository.dart';

class Service extends Model {
  late int _id;
  @override
  get id => _id;
  late String name;
  // String name;
  late Duration duration;
  // Duration duration;

  // Service.parameters({ required this.name, required this.duration }) : super({});
  Service({ required this.name, required this.duration });
  // Service({ required this._id, required this.name, required this.duration });
  // Service({ required this.name, required this.duration });

  // Service(Map<String, dynamic> map) : super(map) {
  //   name = map['name'];
  //   duration = map['duration'];
  // }
  factory Service.fromMap(Map<String, dynamic> map) {
    Service service = Service(
    // return Service(
        // _id: map['id'],
        name: map['name'],
        duration: map['duration'],
    );
    service._id = map['id'];

    return service;
  }


  @override
  Map<String, dynamic> toMap() {
    return {
      ServiceRepository.columnId: _id,
      // ServiceRepository.columnId: id,
      ServiceRepository.columnName: name,
      ServiceRepository.columnDuration: duration,
    };
  }
}