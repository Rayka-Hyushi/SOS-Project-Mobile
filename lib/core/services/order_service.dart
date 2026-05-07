import '../dao/order_dao.dart';
import '../model/order.dart';

class OrderService {
  final OrderDAO _orderDAO = OrderDAO();

  Future<bool> register(Order order) async {
    try {
      await _orderDAO.insertOrder(order);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Order>> findAllOrders(int userId) async {
    return await _orderDAO.findAllOrders(userId);
  }

  Future<int> updateOrder(Order order, int userId) async {
    return await _orderDAO.updateOrder(order, userId);
  }

  Future<int> deleteOrder(int orderId, int userId) async {
    return await _orderDAO.deleteOrder(orderId, userId);
  }
}
