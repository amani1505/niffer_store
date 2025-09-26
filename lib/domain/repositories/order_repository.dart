import 'package:niffer_store/domain/entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders();
  Future<Order> getOrderById(String id);
  Future<List<Order>> getOrdersByUser(String userId);
  Future<List<Order>> getOrdersByStore(String storeId);
  Future<Order> createOrder(Order order);
  Future<Order> updateOrderStatus(String orderId, String status);
}