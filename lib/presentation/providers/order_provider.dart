
import 'package:flutter/foundation.dart';
import 'package:niffer_store/core/enums/order_status.dart';
import 'package:niffer_store/data/repositories/order_repository_impl.dart';
import 'package:niffer_store/domain/entities/order.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepositoryImpl _orderRepository;

  OrderProvider(this._orderRepository);

  List<Order> _orders = [];
  List<Order> _userOrders = [];
  List<Order> _storeOrders = [];
  Order? _selectedOrder;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Order> get orders => _orders;
  List<Order> get userOrders => _userOrders;
  List<Order> get storeOrders => _storeOrders;
  Order? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _orderRepository.getOrders();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserOrders(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userOrders = await _orderRepository.getOrdersByUser(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadStoreOrders(String storeId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _storeOrders = await _orderRepository.getOrdersByStore(storeId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getOrderById(String orderId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedOrder = await _orderRepository.getOrderById(orderId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createOrder(Order order) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newOrder = await _orderRepository.createOrder(order);
      _orders.insert(0, newOrder);
      _userOrders.insert(0, newOrder);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedOrder = await _orderRepository.updateOrderStatus(orderId, status.value);
      
      // Update in all lists
      _updateOrderInList(_orders, updatedOrder);
      _updateOrderInList(_userOrders, updatedOrder);
      _updateOrderInList(_storeOrders, updatedOrder);
      
      if (_selectedOrder?.id == orderId) {
        _selectedOrder = updatedOrder;
      }
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateOrderInList(List<Order> list, Order updatedOrder) {
    final index = list.indexWhere((o) => o.id == updatedOrder.id);
    if (index != -1) {
      list[index] = updatedOrder;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
