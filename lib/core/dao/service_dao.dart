import 'package:sos_project_mobile/core/app_database.dart';
import 'package:uuid/uuid.dart';
import '../model/services.dart';

class ServiceDao {
  static const String table = 'services';

  Future<int> insertService(Services service) async {
    final db = await AppDatabase().database;
    final map = service.toMap();
    if (map['uuid'] == null) {
      map['uuid'] = const Uuid().v4();
    }
    return await db.insert(table, map);
  }

  Future<Services?> getService(int sid, int uid) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'sid = ? AND u_id = ?',
      whereArgs: [sid, uid],
    );
    return result.isNotEmpty ? Services.fromMap(result.first) : null;
  }

  Future<int> updateService(Services service, int uid) async {
    final db = await AppDatabase().database;
    return await db.update(
      table,
      service.toMap(),
      where: 'sid = ? AND u_id = ?',
      whereArgs: [service.id, uid],
    );
  }

  Future<int> deleteService(int sid, int uid) async {
    final db = await AppDatabase().database;
    return await db.delete(
      table,
      where: 'sid = ? AND u_id = ?',
      whereArgs: [sid, uid],
    );
  }

  Future<List<Services>> findAllServices(int uid) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'u_id = ?',
      whereArgs: [uid],
      orderBy: 'service ASC',
    );
    return result.map((element) => Services.fromMap(element)).toList();
  }
}
