import 'package:flutter/foundation.dart';
import 'package:niffer_store/core/services/storage_service.dart';
import 'package:niffer_store/domain/entities/cart.dart';
import 'dart:convert';
import 'package:niffer_store/domain/entities/product.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  bool _isGuestMode = true; // Default to guest mode
  
  bool get isGuestMode => _isGuestMode;
  static const String _cartKey = 'cart_items';
  static const String _guestCartKey = 'guest_cart_items';

  List<CartItem> get items => _items;
  int get itemCount => _items.length;
  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  bool get isEmpty => _items.isEmpty;

  CartProvider() {
    _loadCart(isGuest: true); // Start in guest mode by default
  }

  /// Switch to guest cart when user logs out
  void switchToGuestCart() {
    _isGuestMode = true;
    _loadCart(isGuest: true);
  }

  /// Merge guest cart with user cart when user logs in
  Future<void> switchToUserCart() async {
    final guestItems = await _loadCartFromStorage(_guestCartKey);
    if (guestItems.isNotEmpty) {
      // Load existing user cart first
      final userItems = await _loadCartFromStorage(_cartKey);
      _items = List.from(userItems);
      
      // Merge guest items with user items
      for (final guestItem in guestItems) {
        final existingIndex = _items.indexWhere((item) => item.productId == guestItem.productId);
        if (existingIndex >= 0) {
          // Add quantities if same product exists
          _items[existingIndex] = CartItem(
            id: _items[existingIndex].id,
            productId: guestItem.productId,
            productName: guestItem.productName,
            productImage: guestItem.productImage,
            price: guestItem.price,
            quantity: _items[existingIndex].quantity + guestItem.quantity,
            storeId: guestItem.storeId,
            storeName: guestItem.storeName,
          );
        } else {
          // Add new item
          _items.add(guestItem);
        }
      }
      // Clear guest cart after merging
      await StorageService.remove(_guestCartKey);
    } else {
      // No guest items, just load user cart
      _items = await _loadCartFromStorage(_cartKey);
    }
    _isGuestMode = false;
    _saveCart();
    notifyListeners();
  }

  Future<void> _loadCart({bool isGuest = false}) async {
    _items = await _loadCartFromStorage(isGuest ? _guestCartKey : _cartKey);
    notifyListeners();
  }

  Future<List<CartItem>> _loadCartFromStorage(String key) async {
    final cartData = StorageService.getString(key);
    if (cartData != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(cartData);
        return jsonList.map((json) => _cartItemFromJson(json)).toList();
      } catch (e) {
        debugPrint('Error loading cart from $key: $e');
      }
    }
    return [];
  }

  Future<void> _saveCart() async {
    try {
      final jsonList = _items.map((item) => _cartItemToJson(item)).toList();
      final storageKey = _isGuestMode ? _guestCartKey : _cartKey;
      await StorageService.saveString(storageKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  void addItem(Product product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) => item.productId == product.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex] = CartItem(
        id: _items[existingIndex].id,
        productId: product.id,
        productName: product.name,
        productImage: product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
        price: product.finalPrice,
        quantity: _items[existingIndex].quantity + quantity,
        storeId: product.storeId,
        storeName: '', // Will be populated from store data
      );
    } else {
      _items.add(CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: product.id,
        productName: product.name,
        productImage: product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
        price: product.finalPrice,
        quantity: quantity,
        storeId: product.storeId,
        storeName: '', // Will be populated from store data
      ));
    }

    _saveCart();
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    _saveCart();
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      _items[index] = CartItem(
        id: _items[index].id,
        productId: _items[index].productId,
        productName: _items[index].productName,
        productImage: _items[index].productImage,
        price: _items[index].price,
        quantity: quantity,
        storeId: _items[index].storeId,
        storeName: _items[index].storeName,
      );
      _saveCart();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  int getItemQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.productId == productId,
      orElse: () => const CartItem(
        id: '',
        productId: '',
        productName: '',
        productImage: '',
        price: 0,
        quantity: 0,
        storeId: '',
        storeName: '',
      ),
    );
    return item.quantity;
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.productId == productId);
  }

  // Helper methods for JSON serialization
  Map<String, dynamic> _cartItemToJson(CartItem item) {
    return {
      'id': item.id,
      'product_id': item.productId,
      'product_name': item.productName,
      'product_image': item.productImage,
      'price': item.price,
      'quantity': item.quantity,
      'store_id': item.storeId,
      'store_name': item.storeName,
    };
  }

  CartItem _cartItemFromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      productImage: json['product_image'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 0,
      storeId: json['store_id'] ?? '',
      storeName: json['store_name'] ?? '',
    );
  }
}