import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/constants/app_strings.dart';
import 'package:niffer_store/core/utils/auth_utils.dart';
import 'package:niffer_store/presentation/providers/auth_provider.dart';
import 'package:niffer_store/presentation/providers/cart_provider.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  final String currentPath;

  const MainScaffold({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userRole = authProvider.currentUser?.role;

    return Scaffold(
      appBar: _shouldShowAppBar() ? _buildAppBar(context, userRole) : null,
      body: child,
      bottomNavigationBar: _buildBottomNavigation(context, userRole),
    );
  }

  bool _shouldShowAppBar() {
    // Show app bar for non-home pages
    final homeRoutes = ['/home', '/vendor', '/admin'];
    return !homeRoutes.contains(currentPath);
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, userRole) {
    String title = _getPageTitle();
    
    return AppBar(
      title: Text(title),
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            // Navigate to appropriate home based on user role
            context.go(_getHomeRouteForUser(userRole));
          }
        },
      ),
      actions: [
        // Add any additional actions if needed
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // Show options menu
          },
        ),
      ],
    );
  }

  String _getPageTitle() {
    switch (currentPath) {
      case '/products':
        return 'Products';
      case '/cart':
        return 'Shopping Cart';
      case '/orders':
        return 'Order History';
      case '/profile':
        return 'Profile';
      case '/vendor/products':
        return 'My Products';
      case '/vendor/orders':
        return 'Orders';
      case '/vendor/analytics':
        return 'Analytics';
      case '/vendor/settings':
        return 'Store Settings';
      case '/admin/users':
        return 'User Management';
      case '/admin/stores':
        return 'Store Management';
      case '/admin/analytics':
        return 'Global Analytics';
      case '/admin/settings':
        return 'Admin Settings';
      default:
        if (currentPath.startsWith('/products/')) {
          return 'Product Details';
        }
        return 'Niffer Store';
    }
  }

  String _getHomeRouteForUser(userRole) {
    if (userRole?.toString() == 'UserRole.superAdmin') {
      return '/admin';
    } else if (userRole?.toString() == 'UserRole.storeAdmin') {
      return '/vendor';
    } else {
      return '/home';
    }
  }

  Widget _buildBottomNavigation(BuildContext context, userRole) {
    final authProvider = context.watch<AuthProvider>();
    
    // Different navigation items based on user role
    if (authProvider.isAuthenticated) {
      if (userRole?.toString() == 'UserRole.superAdmin') {
        return _buildAdminBottomNav(context);
      } else if (userRole?.toString() == 'UserRole.storeAdmin') {
        return _buildVendorBottomNav(context);
      } else {
        return _buildCustomerBottomNav(context);
      }
    } else {
      // Show guest navigation for unauthenticated users
      return _buildGuestBottomNav(context);
    }
  }

  Widget _buildGuestBottomNav(BuildContext context) {
    int currentIndex = _getGuestCurrentIndex();
    
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onGuestNavTap(context, index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Products',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.login_outlined),
            activeIcon: Icon(Icons.login),
            label: 'Login',
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerBottomNav(BuildContext context) {
    int currentIndex = _getCustomerCurrentIndex();
    
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onCustomerNavTap(context, index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: _buildCustomerNavItems(context),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildCustomerNavItems(BuildContext context) {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.grid_view_outlined),
        activeIcon: Icon(Icons.grid_view),
        label: 'Products',
      ),
      BottomNavigationBarItem(
        icon: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return Badge(
              isLabelVisible: cartProvider.totalQuantity > 0,
              label: Text(cartProvider.totalQuantity.toString()),
              child: const Icon(Icons.shopping_cart_outlined),
            );
          },
        ),
        activeIcon: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return Badge(
              isLabelVisible: cartProvider.totalQuantity > 0,
              label: Text(cartProvider.totalQuantity.toString()),
              child: const Icon(Icons.shopping_cart),
            );
          },
        ),
        label: 'Cart',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.receipt_long_outlined),
        activeIcon: Icon(Icons.receipt_long),
        label: 'Orders',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }

  Widget _buildVendorBottomNav(BuildContext context) {
    int currentIndex = _getVendorCurrentIndex();
    
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onVendorNavTap(context, index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.vendorColor,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildAdminBottomNav(BuildContext context) {
    int currentIndex = _getAdminCurrentIndex();
    
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onAdminNavTap(context, index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.adminColor,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings_outlined),
            activeIcon: Icon(Icons.admin_panel_settings),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outlined),
            activeIcon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            activeIcon: Icon(Icons.store),
            label: 'Stores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined),
            activeIcon: Icon(Icons.trending_up),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  int _getGuestCurrentIndex() {
    switch (currentPath) {
      case '/home':
        return 0;
      case '/products':
        return 1;
      case '/login':
      case '/register':
        return 2;
      default:
        return 0;
    }
  }

  int _getCustomerCurrentIndex() {
    switch (currentPath) {
      case '/home':
        return 0;
      case '/products':
        return 1;
      case '/cart':
        return 2;
      case '/orders':
        return 3;
      case '/profile':
        return 4;
      default:
        return 0;
    }
  }

  int _getVendorCurrentIndex() {
    switch (currentPath) {
      case '/vendor':
        return 0;
      case '/vendor/products':
        return 1;
      case '/vendor/orders':
        return 2;
      case '/vendor/analytics':
        return 3;
      case '/vendor/settings':
        return 4;
      default:
        return 0;
    }
  }

  int _getAdminCurrentIndex() {
    switch (currentPath) {
      case '/admin':
        return 0;
      case '/admin/users':
        return 1;
      case '/admin/stores':
        return 2;
      case '/admin/analytics':
        return 3;
      case '/admin/settings':
        return 4;
      default:
        return 0;
    }
  }

  void _onGuestNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.productList);
        break;
      case 2:
        context.go(AppRoutes.login);
        break;
    }
  }

  void _onCustomerNavTap(BuildContext context, int index) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.productList);
        break;
      case 2:
        // Require auth for cart
        if (authProvider.isAuthenticated) {
          context.go(AppRoutes.cart);
        } else {
          await AuthUtils.requireAuthForCart(context);
        }
        break;
      case 3:
        // Require auth for orders
        if (authProvider.isAuthenticated) {
          context.go(AppRoutes.orderHistory);
        } else {
          await AuthUtils.requireAuthForOrders(context);
        }
        break;
      case 4:
        // Require auth for profile
        if (authProvider.isAuthenticated) {
          context.go(AppRoutes.profile);
        } else {
          await AuthUtils.requireAuthForProfile(context);
        }
        break;
    }
  }

  void _onVendorNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.vendorDashboard);
        break;
      case 1:
        context.go(AppRoutes.vendorProducts);
        break;
      case 2:
        context.go(AppRoutes.vendorOrders);
        break;
      case 3:
        context.go(AppRoutes.vendorAnalytics);
        break;
      case 4:
        context.go(AppRoutes.vendorSettings);
        break;
    }
  }

  void _onAdminNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.adminDashboard);
        break;
      case 1:
        context.go(AppRoutes.usersManagement);
        break;
      case 2:
        context.go(AppRoutes.storesManagement);
        break;
      case 3:
        context.go(AppRoutes.globalAnalytics);
        break;
      case 4:
        context.go(AppRoutes.adminSettings);
        break;
    }
  }
}