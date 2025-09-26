import 'package:niffer_store/domain/entities/category.dart';
import 'package:niffer_store/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(String id);
  Future<List<Product>> getProductsByStore(String storeId);
  Future<List<Product>> getProductsByCategory(String categoryId);
  Future<List<Category>> getCategories();
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}
