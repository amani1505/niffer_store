import 'package:niffer_store/core/constants/api_endpoints.dart';
import 'package:niffer_store/core/network/api_client.dart';
import 'package:niffer_store/data/models/store_model.dart';
import 'package:niffer_store/domain/entities/store.dart';

class StoreRemoteDataSource {
  final ApiClient apiClient;

  StoreRemoteDataSource(this.apiClient);

  Future<List<StoreModel>> getStores() async {
    final response = await apiClient.get(ApiEndpoints.stores);
    final List<dynamic> data = response.data['stores'] ?? [];
    return data.map((json) => StoreModel.fromJson(json)).toList();
  }

  Future<StoreModel> getStoreById(String id) async {
    final endpoint = ApiEndpoints.storeById.replaceAll('{id}', id);
    final response = await apiClient.get(endpoint);
    return StoreModel.fromJson(response.data);
  }

  Future<StoreModel> createStore(Store store) async {
    final storeModel = store as StoreModel;
    final response = await apiClient.post(
      ApiEndpoints.stores,
      data: storeModel.toJson(),
    );
    return StoreModel.fromJson(response.data);
  }

  Future<StoreModel> updateStore(Store store) async {
    final storeModel = store as StoreModel;
    final endpoint = ApiEndpoints.storeById.replaceAll('{id}', store.id);
    final response = await apiClient.put(
      endpoint,
      data: storeModel.toJson(),
    );
    return StoreModel.fromJson(response.data);
  }

  Future<void> deleteStore(String id) async {
    final endpoint = ApiEndpoints.storeById.replaceAll('{id}', id);
    await apiClient.delete(endpoint);
  }
}