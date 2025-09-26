import 'package:flutter/foundation.dart';
import 'package:niffer_store/data/repositories/store_repository.dart';
import 'package:niffer_store/domain/entities/store.dart';

class StoreProvider extends ChangeNotifier {
  final StoreRepositoryImpl _storeRepository;

  StoreProvider(this._storeRepository);

  List<Store> _stores = [];
  Store? _selectedStore;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Store> get stores => _stores;
  Store? get selectedStore => _selectedStore;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadStores() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _stores = await _storeRepository.getStores();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getStoreById(String storeId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedStore = await _storeRepository.getStoreById(storeId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createStore(Store store) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newStore = await _storeRepository.createStore(store);
      _stores.insert(0, newStore);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateStore(Store store) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedStore = await _storeRepository.updateStore(store);
      final index = _stores.indexWhere((s) => s.id == store.id);
      if (index != -1) {
        _stores[index] = updatedStore;
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

  Future<bool> deleteStore(String storeId) async {
    try {
      await _storeRepository.deleteStore(storeId);
      _stores.removeWhere((s) => s.id == storeId);
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
}