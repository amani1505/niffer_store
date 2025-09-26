import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';
import 'package:niffer_store/core/widgets/modern_toast.dart';
import 'package:niffer_store/core/widgets/modern_bottom_sheet.dart';
import 'package:niffer_store/core/widgets/skeleton_shimmer.dart';

class AdminOversightPage extends StatefulWidget {
  const AdminOversightPage({Key? key}) : super(key: key);

  @override
  State<AdminOversightPage> createState() => _AdminOversightPageState();
}

class _AdminOversightPageState extends State<AdminOversightPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadData() {
    setState(() => _isLoading = true);
    // Simulate loading
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Oversight'),
        backgroundColor: AppColors.adminColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Store Managers', icon: Icon(Icons.people)),
            Tab(text: 'Store Activity', icon: Icon(Icons.analytics)),
            Tab(text: 'System Logs', icon: Icon(Icons.list_alt)),
            Tab(text: 'Permissions', icon: Icon(Icons.security)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        desktop: _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildSearchAndFilter(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildStoreManagersTab(),
              _buildStoreActivityTab(),
              _buildSystemLogsTab(),
              _buildPermissionsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Container(
          width: 300,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              right: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Column(
            children: [
              _buildSearchAndFilter(),
              _buildSidebarTabs(),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildStoreManagersTab(),
              _buildStoreActivityTab(),
              _buildSystemLogsTab(),
              _buildPermissionsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.adminColor),
              ),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Active', 'Inactive', 'Suspended', 'New']
                  .map((filter) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: _selectedFilter == filter,
                          onSelected: (selected) {
                            setState(() => _selectedFilter = filter);
                          },
                          selectedColor: AppColors.adminColor.withValues(alpha: 0.2),
                          checkmarkColor: AppColors.adminColor,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarTabs() {
    return Expanded(
      child: ListView(
        children: [
          _buildSidebarTab(0, 'Store Managers', Icons.people),
          _buildSidebarTab(1, 'Store Activity', Icons.analytics),
          _buildSidebarTab(2, 'System Logs', Icons.list_alt),
          _buildSidebarTab(3, 'Permissions', Icons.security),
        ],
      ),
    );
  }

  Widget _buildSidebarTab(int index, String title, IconData icon) {
    final isSelected = _tabController.index == index;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => _tabController.animateTo(index),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected 
                ? AppColors.adminColor.withValues(alpha: 0.1)
                : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                ? Border.all(color: AppColors.adminColor.withValues(alpha: 0.3))
                : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.adminColor : Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? AppColors.adminColor : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreManagersTab() {
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: SkeletonList(
          itemCount: 8,
          itemBuilder: (index) => const SkeletonListTile(),
        ),
      );
    }

    final managers = _getFilteredManagers();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: managers.length,
      itemBuilder: (context, index) {
        final manager = managers[index];
        return _buildManagerCard(manager);
      },
    );
  }

  Widget _buildManagerCard(StoreManagerData manager) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _viewManagerDetails(manager),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: _getStatusColor(manager.status).withValues(alpha: 0.2),
                    child: Text(
                      manager.name[0].toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(manager.status),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          manager.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          manager.email,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(manager.status),
                  PopupMenuButton(
                    onSelected: (action) => _handleManagerAction(action, manager),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: ListTile(
                          leading: Icon(Icons.visibility),
                          title: Text('View Details'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'permissions',
                        child: ListTile(
                          leading: Icon(Icons.security),
                          title: Text('Manage Permissions'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'suspend',
                        child: ListTile(
                          leading: Icon(Icons.block, color: Colors.orange),
                          title: Text('Suspend Account'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Delete Account'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoChip('Store', manager.storeName),
                  const SizedBox(width: 8),
                  _buildInfoChip('Revenue', manager.monthlyRevenue),
                  const SizedBox(width: 8),
                  _buildInfoChip('Orders', '${manager.totalOrders}'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Last active: ${manager.lastActive}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    manager.location,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreActivityTab() {
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: SkeletonAnalyticsCard()),
                const SizedBox(width: 16),
                Expanded(child: SkeletonAnalyticsCard()),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SkeletonList(
                itemCount: 6,
                itemBuilder: (index) => const SkeletonCard(height: 80),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Activity Overview Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildActivityCard('New Stores', '12', '+3 this week', Colors.blue),
              _buildActivityCard('Active Orders', '1,234', '+18% today', Colors.green),
              _buildActivityCard('Revenue Today', 'TZS 2.3M', '+12.5%', Colors.purple),
              _buildActivityCard('Issues', '3', '-2 resolved', Colors.orange),
            ],
          ),
          const SizedBox(height: 24),
          // Recent Activities
          Text(
            'Recent Store Activities',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(5, (index) => _buildActivityItem(index)),
        ],
      ),
    );
  }

  Widget _buildSystemLogsTab() {
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: SkeletonList(
          itemCount: 10,
          itemBuilder: (index) => const SkeletonListTile(hasLeading: false),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 20,
      itemBuilder: (context, index) {
        return _buildLogItem(index);
      },
    );
  }

  Widget _buildPermissionsTab() {
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: SkeletonList(
          itemCount: 6,
          itemBuilder: (index) => const SkeletonCard(height: 120),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Role-Based Permissions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...['Store Manager', 'Assistant Manager', 'Staff Member']
              .map((role) => _buildPermissionCard(role)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'active':
        color = Colors.green;
        break;
      case 'inactive':
        color = Colors.grey;
        break;
      case 'suspended':
        color = Colors.orange;
        break;
      default:
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActivityCard(String title, String value, String change, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.trending_up, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              change,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(int index) {
    final activities = [
      {'store': 'Tech Haven', 'action': 'New order placed', 'time': '2 min ago', 'icon': Icons.shopping_bag},
      {'store': 'Fashion Forward', 'action': 'Product added', 'time': '15 min ago', 'icon': Icons.inventory},
      {'store': 'Home Garden', 'action': 'Payment received', 'time': '1 hour ago', 'icon': Icons.payment},
      {'store': 'Sports Central', 'action': 'Store settings updated', 'time': '2 hours ago', 'icon': Icons.settings},
      {'store': 'Book Paradise', 'action': 'Customer review received', 'time': '3 hours ago', 'icon': Icons.rate_review},
    ];

    final activity = activities[index];
    
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.adminColor.withValues(alpha: 0.1),
          child: Icon(activity['icon'] as IconData, color: AppColors.adminColor),
        ),
        title: Text(
          '${activity['store']}: ${activity['action']}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(activity['time'] as String),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showActivityDetails(activity),
        ),
      ),
    );
  }

  Widget _buildLogItem(int index) {
    final logTypes = ['INFO', 'WARNING', 'ERROR', 'DEBUG'];
    final logType = logTypes[index % logTypes.length];
    Color logColor;
    
    switch (logType) {
      case 'ERROR':
        logColor = Colors.red;
        break;
      case 'WARNING':
        logColor = Colors.orange;
        break;
      case 'DEBUG':
        logColor = Colors.blue;
        break;
      default:
        logColor = Colors.green;
    }

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: logColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            logType,
            style: TextStyle(
              color: logColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text('System log entry ${index + 1}'),
        subtitle: Text('${DateTime.now().subtract(Duration(hours: index)).toString().split('.')[0]} - User action performed'),
        trailing: IconButton(
          icon: const Icon(Icons.visibility),
          onPressed: () => _viewLogDetails(index),
        ),
      ),
    );
  }

  Widget _buildPermissionCard(String role) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  role,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => _editPermissions(role),
                  child: const Text('Edit'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildPermissionChip('View Orders', true),
                _buildPermissionChip('Manage Products', role != 'Staff Member'),
                _buildPermissionChip('Process Payments', role == 'Store Manager'),
                _buildPermissionChip('View Analytics', role != 'Staff Member'),
                _buildPermissionChip('Manage Staff', role == 'Store Manager'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionChip(String permission, bool hasAccess) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: hasAccess 
          ? Colors.green.withValues(alpha: 0.1)
          : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasAccess ? Icons.check : Icons.close,
            size: 14,
            color: hasAccess ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            permission,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: hasAccess ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.grey;
      case 'suspended':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  List<StoreManagerData> _getFilteredManagers() {
    // Mock data
    final allManagers = [
      StoreManagerData('Sarah Johnson', 'sarah@techhaven.com', 'Tech Haven Electronics', 'Active', 'TZS 1.2M', 847, '2 hours ago', 'Dar es Salaam'),
      StoreManagerData('Michael Chen', 'michael@fashionforward.com', 'Fashion Forward', 'Active', 'TZS 890K', 623, '1 hour ago', 'Arusha'),
      StoreManagerData('Emma Wilson', 'emma@homegarden.com', 'Home & Garden Plus', 'Inactive', 'TZS 456K', 234, '2 days ago', 'Mwanza'),
      StoreManagerData('David Brown', 'david@sportscentral.com', 'Sports Central', 'Suspended', 'TZS 234K', 156, '1 week ago', 'Dodoma'),
      StoreManagerData('Lisa Garcia', 'lisa@bookparadise.com', 'Book Paradise', 'Active', 'TZS 123K', 89, '30 min ago', 'Mbeya'),
    ];

    return allManagers.where((manager) {
      final matchesSearch = manager.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          manager.storeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          manager.email.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesFilter = _selectedFilter == 'All' || manager.status == _selectedFilter;
      
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _viewManagerDetails(StoreManagerData manager) {
    ModernBottomSheet.showCustom(
      context: context,
      title: 'Manager Details',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Name', manager.name),
          _buildDetailRow('Email', manager.email),
          _buildDetailRow('Store', manager.storeName),
          _buildDetailRow('Status', manager.status),
          _buildDetailRow('Monthly Revenue', manager.monthlyRevenue),
          _buildDetailRow('Total Orders', '${manager.totalOrders}'),
          _buildDetailRow('Last Active', manager.lastActive),
          _buildDetailRow('Location', manager.location),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _handleManagerAction(String action, StoreManagerData manager) {
    switch (action) {
      case 'view':
        _viewManagerDetails(manager);
        break;
      case 'permissions':
        ModernToast.info(context, 'Permission management for ${manager.name}');
        break;
      case 'suspend':
        _suspendManager(manager);
        break;
      case 'delete':
        _deleteManager(manager);
        break;
    }
  }

  void _suspendManager(StoreManagerData manager) async {
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: 'Suspend Manager',
      message: 'Are you sure you want to suspend ${manager.name}? They will lose access to their store.',
      confirmText: 'Suspend',
      cancelText: 'Cancel',
      icon: Icons.block,
      isDangerous: true,
    );

    if (result == true && mounted) {
      ModernToast.success(context, '${manager.name} has been suspended');
    }
  }

  void _deleteManager(StoreManagerData manager) async {
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: 'Delete Manager Account',
      message: 'This will permanently delete ${manager.name}\'s account and all associated data. This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      icon: Icons.delete_forever,
      isDangerous: true,
    );

    if (result == true && mounted) {
      ModernToast.error(context, '${manager.name}\'s account has been deleted');
    }
  }

  void _showActivityDetails(Map<String, dynamic> activity) {
    ModernToast.info(context, 'Activity details for ${activity['store']}');
  }

  void _viewLogDetails(int index) {
    ModernToast.info(context, 'Viewing log details for entry ${index + 1}');
  }

  void _editPermissions(String role) {
    ModernToast.info(context, 'Editing permissions for $role');
  }
}

class StoreManagerData {
  final String name;
  final String email;
  final String storeName;
  final String status;
  final String monthlyRevenue;
  final int totalOrders;
  final String lastActive;
  final String location;

  StoreManagerData(
    this.name,
    this.email,
    this.storeName,
    this.status,
    this.monthlyRevenue,
    this.totalOrders,
    this.lastActive,
    this.location,
  );
}