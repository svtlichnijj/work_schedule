import 'package:work_schedule/data/models/model.dart';
import 'package:work_schedule/data/repository/service_repository.dart';

class Service extends Model {
  late int _id;

  @override
  get id => _id;
  String name;
  Duration duration;

  Service({ required this.name, required this.duration });

  factory Service.fromMap(Map<String, dynamic> map) {
    Service service = Service(
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
      ServiceRepository.columnName: name,
      ServiceRepository.columnDuration: duration,
    };
  }
}
