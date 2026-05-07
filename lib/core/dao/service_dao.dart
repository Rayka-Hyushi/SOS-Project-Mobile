import 'package:sos_project_mobile/core/app_database.dart';

import '../model/services.dart';
import '../model/user.dart';

class ServiceDao {
  static const String table = 'services';

  Future<int> insertService(Services service) async {
    final db = await AppDatabase().database;
    return await db.insert(table, service.toMap());
  }

  Future<Services?> getService(Services service, int uid) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'id = ? AND u_id = ?',
      whereArgs: [service.id, uid],
    );
    return result.isNotEmpty ? Services.fromMap(result.first) : null;
  }

  Future<int> updateService(Services service, int uid) async {
    final db = await AppDatabase().database;
    final result = await db.update(
      table,
      service.toMap(),
      where: 'id = ? AND u_id = ?',
      whereArgs: [service.id, uid],
    );
    return result;
  }

  Future<int> deleteService(int id, int uid) async {
    final db = await AppDatabase().database;
    final result = await db.delete(
      table,
      where: 'id = ? AND u_id = ?',
      whereArgs: [id, uid],
    );
    return result;
  }

  Future<List<Services>> findAllServices(int uid) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'u_id = ?',
      whereArgs: [uid],
      orderBy: 'servico ASC',
    );
    return result.map((element) => Services.fromMap(element)).toList();
  }
}
