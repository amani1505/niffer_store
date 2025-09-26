import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';
import 'package:niffer_store/core/widgets/modern_bottom_sheet.dart';
import 'package:niffer_store/core/widgets/modern_toast.dart';

class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({Key? key}) : super(key: key);

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _searchQuery = '';

  // Mock user data
  List<UserData> _users = [
    UserData(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      role: 'Customer',
      status: 'Active',
      joinDate: '2024-01-15',
      totalOrders: 12,
      totalSpent: 'TZS 245,000',
    ),
    UserData(
      id: '2',
      name: 'Alice Smith',
      email: 'alice@techstore.com',
      role: 'Store Admin',
      status: 'Active',
      joinDate: '2023-11-08',
      totalOrders: 0,
      totalSpent: 'TZS 0',
    ),
    UserData(
      id: '3',
      name: 'Bob Johnson',
      email: 'bob@example.com',
      role: 'Customer',
      status: 'Suspended',
      joinDate: '2024-02-20',
      totalOrders: 3,
      totalSpent: 'TZS 67,500',
    ),
    UserData(
      id: '4',
      name: 'Sarah Wilson',
      email: 'sarah@fashionhub.com',
      role: 'Store Admin',
      status: 'Active',
      joinDate: '2023-09-12',
      totalOrders: 0,
      totalSpent: 'TZS 0',
    ),
    UserData(
      id: '5',
      name: 'Mike Brown',
      email: 'mike@example.com',
      role: 'Customer',
      status: 'Active',
      joinDate: '2024-03-05',
      totalOrders: 8,
      totalSpent: 'TZS 156,800',
    ),
  ];

  List<UserData> get _filteredUsers {
    var filtered = _users.where((user) {
      if (_selectedFilter != 'All' && user.role != _selectedFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty &&
          !user.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !user.email.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Management'),
        backgroundColor: AppColors.adminColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showAddUserDialog(),
            tooltip: 'Add User',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportUsers(),
            tooltip: 'Export Users',
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
        _buildHeader(),
        _buildFilters(),
        Expanded(
          child: _buildUsersList(),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        _buildHeader(),
        _buildFilters(),
        Expanded(
          child: _buildUsersTable(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Management',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage user accounts, permissions, and activities',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search users by name or email...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final filters = ['All', 'Customer', 'Store Admin'];
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            'Filter by Role:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          ...filters.map((filter) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: _selectedFilter == filter,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              selectedColor: AppColors.adminColor.withValues(alpha: 0.2),
              checkmarkColor: AppColors.adminColor,
            ),
          )),
          const Spacer(),
          Text(
            '${_filteredUsers.length} users found',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredUsers.length,
      itemBuilder: (context, index) {
        final user = _filteredUsers[index];
        return _buildUserCard(user);
      },
    );
  }

  Widget _buildUserCard(UserData user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getRoleColor(user.role).withValues(alpha: 0.1),
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: TextStyle(
                      color: _getRoleColor(user.role),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(user.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip('Role', user.role, _getRoleColor(user.role)),
                const SizedBox(width: 8),
                _buildInfoChip('Joined', user.joinDate, Colors.blue),
                if (user.role == 'Customer') ...[
                  const SizedBox(width: 8),
                  _buildInfoChip('Orders', user.totalOrders.toString(), Colors.orange),
                ],
              ],
            ),
            if (user.role == 'Customer') ...[
              const SizedBox(height: 8),
              Text(
                'Total Spent: ${user.totalSpent}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => _viewUserDetails(user),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View'),
                ),
                TextButton.icon(
                  onPressed: () => _editUser(user),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                ),
                if (user.status == 'Active')
                  TextButton.icon(
                    onPressed: () => _suspendUser(user),
                    icon: const Icon(Icons.block, size: 16),
                    label: const Text('Suspend'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  )
                else
                  TextButton.icon(
                    onPressed: () => _activateUser(user),
                    icon: const Icon(Icons.check_circle, size: 16),
                    label: const Text('Activate'),
                    style: TextButton.styleFrom(foregroundColor: Colors.green),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('User')),
            DataColumn(label: Text('Role')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Join Date')),
            DataColumn(label: Text('Orders')),
            DataColumn(label: Text('Total Spent')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _filteredUsers.map((user) {
            return DataRow(
              cells: [
                DataCell(
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: _getRoleColor(user.role).withValues(alpha: 0.1),
                        child: Text(
                          user.name[0].toUpperCase(),
                          style: TextStyle(
                            color: _getRoleColor(user.role),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                          Text(user.email, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                DataCell(_buildInfoChip('', user.role, _getRoleColor(user.role))),
                DataCell(_buildStatusChip(user.status)),
                DataCell(Text(user.joinDate)),
                DataCell(Text(user.totalOrders.toString())),
                DataCell(Text(user.totalSpent)),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility, size: 16),
                        onPressed: () => _viewUserDetails(user),
                        tooltip: 'View',
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 16),
                        onPressed: () => _editUser(user),
                        tooltip: 'Edit',
                      ),
                      if (user.status == 'Active')
                        IconButton(
                          icon: const Icon(Icons.block, size: 16, color: Colors.red),
                          onPressed: () => _suspendUser(user),
                          tooltip: 'Suspend',
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.check_circle, size: 16, color: Colors.green),
                          onPressed: () => _activateUser(user),
                          tooltip: 'Activate',
                        ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final color = status == 'Active' ? Colors.green : Colors.red;
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

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label.isEmpty ? value : '$label: $value',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Store Admin':
        return AppColors.vendorColor;
      case 'Customer':
        return AppColors.primary;
      default:
        return Colors.grey;
    }
  }

  void _showAddUserDialog() {
    ModernBottomSheet.showCustom(
      context: context,
      title: 'Add New User',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('User creation functionality will be available soon.'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _exportUsers() {
    ModernToast.success(
      context,
      'User export functionality coming soon!',
    );
  }

  void _viewUserDetails(UserData user) {
    ModernBottomSheet.showCustom(
      context: context,
      title: 'User Details',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDetailRow('Name', user.name),
          _buildDetailRow('Email', user.email),
          _buildDetailRow('Role', user.role),
          _buildDetailRow('Status', user.status),
          _buildDetailRow('Join Date', user.joinDate),
          if (user.role == 'Customer') ...[
            _buildDetailRow('Total Orders', user.totalOrders.toString()),
            _buildDetailRow('Total Spent', user.totalSpent),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _editUser(UserData user) {
    ModernBottomSheet.showCustom(
      context: context,
      title: 'Edit User',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Edit functionality for ${user.name} will be available soon.'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _suspendUser(UserData user) async {
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: 'Suspend User',
      message: 'Are you sure you want to suspend ${user.name}? They will lose access to their account.',
      confirmText: 'Suspend',
      cancelText: 'Cancel',
      icon: Icons.block,
      isDangerous: true,
    );

    if (result == true) {
      setState(() {
        final index = _users.indexWhere((u) => u.id == user.id);
        if (index != -1) {
          _users[index] = user.copyWith(status: 'Suspended');
        }
      });
      if (mounted) {
        ModernToast.success(
          context,
          '${user.name} has been suspended',
        );
      }
    }
  }

  void _activateUser(UserData user) async {
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: 'Activate User',
      message: 'Are you sure you want to activate ${user.name}? They will regain access to their account.',
      confirmText: 'Activate',
      cancelText: 'Cancel',
      icon: Icons.check_circle,
      isDangerous: false,
    );

    if (result == true) {
      setState(() {
        final index = _users.indexWhere((u) => u.id == user.id);
        if (index != -1) {
          _users[index] = user.copyWith(status: 'Active');
        }
      });
      if (mounted) {
        ModernToast.success(
          context,
          '${user.name} has been activated',
        );
      }
    }
  }
}

// Data model for user information
class UserData {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;
  final String joinDate;
  final int totalOrders;
  final String totalSpent;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.joinDate,
    required this.totalOrders,
    required this.totalSpent,
  });

  UserData copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? status,
    String? joinDate,
    int? totalOrders,
    String? totalSpent,
  }) {
    return UserData(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      joinDate: joinDate ?? this.joinDate,
      totalOrders: totalOrders ?? this.totalOrders,
      totalSpent: totalSpent ?? this.totalSpent,
    );
  }
}