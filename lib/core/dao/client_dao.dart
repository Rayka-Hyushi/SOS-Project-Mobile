import 'package:sos_project_mobile/core/app_database.dart';

import '../model/client.dart';
import '../model/user.dart';

class ClientDAO {
  static const String table = 'clients';

  Future<int> insertClient(Client client) async {
    final db = await AppDatabase().database;
    return await db.insert(table, client.toMap());
  }

  Future<Client?> getClient(Client client, int uid) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'id = ? AND u_id = ?',
      whereArgs: [client.id, uid],
    );
    return result.isNotEmpty ? Client.fromMap(result.first) : null;
  }

  Future<int> updateClient(Client client, int uid) async {
    final db = await AppDatabase().database;
    final result = await db.update(
      table,
      client.toMap(),
      where: 'id = ? AND u_id = ?',
      whereArgs: [client.id, uid],
    );
    return result;
  }

  Future<int> deleteClient(int id, int uid) async {
    final db = await AppDatabase().database;
    final result = await db.delete(
      table,
      where: 'id = ? AND u_id = ?',
      whereArgs: [id, uid],
    );
    return result;
  }

  Future<List<Client>> findAllClients(int uid) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'u_id = ?',
      whereArgs: [uid],
      orderBy: 'name ASC',
    );
    return result.map((element) => Client.fromMap(element)).toList();
  }
}
