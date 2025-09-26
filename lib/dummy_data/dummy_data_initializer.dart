import 'package:niffer_store/core/enums/order_status.dart';
import 'package:niffer_store/core/enums/user_role.dart';
import 'package:niffer_store/data/models/category_model.dart';
import 'package:niffer_store/data/models/order_model.dart';
import 'package:niffer_store/data/models/product_model.dart';
import 'package:niffer_store/data/models/store_model.dart';
import 'package:niffer_store/data/models/user_model.dart';

class DummyDataInitializer {
  static List<UserModel> users = [];
  static List<StoreModel> stores = [];
  static List<ProductModel> products = [];
  static List<CategoryModel> categories = [];
  static List<OrderModel> orders = [];

  static Future<void> initialize() async {
    _initializeUsers();
    _initializeCategories();
    _initializeStores();
    _initializeProducts();
    _initializeOrders();
  }

  static void _initializeUsers() {
    final now = DateTime.now();
    users = [
      // Super Admin
      UserModel(
        id: '1',
        email: 'admin@ecommerce.com',
        firstName: 'Super',
        lastName: 'Admin',
        role: UserRole.superAdmin,
        phoneNumber: '+1234567890',
        createdAt: now.subtract(const Duration(days: 365)),
        updatedAt: now,
        isActive: true,
      ),
      
      // Store Admins
      UserModel(
        id: '2',
        email: 'vendor1@store.com',
        firstName: 'Tech',
        lastName: 'Store Owner',
        role: UserRole.storeAdmin,
        storeId: '1',
        phoneNumber: '+1234567891',
        createdAt: now.subtract(const Duration(days: 200)),
        updatedAt: now,
      ),
      UserModel(
        id: '3',
        email: 'vendor2@fashion.com',
        firstName: 'Fashion',
        lastName: 'Boutique Owner',
        role: UserRole.storeAdmin,
        storeId: '2',
        phoneNumber: '+1234567892',
        createdAt: now.subtract(const Duration(days: 150)),
        updatedAt: now,
      ),
      UserModel(
        id: '4',
        email: 'vendor3@home.com',
        firstName: 'Home',
        lastName: 'Goods Owner',
        role: UserRole.storeAdmin,
        storeId: '3',
        phoneNumber: '+1234567893',
        createdAt: now.subtract(const Duration(days: 100)),
        updatedAt: now,
      ),

      // Customers
      UserModel(
        id: '5',
        email: 'customer1@email.com',
        firstName: 'John',
        lastName: 'Doe',
        role: UserRole.customer,
        phoneNumber: '+1234567894',
        createdAt: now.subtract(const Duration(days: 50)),
        updatedAt: now,
      ),
      UserModel(
        id: '6',
        email: 'customer2@email.com',
        firstName: 'Jane',
        lastName: 'Smith',
        role: UserRole.customer,
        phoneNumber: '+1234567895',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
    ];
  }

  static void _initializeCategories() {
    final now = DateTime.now();
    categories = [
      CategoryModel(
        id: '1',
        name: 'Electronics',
        description: 'Electronic devices and gadgets',
        iconUrl: 'https://via.placeholder.com/64x64/4CAF50/FFFFFF?text=📱',
        createdAt: now.subtract(const Duration(days: 300)),
        updatedAt: now,
      ),
      CategoryModel(
        id: '2',
        name: 'Fashion',
        description: 'Clothing and accessories',
        iconUrl: 'https://via.placeholder.com/64x64/E91E63/FFFFFF?text=👗',
        createdAt: now.subtract(const Duration(days: 300)),
        updatedAt: now,
      ),
      CategoryModel(
        id: '3',
        name: 'Home & Garden',
        description: 'Home improvement and garden supplies',
        iconUrl: 'https://via.placeholder.com/64x64/FF9800/FFFFFF?text=🏠',
        createdAt: now.subtract(const Duration(days: 300)),
        updatedAt: now,
      ),
      CategoryModel(
        id: '4',
        name: 'Sports & Outdoor',
        description: 'Sports equipment and outdoor gear',
        iconUrl: 'https://via.placeholder.com/64x64/2196F3/FFFFFF?text=⚽',
        createdAt: now.subtract(const Duration(days: 300)),
        updatedAt: now,
      ),
      CategoryModel(
        id: '5',
        name: 'Books & Media',
        description: 'Books, movies, and digital media',
        iconUrl: 'https://via.placeholder.com/64x64/9C27B0/FFFFFF?text=📚',
        createdAt: now.subtract(const Duration(days: 300)),
        updatedAt: now,
      ),
    ];
  }

  static void _initializeStores() {
    final now = DateTime.now();
    stores = [
      StoreModel(
        id: '1',
        name: 'TechHub Electronics',
        description: 'Your one-stop shop for all electronic needs',
        ownerId: '2',
        logoUrl: 'https://via.placeholder.com/150x150/4CAF50/FFFFFF?text=TH',
        bannerUrl: 'https://via.placeholder.com/800x300/4CAF50/FFFFFF?text=TechHub',
        address: '123 Tech Street, Digital City, TC 12345',
        phoneNumber: '+1234567891',
        email: 'contact@techhub.com',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 200)),
        updatedAt: now,
        rating: 4.5,
        totalProducts: 15,
        totalOrders: 250,
      ),
      StoreModel(
        id: '2',
        name: 'Fashion Forward',
        description: 'Latest trends in fashion and accessories',
        ownerId: '3',
        logoUrl: 'https://via.placeholder.com/150x150/E91E63/FFFFFF?text=FF',
        bannerUrl: 'https://via.placeholder.com/800x300/E91E63/FFFFFF?text=Fashion',
        address: '456 Fashion Ave, Style City, SC 67890',
        phoneNumber: '+1234567892',
        email: 'hello@fashionforward.com',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 150)),
        updatedAt: now,
        rating: 4.2,
        totalProducts: 12,
        totalOrders: 180,
      ),
      StoreModel(
        id: '3',
        name: 'Home Sweet Home',
        description: 'Everything you need to make your house a home',
        ownerId: '4',
        logoUrl: 'https://via.placeholder.com/150x150/FF9800/FFFFFF?text=HSH',
        bannerUrl: 'https://via.placeholder.com/800x300/FF9800/FFFFFF?text=Home',
        address: '789 Home Blvd, Comfort Town, CT 13579',
        phoneNumber: '+1234567893',
        email: 'info@homesweethome.com',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 100)),
        updatedAt: now,
        rating: 4.7,
        totalProducts: 20,
        totalOrders: 320,
      ),
    ];
  }

  static void _initializeProducts() {
    final now = DateTime.now();
    products = [
      // TechHub Electronics Products
      ProductModel(
        id: '1',
        name: 'iPhone 14 Pro',
        description: 'Latest Apple iPhone with Pro camera system',
        price: 999.99,
        discountPrice: 899.99,
        storeId: '1',
        categoryId: '1',
        imageUrls: [
          'https://via.placeholder.com/400x400/000000/FFFFFF?text=iPhone14Pro',
          'https://via.placeholder.com/400x400/1a1a1a/FFFFFF?text=Back',
          'https://via.placeholder.com/400x400/2a2a2a/FFFFFF?text=Side',
        ],
        stockQuantity: 50,
        sku: 'IPH14PRO-128-BLK',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 60)),
        updatedAt: now,
        rating: 4.8,
        reviewCount: 120,
      ),
      ProductModel(
        id: '2',
        name: 'MacBook Air M2',
        description: 'Ultra-thin laptop with M2 chip',
        price: 1199.99,
        storeId: '1',
        categoryId: '1',
        imageUrls: [
          'https://via.placeholder.com/400x400/C0C0C0/000000?text=MacBookAir',
          'https://via.placeholder.com/400x400/D0D0D0/000000?text=Open',
        ],
        stockQuantity: 25,
        sku: 'MBA-M2-256-SLV',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now,
        rating: 4.9,
        reviewCount: 85,
      ),
      ProductModel(
        id: '3',
        name: 'Samsung Galaxy S23',
        description: 'Flagship Android smartphone',
        price: 799.99,
        discountPrice: 699.99,
        storeId: '1',
        categoryId: '1',
        imageUrls: [
          'https://via.placeholder.com/400x400/1e3a8a/FFFFFF?text=GalaxyS23',
        ],
        stockQuantity: 40,
        sku: 'SGS23-256-BLU',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
        rating: 4.6,
        reviewCount: 95,
      ),

      // Fashion Forward Products
      ProductModel(
        id: '4',
        name: 'Designer Leather Jacket',
        description: 'Premium leather jacket with modern design',
        price: 299.99,
        discountPrice: 249.99,
        storeId: '2',
        categoryId: '2',
        imageUrls: [
          'https://via.placeholder.com/400x400/8B4513/FFFFFF?text=Leather+Jacket',
          'https://via.placeholder.com/400x400/A0522D/FFFFFF?text=Back+View',
        ],
        stockQuantity: 15,
        sku: 'LJ-BLK-L',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 40)),
        updatedAt: now,
        rating: 4.4,
        reviewCount: 32,
      ),
      ProductModel(
        id: '5',
        name: 'Summer Floral Dress',
        description: 'Light and breezy summer dress with floral pattern',
        price: 89.99,
        storeId: '2',
        categoryId: '2',
        imageUrls: [
          'https://via.placeholder.com/400x400/FFB6C1/000000?text=Floral+Dress',
        ],
        stockQuantity: 30,
        sku: 'FD-SUM-M',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now,
        rating: 4.3,
        reviewCount: 28,
      ),

      // Home Sweet Home Products
      ProductModel(
        id: '6',
        name: 'Smart LED Bulb Set',
        description: 'WiFi-enabled smart bulbs with color changing',
        price: 49.99,
        discountPrice: 39.99,
        storeId: '3',
        categoryId: '3',
        imageUrls: [
          'https://via.placeholder.com/400x400/FFD700/000000?text=Smart+Bulb',
        ],
        stockQuantity: 100,
        sku: 'SLB-4PK-RGB',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 35)),
        updatedAt: now,
        rating: 4.5,
        reviewCount: 67,
      ),
      ProductModel(
        id: '7',
        name: 'Ceramic Coffee Mug Set',
        description: 'Set of 4 handcrafted ceramic mugs',
        price: 34.99,
        storeId: '3',
        categoryId: '3',
        imageUrls: [
          'https://via.placeholder.com/400x400/8B4513/FFFFFF?text=Coffee+Mugs',
        ],
        stockQuantity: 60,
        sku: 'CCM-4PK-WHT',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now,
        rating: 4.7,
        reviewCount: 43,
      ),
    ];
  }

  static void _initializeOrders() {
    final now = DateTime.now();
    orders = [
      OrderModel(
        id: '1',
        userId: '5',
        items: [
          OrderItemModel(
            id: '1',
            productId: '1',
            productName: 'iPhone 14 Pro',
            productImage: 'https://via.placeholder.com/400x400/000000/FFFFFF?text=iPhone14Pro',
            price: 899.99,
            quantity: 1,
            storeId: '1',
          ),
        ],
        totalAmount: 899.99,
        status: OrderStatus.delivered,
        shippingAddress: '123 Customer St, Customer City, CC 12345',
        notes: 'Please deliver during business hours',
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 3)),
        deliveredAt: now.subtract(const Duration(days: 3)),
      ),
      OrderModel(
        id: '2',
        userId: '6',
        items: [
          OrderItemModel(
            id: '2',
            productId: '4',
            productName: 'Designer Leather Jacket',
            productImage: 'https://via.placeholder.com/400x400/8B4513/FFFFFF?text=Leather+Jacket',
            price: 249.99,
            quantity: 1,
            storeId: '2',
          ),
          OrderItemModel(
            id: '3',
            productId: '6',
            productName: 'Smart LED Bulb Set',
            productImage: 'https://via.placeholder.com/400x400/FFD700/000000?text=Smart+Bulb',
            price: 39.99,
            quantity: 2,
            storeId: '3',
          ),
        ],
        totalAmount: 329.97,
        status: OrderStatus.shipped,
        shippingAddress: '456 Buyer Ave, Buyer Town, BT 67890',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  // Helper methods to get dummy data
  static List<UserModel> getUsers() => users;
  static List<StoreModel> getStores() => stores;
  static List<ProductModel> getProducts() => products;
  static List<CategoryModel> getCategories() => categories;
  static List<OrderModel> getOrders() => orders;

  static UserModel? getUserById(String id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  static StoreModel? getStoreById(String id) {
    try {
      return stores.firstWhere((store) => store.id == id);
    } catch (e) {
      return null;
    }
  }

  static ProductModel? getProductById(String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<ProductModel> getProductsByStore(String storeId) {
    return products.where((product) => product.storeId == storeId).toList();
  }

  static List<ProductModel> getProductsByCategory(String categoryId) {
    return products.where((product) => product.categoryId == categoryId).toList();
  }

  static List<OrderModel> getOrdersByUser(String userId) {
    return orders.where((order) => order.userId == userId).toList();
  }

  static List<OrderModel> getOrdersByStore(String storeId) {
    return orders.where((order) => 
      order.items.any((item) => item.storeId == storeId)
    ).toList();
  }
}
