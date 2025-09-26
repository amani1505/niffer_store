class AppStrings {
  // App Info
  static const String appName = 'Multi-Store Commerce';
  static const String appVersion = '1.0.0';
  
  // Authentication
  static const String login = 'Login';
  static const String register = 'Register';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signUp = 'Sign Up';
  static const String signIn = 'Sign In';
  
  // Navigation
  static const String home = 'Home';
  static const String products = 'Products';
  static const String cart = 'Cart';
  static const String orders = 'Orders';
  static const String profile = 'Profile';
  static const String dashboard = 'Dashboard';
  static const String analytics = 'Analytics';
  static const String settings = 'Settings';
  
  // User Roles
  static const String superAdmin = 'Super Admin';
  static const String storeAdmin = 'Store Admin';
  static const String customer = 'Customer';
  
  // Product Related
  static const String addToCart = 'Add to Cart';
  static const String buyNow = 'Buy Now';
  static const String productDetails = 'Product Details';
  static const String price = 'Price';
  static const String description = 'Description';
  static const String category = 'Category';
  static const String inStock = 'In Stock';
  static const String outOfStock = 'Out of Stock';
  
  // Store Related
  static const String storeName = 'Store Name';
  static const String storeDescription = 'Store Description';
  static const String storeOwner = 'Store Owner';
  static const String manageStore = 'Manage Store';
  
  // Order Related
  static const String orderHistory = 'Order History';
  static const String orderDetails = 'Order Details';
  static const String orderStatus = 'Order Status';
  static const String pending = 'Pending';
  static const String processing = 'Processing';
  static const String shipped = 'Shipped';
  static const String delivered = 'Delivered';
  static const String cancelled = 'Cancelled';
  
  // General
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String sort = 'Sort';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String add = 'Add';
  static const String update = 'Update';
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String noDataFound = 'No data found';
  static const String retry = 'Retry';
  
  // Theme
  static const String lightMode = 'Light Mode';
  static const String darkMode = 'Dark Mode';
  static const String systemMode = 'System Mode';
}

// lib/core/constants/app_routes.dart
class AppRoutes {
  // Authentication Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  
  // Customer Routes
  static const String home = '/home';
  static const String productList = '/products';
  static const String productDetail = '/products/:id';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderHistory = '/orders';
  static const String profile = '/profile';
  
  // Vendor Routes
  static const String vendorDashboard = '/vendor';
  static const String vendorProducts = '/vendor/products';
  static const String vendorOrders = '/vendor/orders';
  static const String vendorAnalytics = '/vendor/analytics';
  static const String vendorSettings = '/vendor/settings';
  
  // Admin Routes
  static const String adminDashboard = '/admin';
  static const String usersManagement = '/admin/users';
  static const String storesManagement = '/admin/stores';
  static const String globalAnalytics = '/admin/analytics';
  static const String adminSettings = '/admin/settings';
}
