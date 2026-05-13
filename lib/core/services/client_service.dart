import 'package:sos_project_mobile/core/dao/client_dao.dart';
import '../model/client.dart';

class ClientService {
  final ClientDAO _clientDAO = ClientDAO();

  Future<bool> register(Client client) async {
    try {
      await _clientDAO.insertClient(client);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Client?> getClient(int cid, int uid) async {
    return await _clientDAO.getClient(cid, uid);
  }

  Future<int> updateClient(Client client, int uid) async {
    return await _clientDAO.updateClient(client, uid);
  }

  Future<int> deleteClient(int cid, int uid) async {
    return await _clientDAO.deleteClient(cid, uid);
  }

  Future<List<Client>> findAllClients(int uid) async {
    return await _clientDAO.findAllClients(uid);
  }
}
