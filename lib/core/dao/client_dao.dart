import 'package:sos_project_mobile/core/app_database.dart';
import 'package:uuid/uuid.dart';
import '../model/client.dart';

class ClientDAO {
  static const String table = 'clients';

  Future<int> insertClient(Client client) async {
    final db = await AppDatabase().database;
    final map = client.toMap();
    if (map['uuid'] == null) {
      map['uuid'] = const Uuid().v4();
    }
    return await db.insert(table, map);
  }

  Future<Client?> getClient(int cid, int uid) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'cid = ? AND u_id = ?',
      whereArgs: [cid, uid],
    );
    return result.isNotEmpty ? Client.fromMap(result.first) : null;
  }

  Future<int> updateClient(Client client, int uid) async {
    final db = await AppDatabase().database;
    return await db.update(
      table,
      client.toMap(),
      where: 'cid = ? AND u_id = ?',
      whereArgs: [client.id, uid],
    );
  }

  Future<int> deleteClient(int cid, int uid) async {
    final db = await AppDatabase().database;
    return await db.delete(
      table,
      where: 'cid = ? AND u_id = ?',
      whereArgs: [cid, uid],
    );
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
