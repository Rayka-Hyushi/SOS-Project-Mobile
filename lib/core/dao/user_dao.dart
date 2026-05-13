import 'package:sos_project_mobile/core/app_database.dart';
import 'package:uuid/uuid.dart';
import '../model/user.dart';

class UserDAO {
  static const String table = 'users';

  Future<int> insertUser(User user) async {
    final db = await AppDatabase().database;
    final map = user.toMap();
    if (map['uuid'] == null) {
      map['uuid'] = const Uuid().v4();
    }
    return await db.insert(table, map);
  }

  Future<User?> getUser(String email, String password) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  Future<int> updateUser(User user) async {
    final db = await AppDatabase().database;
    return await db.update(
      table,
      user.toMap(),
      where: 'uid = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int uid) async {
    final db = await AppDatabase().database;
    return await db.delete(table, where: 'uid = ?', whereArgs: [uid]);
  }

  Future<List<User>> findAllUsers() async {
    final db = await AppDatabase().database;
    final result = await db.query(table, orderBy: 'name ASC');

    return result.map((element) => User.fromMap(element)).toList();
  }

  Future<void> logout() async {
    final db = await AppDatabase().database;
    await db.delete(table);
  }
}
