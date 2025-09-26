import 'package:niffer_store/domain/entities/store.dart';

abstract class StoreRepository {
  Future<List<Store>> getStores();
  Future<Store> getStoreById(String id);
  Future<Store> createStore(Store store);
  Future<Store> updateStore(Store store);
  Future<void> deleteStore(String id);
}