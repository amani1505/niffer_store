class ApiEndpoints {
  // Base URL - Update this with your server URL
  static const String baseUrl = 'https://your-api-server.com/api';
  
  // Authentication Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String getCurrentUser = '/auth/me';
  
  // User Endpoints
  static const String users = '/users';
  static const String userById = '/users/{id}';
  static const String updateUserRole = '/users/{id}/role';
  
  // Store Endpoints
  static const String stores = '/stores';
  static const String storeById = '/stores/{id}';
  static const String storeProducts = '/stores/{id}/products';
  static const String storeOrders = '/stores/{id}/orders';
  
  // Product Endpoints
  static const String products = '/products';
  static const String productById = '/products/{id}';
  static const String productsByCategory = '/products/category/{categoryId}';
  static const String productsByStore = '/products/store/{storeId}';
  static const String searchProducts = '/products/search';
  
  // Order Endpoints
  static const String orders = '/orders';
  static const String orderById = '/orders/{id}';
  static const String ordersByUser = '/orders/user/{userId}';
  static const String ordersByStore = '/orders/store/{storeId}';
  static const String updateOrderStatus = '/orders/{id}/status';
  
  // Category Endpoints
  static const String categories = '/categories';
  static const String categoryById = '/categories/{id}';
  
  // Analytics Endpoints
  static const String salesAnalytics = '/analytics/sales';
  static const String productAnalytics = '/analytics/products';
  static const String storeAnalytics = '/analytics/stores';
  static const String userAnalytics = '/analytics/users';
  
  // Cart Endpoints
  static const String addToCart = '/cart/add';
  static const String getCart = '/cart';
  static const String updateCartItem = '/cart/update';
  static const String removeFromCart = '/cart/remove';
  static const String clearCart = '/cart/clear';
}
