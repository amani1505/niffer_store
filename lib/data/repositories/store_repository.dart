import 'package:niffer_store/data/datasources/remote/store_remote_datasource.dart';
import 'package:niffer_store/domain/entities/store.dart';
import 'package:niffer_store/domain/repositories/store_repository.dart';
import 'package:niffer_store/dummy_data/dummy_data_initializer.dart';

class StoreRepositoryImpl implements StoreRepository {
  final StoreRemoteDataSource remoteDataSource;

  StoreRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Store>> getStores() async {
    try {
      // For demo purposes, use dummy data
      // In production, uncomment the line below:
      // return await remoteDataSource.getStores();
      return DummyDataInitializer.getStores();
    } catch (e) {
      return DummyDataInitializer.getStores();
    }
  }

  @override
  Future<Store> getStoreById(String id) async {
    try {
      // For demo purposes, use dummy data
      // In production, uncomment the line below:
      // return await remoteDataSource.getStoreById(id);
      final store = DummyDataInitializer.getStoreById(id);
      if (store != null) {
        return store;
      }
      throw Exception('Store not found');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Store> createStore(Store store) async {
    try {
      return await remoteDataSource.createStore(store);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Store> updateStore(Store store) async {
    try {
      return await remoteDataSource.updateStore(store);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteStore(String id) async {
    try {
      await remoteDataSource.deleteStore(id);
    } catch (e) {
      rethrow;
    }
  }
}