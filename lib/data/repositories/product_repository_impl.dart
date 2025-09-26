

import 'package:niffer_store/data/datasources/remote/product_remote_datasource.dart';
import 'package:niffer_store/domain/entities/category.dart';
import 'package:niffer_store/domain/entities/product.dart';
import 'package:niffer_store/domain/repositories/product_repository.dart';
import 'package:niffer_store/dummy_data/dummy_data_initializer.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts() async {
    try {
      // For demo purposes, use dummy data
      // In production, uncomment the line below:
      // return await remoteDataSource.getProducts();
      return DummyDataInitializer.getProducts();
    } catch (e) {
      // Fallback to dummy data
      return DummyDataInitializer.getProducts();
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      // For demo purposes, use dummy data
      // In production, uncomment the line below:
      // return await remoteDataSource.getProductById(id);
      final product = DummyDataInitializer.getProductById(id);
      if (product != null) {
        return product;
      }
      throw Exception('Product not found');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getProductsByStore(String storeId) async {
    try {
      // For demo purposes, use dummy data
      // In production, uncomment the line below:
      // return await remoteDataSource.getProductsByStore(storeId);
      return DummyDataInitializer.getProductsByStore(storeId);
    } catch (e) {
      return DummyDataInitializer.getProductsByStore(storeId);
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      // For demo purposes, use dummy data
      // In production, uncomment the line below:
      // return await remoteDataSource.getProductsByCategory(categoryId);
      return DummyDataInitializer.getProductsByCategory(categoryId);
    } catch (e) {
      return DummyDataInitializer.getProductsByCategory(categoryId);
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      // For demo purposes, use dummy data
      // In production, uncomment the line below:
      // return await remoteDataSource.getCategories();
      return DummyDataInitializer.getCategories();
    } catch (e) {
      return DummyDataInitializer.getCategories();
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    try {
      return await remoteDataSource.createProduct(product);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      return await remoteDataSource.updateProduct(product);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await remoteDataSource.deleteProduct(id);
    } catch (e) {
      rethrow;
    }
  }
}
















