import 'package:flutter/foundation.dart';
import 'package:niffer_store/data/repositories/product_repository_impl.dart';
import 'package:niffer_store/domain/entities/product.dart';
import 'package:niffer_store/domain/entities/category.dart' as entities;

class ProductProvider extends ChangeNotifier {
  final ProductRepositoryImpl _productRepository;

  ProductProvider(this._productRepository);

  List<Product> _products = [];
  List<entities.Category> _categories = [];
  List<Product> _filteredProducts = [];
  Product? _selectedProduct;
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String? _selectedCategoryId;

  // Getters
  List<Product> get products => _products;
  List<entities.Category> get categories => _categories;
  List<Product> get filteredProducts => _filteredProducts.isEmpty ? _products : _filteredProducts;
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String? get selectedCategoryId => _selectedCategoryId;

  Future<void> loadProducts({String? storeId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (storeId != null) {
        _products = await _productRepository.getProductsByStore(storeId);
      } else {
        _products = await _productRepository.getProducts();
      }
      _applyFilters();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    try {
      _categories = await _productRepository.getCategories();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> getProductById(String productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedProduct = await _productRepository.getProductById(productId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void filterByCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      bool matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesCategory = _selectedCategoryId == null ||
          product.categoryId == _selectedCategoryId;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategoryId = null;
    _filteredProducts.clear();
    notifyListeners();
  }

  Future<bool> createProduct(Product product) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newProduct = await _productRepository.createProduct(product);
      _products.insert(0, newProduct);
      _applyFilters();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProduct(Product product) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedProduct = await _productRepository.updateProduct(product);
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = updatedProduct;
      }
      _applyFilters();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      await _productRepository.deleteProduct(productId);
      _products.removeWhere((p) => p.id == productId);
      _applyFilters();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadMoreProducts({String? storeId}) async {
    // Simulate loading more products for infinite scroll
    try {
      final moreProducts = await _productRepository.getProducts();
      // In a real app, this would be pagination with offset/limit
      final newProducts = moreProducts.where((product) => 
          !_products.any((existing) => existing.id == product.id)).toList();
      
      if (newProducts.isNotEmpty) {
        _products.addAll(newProducts.take(10)); // Add only 10 more items
        _applyFilters();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}