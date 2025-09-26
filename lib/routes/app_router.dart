import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:niffer_store/core/constants/app_strings.dart';
import 'package:niffer_store/core/enums/user_role.dart';
import 'package:niffer_store/presentation/pages/admin/admin_dashboard.dart';
import 'package:niffer_store/presentation/pages/admin/admin_settings_page.dart';
import 'package:niffer_store/presentation/pages/admin/global_analytics_page.dart';
import 'package:niffer_store/presentation/pages/admin/stores_management_page.dart';
import 'package:niffer_store/presentation/pages/admin/users_management_page.dart';
import 'package:niffer_store/presentation/pages/auth/login_page.dart';
import 'package:niffer_store/presentation/pages/auth/register_page.dart';
import 'package:niffer_store/presentation/pages/customer/cart_page.dart';
import 'package:niffer_store/presentation/pages/customer/checkout_page.dart';
import 'package:niffer_store/presentation/pages/customer/home_page.dart';
import 'package:niffer_store/presentation/pages/customer/order_history_page.dart';
import 'package:niffer_store/presentation/pages/customer/product_detail_page.dart';
import 'package:niffer_store/presentation/pages/customer/product_list_page.dart';
import 'package:niffer_store/presentation/pages/customer/profile_page.dart';
import 'package:niffer_store/presentation/pages/shared/splash_page.dart';
import 'package:niffer_store/presentation/pages/shared/onboarding_page.dart';
import 'package:niffer_store/presentation/pages/vendor/vendor_analytics_page.dart';
import 'package:niffer_store/presentation/pages/vendor/vendor_dashboard.dart';
import 'package:niffer_store/presentation/pages/vendor/vendor_orders_page.dart';
import 'package:niffer_store/presentation/pages/vendor/vendor_products_page.dart';
import 'package:niffer_store/presentation/pages/vendor/vendor_store_settings.dart';
import 'package:niffer_store/presentation/providers/auth_provider.dart';
import 'package:niffer_store/presentation/widgets/main_scaffold.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.splash,
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final currentUser = authProvider.currentUser;

        // Public routes that don't require authentication
        final publicRoutes = [
          AppRoutes.splash,
          AppRoutes.onboarding,
          AppRoutes.login,
          AppRoutes.register,
          AppRoutes.home,
          AppRoutes.productList,
          AppRoutes.productDetail,
        ];

        final isPublicRoute = publicRoutes.contains(state.matchedLocation) || 
                              state.matchedLocation.startsWith('/products/');

        // If not authenticated and trying to access protected route
        if (!isAuthenticated && !isPublicRoute) {
          return AppRoutes.login;
        }

        // If authenticated and trying to access auth pages
        if (isAuthenticated && [AppRoutes.login, AppRoutes.register].contains(state.matchedLocation)) {
          return _getHomeRouteForUser(currentUser?.role);
        }

        // Role-based routing
        if (isAuthenticated && currentUser != null) {
          final userRole = currentUser.role;
          final requestedRoute = state.matchedLocation;

          // Check if user has permission to access the route
          if (!_hasPermissionForRoute(userRole, requestedRoute)) {
            return _getHomeRouteForUser(userRole);
          }
        }

        return null; // No redirect needed
      },
      routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      
      // Shell route for main app pages with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(
            currentPath: state.matchedLocation,
            child: child,
          );
        },
        routes: [
          // Customer Routes
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.productList,
            builder: (context, state) => const ProductListPage(),
          ),
          GoRoute(
            path: AppRoutes.productDetail,
            builder: (context, state) {
              final productId = state.pathParameters['id']!;
              return ProductDetailPage(productId: productId);
            },
          ),
          GoRoute(
            path: AppRoutes.cart,
            builder: (context, state) => const CartPage(),
          ),
          GoRoute(
            path: AppRoutes.checkout,
            builder: (context, state) => const CheckoutPage(),
          ),
          GoRoute(
            path: AppRoutes.orderHistory,
            builder: (context, state) => const OrderHistoryPage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfilePage(),
          ),

          // Vendor Routes
          GoRoute(
            path: AppRoutes.vendorDashboard,
            builder: (context, state) => const VendorDashboard(),
          ),
          GoRoute(
            path: AppRoutes.vendorProducts,
            builder: (context, state) => const VendorProductsPage(),
          ),
          GoRoute(
            path: AppRoutes.vendorOrders,
            builder: (context, state) => const VendorOrdersPage(),
          ),
          GoRoute(
            path: AppRoutes.vendorAnalytics,
            builder: (context, state) => const VendorAnalyticsPage(),
          ),
          GoRoute(
            path: AppRoutes.vendorSettings,
            builder: (context, state) => const VendorStoreSettings(),
          ),

          // Admin Routes
          GoRoute(
            path: AppRoutes.adminDashboard,
            builder: (context, state) => const AdminDashboard(),
          ),
          GoRoute(
            path: AppRoutes.usersManagement,
            builder: (context, state) => const UsersManagementPage(),
          ),
          GoRoute(
            path: AppRoutes.storesManagement,
            builder: (context, state) => const StoresManagementPage(),
          ),
          GoRoute(
            path: AppRoutes.globalAnalytics,
            builder: (context, state) => const GlobalAnalyticsPage(),
          ),
          GoRoute(
            path: AppRoutes.adminSettings,
            builder: (context, state) => const AdminSettingsPage(),
          ),
        ],
      ),
    ],
    );
  }

  static String _getHomeRouteForUser(UserRole? role) {
    switch (role) {
      case UserRole.superAdmin:
        return AppRoutes.adminDashboard;
      case UserRole.storeAdmin:
        return AppRoutes.vendorDashboard;
      case UserRole.customer:
      default:
        return AppRoutes.home;
    }
  }

  static bool _hasPermissionForRoute(UserRole userRole, String route) {
    // Admin routes - only super admin can access
    const adminRoutes = [
      AppRoutes.adminDashboard,
      AppRoutes.usersManagement,
      AppRoutes.storesManagement,
      AppRoutes.globalAnalytics,
      AppRoutes.adminSettings,
    ];

    // Vendor routes - store admins and super admins can access
    const vendorRoutes = [
      AppRoutes.vendorDashboard,
      AppRoutes.vendorProducts,
      AppRoutes.vendorOrders,
      AppRoutes.vendorAnalytics,
      AppRoutes.vendorSettings,
    ];

    // Public browsing routes - no authentication required
    const publicBrowsingRoutes = [
      AppRoutes.home,
      AppRoutes.productList,
      AppRoutes.productDetail,
    ];

    // Protected customer routes - require authentication
    const protectedCustomerRoutes = [
      AppRoutes.cart,
      AppRoutes.checkout,
      AppRoutes.orderHistory,
      AppRoutes.profile,
    ];

    if (adminRoutes.any((r) => route.startsWith(r))) {
      return userRole == UserRole.superAdmin;
    }

    if (vendorRoutes.any((r) => route.startsWith(r))) {
      return userRole == UserRole.superAdmin || userRole == UserRole.storeAdmin;
    }

    if (publicBrowsingRoutes.any((r) => route.startsWith(r)) || route.startsWith('/products/')) {
      return true; // Allow all users including unauthenticated to browse
    }

    if (protectedCustomerRoutes.any((r) => route.startsWith(r))) {
      return true; // All authenticated users can access protected customer routes
    }

    return false;
  }
}