import 'package:niffer_store/data/datasources/remote/order_remote_datasource.dart';
import 'package:niffer_store/domain/entities/order.dart';
import 'package:niffer_store/domain/repositories/order_repository.dart';
import 'package:niffer_store/dummy_data/dummy_data_initializer.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Order>> getOrders() async {
    try {
      // For demo purposes, use dummy data
      // In production, uncomment the line below:
      // return await remoteDataSource.getOrders();
      return DummyDataInitializer.getOrders();
    } catch (e) {
      return DummyDataInitializer.getOrders();
    }
  }

  @override
  Future<Order> getOrderById(String id) async {
    try {
      // For demo purposes, use dummy data
      // In production, uncomment the line below:
      // return await remoteDataSource.getOrderById(id);
      final orders = DummyDataInitializer.getOrders();
      final order = orders.where((o) => o.id == id).firstOrNull;
      if (order != null) {
        return order;
      }
      throw Exception('Order not found');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Order>> getOrdersByUser(String userId) async {
    try {
      // For demo purposes, use dummy data
      // In production, uncomment the line below:
      // return await remoteDataSource.getOrdersByUser(userId);
      return DummyDataInitializer.getOrdersByUser(userId);
    } catch (e) {
      return DummyDataInitializer.getOrdersByUser(userId);
    }
  }

  @override
  Future<List<Order>> getOrdersByStore(String storeId) async {
    try {
      // For demo purposes, use dummy data
      // In production, uncomment the line below:
      // return await remoteDataSource.getOrdersByStore(storeId);
      return DummyDataInitializer.getOrdersByStore(storeId);
    } catch (e) {
      return DummyDataInitializer.getOrdersByStore(storeId);
    }
  }

  @override
  Future<Order> createOrder(Order order) async {
    try {
      return await remoteDataSource.createOrder(order);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Order> updateOrderStatus(String orderId, String status) async {
    try {
      return await remoteDataSource.updateOrderStatus(orderId, status);
    } catch (e) {
      rethrow;
    }
  }
}
