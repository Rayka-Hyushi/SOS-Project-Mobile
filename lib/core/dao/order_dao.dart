import 'package:sos_project_mobile/core/app_database.dart';
import 'package:uuid/uuid.dart';
import '../model/order.dart';

class OrderDAO {
  static const String table = 'orders';
  static const String joinTable = 'order_services';

  Future<int> insertOrder(Order order) async {
    final db = await AppDatabase().database;
    final map = order.toMap();
    if (map['uuid'] == null) {
      map['uuid'] = const Uuid().v4();
    }
    
    return await db.transaction((txn) async {
      final osid = await txn.insert(table, map);
      
      // Insert relationships with services
      for (var service in order.servicos) {
        if (service.id != null) {
          await txn.insert(joinTable, {
            'os_id': osid,
            'service_id': service.id,
          });
        }
      }
      return osid;
    });
  }

  Future<List<Order>> findAllOrders(int userId) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'u_id = ?',
      whereArgs: [userId],
      orderBy: 'opendate DESC',
    );

    List<Order> orders = [];
    for (var element in result) {
      final orderMap = Map<String, dynamic>.from(element);
      final osid = orderMap['osid'];
      
      // Fetch services for this order
      final servicesResult = await db.rawQuery('''
        SELECT s.* FROM services s
        INNER JOIN $joinTable os ON s.sid = os.service_id
        WHERE os.os_id = ?
      ''', [osid]);
      
      orderMap['servicos'] = servicesResult;
      orders.add(Order.fromMap(orderMap));
    }
    return orders;
  }

  Future<int> updateOrder(Order order, int userId) async {
    final db = await AppDatabase().database;
    return await db.transaction((txn) async {
      final result = await txn.update(
        table,
        order.toMap(),
        where: 'osid = ? AND u_id = ?',
        whereArgs: [order.osid, userId],
      );

      // Refresh services: delete all and re-insert
      await txn.delete(joinTable, where: 'os_id = ?', whereArgs: [order.osid]);
      for (var service in order.servicos) {
        if (service.id != null) {
          await txn.insert(joinTable, {
            'os_id': order.osid,
            'service_id': service.id,
          });
        }
      }
      return result;
    });
  }

  Future<int> deleteOrder(int orderId, int userId) async {
    final db = await AppDatabase().database;
    return await db.delete(
      table,
      where: 'osid = ? AND u_id = ?',
      whereArgs: [orderId, userId],
    );
  }
}
