import 'package:sos_project_mobile/core/app_database.dart';
import '../model/order.dart';

class OrderDAO {
  static const String table = 'orders';

  Future<int> insertOrder(Order order) async {
    final db = await AppDatabase().database;
    return await db.insert(table, order.toMap());
  }

  Future<List<Order>> findAllOrders(int userId) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'u_id = ?',
      whereArgs: [userId],
      orderBy: 'open_date DESC',
    );
    return result.map((element) => Order.fromMap(element)).toList();
  }

  Future<int> updateOrder(Order order, int userId) async {
    final db = await AppDatabase().database;
    return await db.update(
      table,
      order.toMap(),
      where: 'id = ? AND u_id = ?',
      whereArgs: [order.id, userId],
    );
  }

  Future<int> deleteOrder(int orderId, int userId) async {
    final db = await AppDatabase().database;
    return await db.delete(
      table,
      where: 'id = ? AND u_id = ?',
      whereArgs: [orderId, userId],
    );
  }
}
