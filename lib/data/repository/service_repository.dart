import 'package:work_schedule/data/providers/sqflite/service_dao.dart';
import 'package:work_schedule/data/models/service.dart';

class ServiceRepository {
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnDuration = 'duration';

  final serviceDao = ServiceDao();
  // ToDo Implement
  // final serviceWeb = ServiceWeb();

  Future getAllServices({String? nameLike}) => serviceDao.getServices(nameLike: nameLike);

  Future insertService(Service service) => serviceDao.createService(service);

  Future updateService(Service service) => serviceDao.updateService(service);

  Future softDeleteService(int serviceId) => serviceDao.softDeleteService(serviceId);

  Future deleteService(int serviceId) => serviceDao.deleteService(serviceId);
}
