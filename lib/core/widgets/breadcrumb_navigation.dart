import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:niffer_store/core/constants/app_colors.dart';

class BreadcrumbNavigation extends StatelessWidget {
  final String currentPath;
  final List<BreadcrumbItem> items;

  const BreadcrumbNavigation({
    super.key,
    required this.currentPath,
    required this.items,
  });

  factory BreadcrumbNavigation.fromPath(String path) {
    final items = _generateBreadcrumbs(path);
    return BreadcrumbNavigation(
      currentPath: path,
      items: items,
    );
  }

  static List<BreadcrumbItem> _generateBreadcrumbs(String path) {
    final List<BreadcrumbItem> breadcrumbs = [];
    
    if (path == '/home' || path == '/vendor' || path == '/admin') {
      return breadcrumbs; // No breadcrumbs for home pages
    }

    // Always add home as the first item
    if (path.startsWith('/admin/')) {
      breadcrumbs.add(BreadcrumbItem(title: 'Admin Dashboard', path: '/admin'));
    } else if (path.startsWith('/vendor/')) {
      breadcrumbs.add(BreadcrumbItem(title: 'Vendor Dashboard', path: '/vendor'));
    } else {
      breadcrumbs.add(BreadcrumbItem(title: 'Home', path: '/home'));
    }

    // Add intermediate breadcrumbs based on path
    switch (path) {
      case '/products':
        breadcrumbs.add(BreadcrumbItem(title: 'Products', path: '/products', isActive: true));
        break;
      case '/cart':
        breadcrumbs.add(BreadcrumbItem(title: 'Shopping Cart', path: '/cart', isActive: true));
        break;
      case '/orders':
        breadcrumbs.add(BreadcrumbItem(title: 'Order History', path: '/orders', isActive: true));
        break;
      case '/profile':
        breadcrumbs.add(BreadcrumbItem(title: 'Profile', path: '/profile', isActive: true));
        break;
      case '/vendor/products':
        breadcrumbs.add(BreadcrumbItem(title: 'My Products', path: '/vendor/products', isActive: true));
        break;
      case '/vendor/orders':
        breadcrumbs.add(BreadcrumbItem(title: 'Orders', path: '/vendor/orders', isActive: true));
        break;
      case '/vendor/analytics':
        breadcrumbs.add(BreadcrumbItem(title: 'Analytics', path: '/vendor/analytics', isActive: true));
        break;
      case '/vendor/settings':
        breadcrumbs.add(BreadcrumbItem(title: 'Store Settings', path: '/vendor/settings', isActive: true));
        break;
      case '/admin/users':
        breadcrumbs.add(BreadcrumbItem(title: 'User Management', path: '/admin/users', isActive: true));
        break;
      case '/admin/stores':
        breadcrumbs.add(BreadcrumbItem(title: 'Store Management', path: '/admin/stores', isActive: true));
        break;
      case '/admin/analytics':
        breadcrumbs.add(BreadcrumbItem(title: 'Global Analytics', path: '/admin/analytics', isActive: true));
        break;
      case '/admin/settings':
        breadcrumbs.add(BreadcrumbItem(title: 'Admin Settings', path: '/admin/settings', isActive: true));
        break;
      default:
        if (path.startsWith('/products/')) {
          breadcrumbs.add(BreadcrumbItem(title: 'Products', path: '/products'));
          breadcrumbs.add(BreadcrumbItem(title: 'Product Details', path: path, isActive: true));
        }
    }

    return breadcrumbs;
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: items.expand((item) {
                  final index = items.indexOf(item);
                  return [
                    _buildBreadcrumbItem(context, item),
                    if (index < items.length - 1) _buildSeparator(),
                  ];
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumbItem(BuildContext context, BreadcrumbItem item) {
    return GestureDetector(
      onTap: item.isActive ? null : () => context.go(item.path),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: item.isActive ? AppColors.primary.withValues(alpha: 0.1) : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          item.title,
          style: TextStyle(
            color: item.isActive 
              ? AppColors.primary 
              : AppColors.textSecondary,
            fontWeight: item.isActive 
              ? FontWeight.w600 
              : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.chevron_right,
        size: 16,
        color: AppColors.textSecondary.withValues(alpha: 0.5),
      ),
    );
  }
}

class BreadcrumbItem {
  final String title;
  final String path;
  final bool isActive;

  const BreadcrumbItem({
    required this.title,
    required this.path,
    this.isActive = false,
  });
}

// Enhanced back button widget with more functionality
class SmartBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;

  const SmartBackButton({
    super.key,
    this.onPressed,
    this.tooltip,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      tooltip: tooltip ?? 'Back',
      color: color,
      onPressed: onPressed ?? () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          // Determine home route based on current route
          String currentRoute = GoRouterState.of(context).matchedLocation;
          String homeRoute = '/home';
          
          if (currentRoute.startsWith('/admin')) {
            homeRoute = '/admin';
          } else if (currentRoute.startsWith('/vendor')) {
            homeRoute = '/vendor';
          }
          
          context.go(homeRoute);
        }
      },
    );
  }
}