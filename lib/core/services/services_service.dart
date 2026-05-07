import 'package:sos_project_mobile/core/dao/service_dao.dart';

import '../model/services.dart';
import '../model/user.dart';

class ServicesService {
  final ServiceDao _serviceDAO = ServiceDao();

  Future<bool> register(Services service) async {
    try {
      await _serviceDAO.insertService(service);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Services?> getService(Services service, int uid) async {
    return await _serviceDAO.getService(service, uid);
  }

  Future<int> updateService(Services service, int uid) async {
    return await _serviceDAO.updateService(service, uid);
  }

  Future<int> deleteService(int id, int uid) async {
    return await _serviceDAO.deleteService(id, uid);
  }

  Future<List<Services>> findAllServices(int uid) async {
    return await _serviceDAO.findAllServices(uid);
  }
}
