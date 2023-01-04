import 'dart:async';

import 'package:work_schedule/data/models/service.dart';
import 'package:work_schedule/data/repository/service_repository.dart';
import 'package:work_schedule/enums/crud_menu_items.dart';

class ServiceBloc {
  //Get instance of the Repository
  static final _serviceRepository = ServiceRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  static final _serviceController = StreamController<List<Service>>.broadcast();

  Stream<List<Service>> get services => _serviceController.stream;

  ServiceBloc() {
    getServices();
  }

  void getServices({String? nameLike}) async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    _serviceController.sink.add(await _serviceRepository.getAllServices(nameLike: nameLike));
  }

  void addService(Service service) async {
    await _serviceRepository.insertService(service);
    getServices();
  }

  void updateService(Service service) async {
    await _serviceRepository.updateService(service);
    getServices();
  }

  void softDeleteService(int id) async {
    await _serviceRepository.softDeleteService(id);
    getServices();
  }

  void deleteService(int id) async {
    await _serviceRepository.deleteService(id);
    getServices();
  }

  Future<void> runMethod(/*ServiceBloc serviceBloc, */CrudMenuItems crudMenuItem, Iterable<Object?>? positionalArguments/*, [Map<Symbol, Object?>? namedArguments]*/) async {
    switch (crudMenuItem) {
      case CrudMenuItems.create:
        addService(positionalArguments!.first as Service);
        break;
      case CrudMenuItems.read:
        getServices(nameLike: positionalArguments!.first as String);
        break;
      case CrudMenuItems.edit:
        updateService(positionalArguments!.first as Service);
        break;
      case CrudMenuItems.delete:
        softDeleteService(positionalArguments!.first as int);
        break;
      default:
        throw ArgumentError.value(crudMenuItem, 'name');
    }
  }

  dispose() {
    _serviceController.close();
  }
}
