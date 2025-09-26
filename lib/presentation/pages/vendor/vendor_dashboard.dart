import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:niffer_store/presentation/providers/auth_provider.dart';
import 'package:niffer_store/core/widgets/modern_bottom_sheet.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/constants/app_strings.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';
import 'package:niffer_store/core/widgets/page_skeletons.dart';

class VendorDashboard extends StatefulWidget {
  const VendorDashboard({super.key});

  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    // Simulate loading dashboard data
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _isLoading 
          ? const DashboardSkeleton()
          : ResponsiveLayout(
              mobile: _buildMobileLayout(),
              desktop: _buildDesktopLayout(),
            ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Store Dashboard'),
      backgroundColor: AppColors.vendorColor,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Show notifications
          },
        ),
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () {
            // Show help/support
          },
        ),
        Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () async {
                await _showLogoutBottomSheet(context, authProvider);
              },
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(),
          const SizedBox(height: 20),
          _buildStatsGrid(),
          const SizedBox(height: 20),
          _buildRecentOrders(),
          const SizedBox(height: 20),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(),
          const SizedBox(height: 24),
          _buildStatsGrid(),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildRecentOrders(),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildQuickActions(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.vendorColor, AppColors.vendorColor.withValues(alpha: 0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, ${user?.fullName ?? 'Store Owner'}!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your store, track sales, and grow your business',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.store,
                size: 64,
                color: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      _VendorStatCard(
        title: 'Total Sales',
        value: 'TZS 1.2M',
        change: '+23.5%',
        isPositive: true,
        icon: Icons.trending_up,
        color: Colors.green,
      ),
      _VendorStatCard(
        title: 'Products',
        value: '48',
        change: '+6',
        isPositive: true,
        icon: Icons.inventory_2,
        color: Colors.blue,
      ),
      _VendorStatCard(
        title: 'Orders',
        value: '127',
        change: '+18%',
        isPositive: true,
        icon: Icons.shopping_bag,
        color: Colors.orange,
      ),
      _VendorStatCard(
        title: 'Customers',
        value: '89',
        change: '+12%',
        isPositive: true,
        icon: Icons.people,
        color: Colors.purple,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: ResponsiveHelper.isMobile(context) ? 1.1 : 1.2,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => _buildStatCard(stats[index]),
    );
  }

  Widget _buildStatCard(_VendorStatCard stat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                stat.icon,
                color: stat.color,
                size: 24,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: stat.isPositive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  stat.change,
                  style: TextStyle(
                    color: stat.isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            stat.value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrders() {
    final orders = [
      _RecentOrder(
        orderNumber: '#ORD-2025-001',
        customerName: 'John Doe',
        amount: 'TZS 45,000',
        status: 'Completed',
        statusColor: Colors.green,
        time: '5 minutes ago',
      ),
      _RecentOrder(
        orderNumber: '#ORD-2025-002',
        customerName: 'Jane Smith',
        amount: 'TZS 23,500',
        status: 'Processing',
        statusColor: Colors.orange,
        time: '23 minutes ago',
      ),
      _RecentOrder(
        orderNumber: '#ORD-2025-003',
        customerName: 'Bob Johnson',
        amount: 'TZS 67,800',
        status: 'Shipped',
        statusColor: Colors.blue,
        time: '1 hour ago',
      ),
      _RecentOrder(
        orderNumber: '#ORD-2025-004',
        customerName: 'Alice Brown',
        amount: 'TZS 12,300',
        status: 'Pending',
        statusColor: Colors.grey,
        time: '3 hours ago',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Orders',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.vendorOrders),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...orders.map((order) => _buildOrderItem(order)),
        ],
      ),
    );
  }

  Widget _buildOrderItem(_RecentOrder order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              color: order.statusColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.orderNumber,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      order.amount,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.customerName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: order.statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        order.status,
                        style: TextStyle(
                          color: order.statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  order.time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      _VendorQuickAction(
        title: 'Add Product',
        description: 'Add new products to your store',
        icon: Icons.add_box_outlined,
        color: Colors.green,
        onTap: () => context.go(AppRoutes.vendorProducts),
      ),
      _VendorQuickAction(
        title: 'Manage Orders',
        description: 'View and process customer orders',
        icon: Icons.shopping_bag_outlined,
        color: Colors.orange,
        onTap: () => context.go(AppRoutes.vendorOrders),
      ),
      _VendorQuickAction(
        title: 'View Analytics',
        description: 'Track your store performance',
        icon: Icons.analytics_outlined,
        color: Colors.purple,
        onTap: () => context.go(AppRoutes.vendorAnalytics),
      ),
      _VendorQuickAction(
        title: 'Store Settings',
        description: 'Configure your store preferences',
        icon: Icons.settings_outlined,
        color: Colors.blue,
        onTap: () => context.go(AppRoutes.vendorSettings),
      ),
      _VendorQuickAction(
        title: 'Promotions',
        description: 'Create discounts and special offers',
        icon: Icons.local_offer_outlined,
        color: Colors.red,
        onTap: () {
          // Navigate to promotions
        },
      ),
      _VendorQuickAction(
        title: 'Customer Reviews',
        description: 'View feedback from customers',
        icon: Icons.star_outline,
        color: Colors.amber,
        onTap: () {
          // Navigate to reviews
        },
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...actions.map((action) => _buildQuickActionItem(action)),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(_VendorQuickAction action) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: action.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: action.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    action.icon,
                    color: action.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        action.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutBottomSheet(BuildContext context, AuthProvider authProvider) async {
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: 'Logout',
      message: 'Are you sure you want to logout from your store account?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
      icon: Icons.store_mall_directory_outlined,
      isDangerous: true,
    );

    if (result == true) {
      await authProvider.logout();
    }
  }
}

// Data models for vendor dashboard
class _VendorStatCard {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final Color color;

  const _VendorStatCard({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.color,
  });
}

class _RecentOrder {
  final String orderNumber;
  final String customerName;
  final String amount;
  final String status;
  final Color statusColor;
  final String time;

  const _RecentOrder({
    required this.orderNumber,
    required this.customerName,
    required this.amount,
    required this.status,
    required this.statusColor,
    required this.time,
  });
}

class _VendorQuickAction {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _VendorQuickAction({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}