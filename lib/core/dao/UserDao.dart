import 'package:sos_project_mobile/core/app_database.dart';

import '../model/user.dart';

class UserDAO {
  static const String table = 'user';

  Future<int> insertUser(User user) async {
    final db = await AppDatabase().database;
    return await db.insert(table, user.toMap());
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
    final result = await db.update(
      table,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
    return result;
  }

  Future<int> deleteUser(int id) async {
    final db = await AppDatabase().database;
    final result = await db.delete(table, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<List<User>> findAllUsers() async {
    final db = await AppDatabase().database;
    final result = await db.query(table, orderBy: 'name ASC');

    return result.map((element) => User.fromMap(element)).toList();
  }
}
