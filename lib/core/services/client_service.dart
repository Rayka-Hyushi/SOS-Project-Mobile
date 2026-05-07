import 'package:sos_project_mobile/core/dao/client_dao.dart';

import '../model/client.dart';
import '../model/user.dart';

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

  Future<Client?> getClient(Client client, int uid) async {
    return await _clientDAO.getClient(client, uid);
  }

  Future<int> updateClient(Client client, int uid) async {
    return await _clientDAO.updateClient(client, uid);
  }

  Future<int> deleteClient(int id, int uid) async {
    return await _clientDAO.deleteClient(id, uid);
  }

  Future<List<Client>> findAllClients(int uid) async {
    return await _clientDAO.findAllClients(uid);
  }
}
