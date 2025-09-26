import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';
import 'package:niffer_store/core/widgets/modern_bottom_sheet.dart';
import 'package:niffer_store/core/widgets/modern_toast.dart';

class StoresManagementPage extends StatefulWidget {
  const StoresManagementPage({Key? key}) : super(key: key);

  @override
  State<StoresManagementPage> createState() => _StoresManagementPageState();
}

class _StoresManagementPageState extends State<StoresManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _searchQuery = '';

  // Mock store data
  List<StoreData> _stores = [
    StoreData(
      id: '1',
      name: 'TechHub Electronics',
      owner: 'Alice Smith',
      email: 'alice@techhub.com',
      status: 'Active',
      category: 'Electronics',
      joinDate: '2023-08-15',
      totalProducts: 45,
      totalRevenue: 'TZS 2.1M',
      commission: 'TZS 315K',
      rating: 4.8,
      totalOrders: 287,
    ),
    StoreData(
      id: '2',
      name: 'Fashion Forward',
      owner: 'Sarah Wilson',
      email: 'sarah@fashionforward.com',
      status: 'Pending',
      category: 'Fashion',
      joinDate: '2024-01-22',
      totalProducts: 0,
      totalRevenue: 'TZS 0',
      commission: 'TZS 0',
      rating: 0.0,
      totalOrders: 0,
    ),
    StoreData(
      id: '3',
      name: 'Home & Garden Plus',
      owner: 'Mike Johnson',
      email: 'mike@homegardenplus.com',
      status: 'Active',
      category: 'Home & Garden',
      joinDate: '2023-11-03',
      totalProducts: 62,
      totalRevenue: 'TZS 890K',
      commission: 'TZS 133K',
      rating: 4.5,
      totalOrders: 156,
    ),
    StoreData(
      id: '4',
      name: 'Sports Central',
      owner: 'John Davis',
      email: 'john@sportscentral.com',
      status: 'Suspended',
      category: 'Sports',
      joinDate: '2023-05-12',
      totalProducts: 23,
      totalRevenue: 'TZS 456K',
      commission: 'TZS 68K',
      rating: 3.8,
      totalOrders: 89,
    ),
  ];

  List<StoreData> get _filteredStores {
    return _stores.where((store) {
      if (_selectedFilter != 'All' && store.status != _selectedFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty &&
          !store.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !store.owner.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
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
        title: const Text('Stores Management'),
        backgroundColor: AppColors.adminColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => _viewStoreAnalytics(),
            tooltip: 'View Analytics',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportStores(),
            tooltip: 'Export Stores',
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
          child: _buildStoresList(),
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
          child: _buildStoresTable(),
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
            'Store Management',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage store applications, approvals, and performance monitoring',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search stores by name or owner...',
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
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final filters = ['All', 'Active', 'Pending', 'Suspended'];
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            'Filter by Status:',
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
            '${_filteredStores.length} stores found',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoresList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredStores.length,
      itemBuilder: (context, index) {
        final store = _filteredStores[index];
        return _buildStoreCard(store);
      },
    );
  }

  Widget _buildStoreCard(StoreData store) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.vendorColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.store,
                    color: AppColors.vendorColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Owner: ${store.owner}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        store.email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(store.status),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildInfoChip('Category', store.category, Colors.blue),
                _buildInfoChip('Products', store.totalProducts.toString(), Colors.green),
                if (store.status == 'Active') ...[
                  _buildInfoChip('Orders', store.totalOrders.toString(), Colors.orange),
                  _buildInfoChip('Revenue', store.totalRevenue, Colors.purple),
                ],
              ],
            ),
            if (store.status == 'Active' && store.rating > 0) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    store.rating.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Commission: ${store.commission}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => _viewStoreDetails(store),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View'),
                ),
                if (store.status == 'Pending')
                  TextButton.icon(
                    onPressed: () => _approveStore(store),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Approve'),
                    style: TextButton.styleFrom(foregroundColor: Colors.green),
                  ),
                if (store.status == 'Active')
                  TextButton.icon(
                    onPressed: () => _suspendStore(store),
                    icon: const Icon(Icons.block, size: 16),
                    label: const Text('Suspend'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                if (store.status == 'Suspended')
                  TextButton.icon(
                    onPressed: () => _reactivateStore(store),
                    icon: const Icon(Icons.check_circle, size: 16),
                    label: const Text('Reactivate'),
                    style: TextButton.styleFrom(foregroundColor: Colors.green),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoresTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Store')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Products')),
            DataColumn(label: Text('Revenue')),
            DataColumn(label: Text('Rating')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _filteredStores.map((store) {
            return DataRow(
              cells: [
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(store.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text(store.owner, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                DataCell(Text(store.category)),
                DataCell(_buildStatusChip(store.status)),
                DataCell(Text(store.totalProducts.toString())),
                DataCell(Text(store.totalRevenue)),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(store.rating.toString()),
                    ],
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility, size: 16),
                        onPressed: () => _viewStoreDetails(store),
                        tooltip: 'View',
                      ),
                      if (store.status == 'Pending')
                        IconButton(
                          icon: const Icon(Icons.check, size: 16, color: Colors.green),
                          onPressed: () => _approveStore(store),
                          tooltip: 'Approve',
                        ),
                      if (store.status == 'Active')
                        IconButton(
                          icon: const Icon(Icons.block, size: 16, color: Colors.red),
                          onPressed: () => _suspendStore(store),
                          tooltip: 'Suspend',
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
    Color color;
    switch (status) {
      case 'Active':
        color = Colors.green;
        break;
      case 'Pending':
        color = Colors.orange;
        break;
      case 'Suspended':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
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

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _viewStoreDetails(StoreData store) {
    ModernBottomSheet.showCustom(
      context: context,
      title: 'Store Details',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDetailRow('Store Name', store.name),
          _buildDetailRow('Owner', store.owner),
          _buildDetailRow('Email', store.email),
          _buildDetailRow('Category', store.category),
          _buildDetailRow('Status', store.status),
          _buildDetailRow('Join Date', store.joinDate),
          _buildDetailRow('Products', store.totalProducts.toString()),
          if (store.status == 'Active') ...[
            _buildDetailRow('Total Orders', store.totalOrders.toString()),
            _buildDetailRow('Revenue', store.totalRevenue),
            _buildDetailRow('Commission', store.commission),
            _buildDetailRow('Rating', store.rating.toString()),
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

  void _approveStore(StoreData store) async {
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: 'Approve Store',
      message: 'Are you sure you want to approve ${store.name}? The store will become active and able to start selling.',
      confirmText: 'Approve',
      cancelText: 'Cancel',
      icon: Icons.check_circle,
      isDangerous: false,
    );

    if (result == true) {
      setState(() {
        final index = _stores.indexWhere((s) => s.id == store.id);
        if (index != -1) {
          _stores[index] = store.copyWith(status: 'Active');
        }
      });
      if (mounted) {
        ModernToast.success(
          context,
          '${store.name} has been approved!',
        );
      }
    }
  }

  void _suspendStore(StoreData store) async {
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: 'Suspend Store',
      message: 'Are you sure you want to suspend ${store.name}? The store will be unable to process orders.',
      confirmText: 'Suspend',
      cancelText: 'Cancel',
      icon: Icons.block,
      isDangerous: true,
    );

    if (result == true) {
      setState(() {
        final index = _stores.indexWhere((s) => s.id == store.id);
        if (index != -1) {
          _stores[index] = store.copyWith(status: 'Suspended');
        }
      });
      if (mounted) {
        ModernToast.success(
          context,
          '${store.name} has been suspended',
        );
      }
    }
  }

  void _reactivateStore(StoreData store) async {
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: 'Reactivate Store',
      message: 'Are you sure you want to reactivate ${store.name}? The store will be able to process orders again.',
      confirmText: 'Reactivate',
      cancelText: 'Cancel',
      icon: Icons.check_circle,
      isDangerous: false,
    );

    if (result == true) {
      setState(() {
        final index = _stores.indexWhere((s) => s.id == store.id);
        if (index != -1) {
          _stores[index] = store.copyWith(status: 'Active');
        }
      });
      if (mounted) {
        ModernToast.success(
          context,
          '${store.name} has been reactivated',
        );
      }
    }
  }

  void _viewStoreAnalytics() {
    ModernToast.info(
      context,
      'Store analytics view coming soon!',
    );
  }

  void _exportStores() {
    ModernToast.success(
      context,
      'Store export functionality coming soon!',
    );
  }
}

// Data model for store information
class StoreData {
  final String id;
  final String name;
  final String owner;
  final String email;
  final String status;
  final String category;
  final String joinDate;
  final int totalProducts;
  final String totalRevenue;
  final String commission;
  final double rating;
  final int totalOrders;

  StoreData({
    required this.id,
    required this.name,
    required this.owner,
    required this.email,
    required this.status,
    required this.category,
    required this.joinDate,
    required this.totalProducts,
    required this.totalRevenue,
    required this.commission,
    required this.rating,
    required this.totalOrders,
  });

  StoreData copyWith({
    String? id,
    String? name,
    String? owner,
    String? email,
    String? status,
    String? category,
    String? joinDate,
    int? totalProducts,
    String? totalRevenue,
    String? commission,
    double? rating,
    int? totalOrders,
  }) {
    return StoreData(
      id: id ?? this.id,
      name: name ?? this.name,
      owner: owner ?? this.owner,
      email: email ?? this.email,
      status: status ?? this.status,
      category: category ?? this.category,
      joinDate: joinDate ?? this.joinDate,
      totalProducts: totalProducts ?? this.totalProducts,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      commission: commission ?? this.commission,
      rating: rating ?? this.rating,
      totalOrders: totalOrders ?? this.totalOrders,
    );
  }
}