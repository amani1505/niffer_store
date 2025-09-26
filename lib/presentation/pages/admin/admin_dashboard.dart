import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:niffer_store/presentation/providers/auth_provider.dart';
import 'package:niffer_store/core/widgets/modern_bottom_sheet.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/constants/app_strings.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';
import 'package:niffer_store/core/widgets/page_skeletons.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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
      title: const Text('Admin Dashboard'),
      backgroundColor: AppColors.adminColor,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Show notifications
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
          _buildRecentActivity(),
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
                child: _buildRecentActivity(),
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
              colors: [AppColors.adminColor, AppColors.adminColor.withValues(alpha: 0.8)],
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
                      'Welcome back, ${user?.fullName ?? 'Admin'}!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your platform with comprehensive tools and analytics',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.admin_panel_settings,
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
      _StatCard(
        title: 'Total Users',
        value: '2,847',
        change: '+12.5%',
        isPositive: true,
        icon: Icons.people_outline,
        color: Colors.blue,
      ),
      _StatCard(
        title: 'Active Stores',
        value: '127',
        change: '+8.3%',
        isPositive: true,
        icon: Icons.store_outlined,
        color: Colors.green,
      ),
      _StatCard(
        title: 'Total Revenue',
        value: 'TZS 45.2M',
        change: '+15.7%',
        isPositive: true,
        icon: Icons.attach_money,
        color: Colors.orange,
      ),
      _StatCard(
        title: 'Platform Fee',
        value: 'TZS 2.3M',
        change: '+18.2%',
        isPositive: true,
        icon: Icons.account_balance,
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

  Widget _buildStatCard(_StatCard stat) {
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

  Widget _buildRecentActivity() {
    final activities = [
      _ActivityItem(
        title: 'New store registration',
        subtitle: 'TechShop Store joined the platform',
        time: '2 minutes ago',
        icon: Icons.store,
        iconColor: Colors.green,
      ),
      _ActivityItem(
        title: 'User reported issue',
        subtitle: 'Payment gateway error reported',
        time: '15 minutes ago',
        icon: Icons.report_problem,
        iconColor: Colors.orange,
      ),
      _ActivityItem(
        title: 'Store verification completed',
        subtitle: 'FashionHub Store verified successfully',
        time: '1 hour ago',
        icon: Icons.verified,
        iconColor: Colors.blue,
      ),
      _ActivityItem(
        title: 'Platform update deployed',
        subtitle: 'Version 2.1.5 released with bug fixes',
        time: '3 hours ago',
        icon: Icons.system_update,
        iconColor: Colors.purple,
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
                'Recent Activity',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Show all activities
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...activities.map((activity) => _buildActivityItem(activity)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(_ActivityItem activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activity.iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              activity.icon,
              color: activity.iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  activity.subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity.time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(
        title: 'User Management',
        description: 'Manage user accounts and permissions',
        icon: Icons.people_outline,
        color: Colors.blue,
        onTap: () => context.go(AppRoutes.usersManagement),
      ),
      _QuickAction(
        title: 'Store Management',
        description: 'Approve and manage store applications',
        icon: Icons.store_outlined,
        color: Colors.green,
        onTap: () => context.go(AppRoutes.storesManagement),
      ),
      _QuickAction(
        title: 'Global Analytics',
        description: 'View platform-wide performance metrics',
        icon: Icons.analytics_outlined,
        color: Colors.purple,
        onTap: () => context.go(AppRoutes.globalAnalytics),
      ),
      _QuickAction(
        title: 'System Settings',
        description: 'Configure platform settings and policies',
        icon: Icons.settings_outlined,
        color: Colors.orange,
        onTap: () => context.go(AppRoutes.adminSettings),
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

  Widget _buildQuickActionItem(_QuickAction action) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: action.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: action.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    action.icon,
                    color: action.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
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
                  size: 16,
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
      message: 'Are you sure you want to logout from your admin account?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
      icon: Icons.logout,
      isDangerous: true,
    );

    if (result == true) {
      await authProvider.logout();
    }
  }
}

// Data models for admin dashboard
class _StatCard {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.color,
  });
}

class _ActivityItem {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;

  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
  });
}

class _QuickAction {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}