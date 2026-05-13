import 'package:sos_project_mobile/core/dao/service_dao.dart';
import '../model/services.dart';

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

  Future<Services?> getService(int sid, int uid) async {
    return await _serviceDAO.getService(sid, uid);
  }

  Future<int> updateService(Services service, int uid) async {
    return await _serviceDAO.updateService(service, uid);
  }

  Future<int> deleteService(int sid, int uid) async {
    return await _serviceDAO.deleteService(sid, uid);
  }

  Future<List<Services>> findAllServices(int uid) async {
    return await _serviceDAO.findAllServices(uid);
  }
}
