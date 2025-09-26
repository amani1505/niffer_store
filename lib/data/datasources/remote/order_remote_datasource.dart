import 'package:niffer_store/core/constants/api_endpoints.dart';
import 'package:niffer_store/core/network/api_client.dart';
import 'package:niffer_store/data/models/order_model.dart';
import 'package:niffer_store/domain/entities/order.dart';

class OrderRemoteDataSource {
  final ApiClient apiClient;

  OrderRemoteDataSource(this.apiClient);

  Future<List<OrderModel>> getOrders() async {
    final response = await apiClient.get(ApiEndpoints.orders);
    final List<dynamic> data = response.data['orders'] ?? [];
    return data.map((json) => OrderModel.fromJson(json)).toList();
  }

  Future<OrderModel> getOrderById(String id) async {
    final endpoint = ApiEndpoints.orderById.replaceAll('{id}', id);
    final response = await apiClient.get(endpoint);
    return OrderModel.fromJson(response.data);
  }

  Future<List<OrderModel>> getOrdersByUser(String userId) async {
    final endpoint = ApiEndpoints.ordersByUser.replaceAll('{userId}', userId);
    final response = await apiClient.get(endpoint);
    final List<dynamic> data = response.data['orders'] ?? [];
    return data.map((json) => OrderModel.fromJson(json)).toList();
  }

  Future<List<OrderModel>> getOrdersByStore(String storeId) async {
    final endpoint = ApiEndpoints.ordersByStore.replaceAll('{storeId}', storeId);
    final response = await apiClient.get(endpoint);
    final List<dynamic> data = response.data['orders'] ?? [];
    return data.map((json) => OrderModel.fromJson(json)).toList();
  }

  Future<OrderModel> createOrder(Order order) async {
    final orderModel = order as OrderModel;
    final response = await apiClient.post(
      ApiEndpoints.orders,
      data: orderModel.toJson(),
    );
    return OrderModel.fromJson(response.data);
  }

  Future<OrderModel> updateOrderStatus(String orderId, String status) async {
    final endpoint = ApiEndpoints.updateOrderStatus.replaceAll('{id}', orderId);
    final response = await apiClient.put(
      endpoint,
      data: {'status': status},
    );
    return OrderModel.fromJson(response.data);
  }
}