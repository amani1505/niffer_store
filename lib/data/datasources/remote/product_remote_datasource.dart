import 'package:niffer_store/core/constants/api_endpoints.dart';
import 'package:niffer_store/core/network/api_client.dart';
import 'package:niffer_store/data/models/category_model.dart';
import 'package:niffer_store/data/models/product_model.dart';
import 'package:niffer_store/domain/entities/product.dart';

class ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSource(this.apiClient);

  Future<List<ProductModel>> getProducts() async {
    final response = await apiClient.get(ApiEndpoints.products);
    final List<dynamic> data = response.data['products'] ?? [];
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<ProductModel> getProductById(String id) async {
    final endpoint = ApiEndpoints.productById.replaceAll('{id}', id);
    final response = await apiClient.get(endpoint);
    return ProductModel.fromJson(response.data);
  }

  Future<List<ProductModel>> getProductsByStore(String storeId) async {
    final endpoint = ApiEndpoints.productsByStore.replaceAll('{storeId}', storeId);
    final response = await apiClient.get(endpoint);
    final List<dynamic> data = response.data['products'] ?? [];
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    final endpoint = ApiEndpoints.productsByCategory.replaceAll('{categoryId}', categoryId);
    final response = await apiClient.get(endpoint);
    final List<dynamic> data = response.data['products'] ?? [];
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await apiClient.get(ApiEndpoints.categories);
    final List<dynamic> data = response.data['categories'] ?? [];
    return data.map((json) => CategoryModel.fromJson(json)).toList();
  }

  Future<ProductModel> createProduct(Product product) async {
    final productModel = product as ProductModel;
    final response = await apiClient.post(
      ApiEndpoints.products,
      data: productModel.toJson(),
    );
    return ProductModel.fromJson(response.data);
  }

  Future<ProductModel> updateProduct(Product product) async {
    final productModel = product as ProductModel;
    final endpoint = ApiEndpoints.productById.replaceAll('{id}', product.id);
    final response = await apiClient.put(
      endpoint,
      data: productModel.toJson(),
    );
    return ProductModel.fromJson(response.data);
  }

  Future<void> deleteProduct(String id) async {
    final endpoint = ApiEndpoints.productById.replaceAll('{id}', id);
    await apiClient.delete(endpoint);
  }
}