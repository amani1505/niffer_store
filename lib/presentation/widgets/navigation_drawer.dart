import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/constants/app_strings.dart';
import 'package:niffer_store/core/enums/user_role.dart';
import 'package:niffer_store/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';


class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;
          
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildDrawerHeader(context, user?.fullName ?? 'Guest', user?.email ?? ''),
              
              // Common navigation items
              _buildDrawerItem(
                context,
                icon: Icons.home_outlined,
                title: 'Home',
                onTap: () => _navigateTo(context, AppRoutes.home),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.inventory_2_outlined,
                title: 'Products',
                onTap: () => _navigateTo(context, AppRoutes.productList),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.shopping_cart_outlined,
                title: 'Cart',
                onTap: () => _navigateTo(context, AppRoutes.cart),
              ),
              
              if (user != null) ...[
                _buildDrawerItem(
                  context,
                  icon: Icons.history,
                  title: 'Order History',
                  onTap: () => _navigateTo(context, AppRoutes.orderHistory),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_outline,
                  title: 'Profile',
                  onTap: () => _navigateTo(context, AppRoutes.profile),
                ),
              ],

              const Divider(),

              // Role-specific navigation
              if (user?.role == UserRole.storeAdmin) ...[
                _buildSectionHeader(context, 'Vendor Panel'),
                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard_outlined,
                  title: 'Vendor Dashboard',
                  onTap: () => _navigateTo(context, AppRoutes.vendorDashboard),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.inventory,
                  title: 'My Products',
                  onTap: () => _navigateTo(context, AppRoutes.vendorProducts),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.receipt_long,
                  title: 'Orders',
                  onTap: () => _navigateTo(context, AppRoutes.vendorOrders),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.analytics_outlined,
                  title: 'Analytics',
                  onTap: () => _navigateTo(context, AppRoutes.vendorAnalytics),
                ),
                const Divider(),
              ],

              if (user?.role == UserRole.superAdmin) ...[
                _buildSectionHeader(context, 'Admin Panel'),
                _buildDrawerItem(
                  context,
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'Admin Dashboard',
                  onTap: () => _navigateTo(context, AppRoutes.adminDashboard),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.people_outline,
                  title: 'Users',
                  onTap: () => _navigateTo(context, AppRoutes.usersManagement),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.store_outlined,
                  title: 'Stores',
                  onTap: () => _navigateTo(context, AppRoutes.storesManagement),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.analytics_outlined,
                  title: 'Global Analytics',
                  onTap: () => _navigateTo(context, AppRoutes.globalAnalytics),
                ),
                const Divider(),
              ],

              // Auth actions
              if (user == null) ...[
                _buildDrawerItem(
                  context,
                  icon: Icons.login,
                  title: 'Login',
                  onTap: () => _navigateTo(context, AppRoutes.login),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_add,
                  title: 'Register',
                  onTap: () => _navigateTo(context, AppRoutes.register),
                ),
              ] else ...[
                _buildDrawerItem(
                  context,
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, String name, String email) {
    return UserAccountsDrawerHeader(
      accountName: Text(name),
      accountEmail: Text(email),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'G',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
      dense: true,
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.of(context).pop(); // Close drawer
    context.go(route);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Close drawer
              context.read<AuthProvider>().logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}