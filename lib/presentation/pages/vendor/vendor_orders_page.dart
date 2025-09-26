import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';
import 'package:niffer_store/core/widgets/modern_bottom_sheet.dart';
import 'package:niffer_store/core/widgets/modern_toast.dart';

class VendorOrdersPage extends StatefulWidget {
  const VendorOrdersPage({Key? key}) : super(key: key);

  @override
  State<VendorOrdersPage> createState() => _VendorOrdersPageState();
}

class _VendorOrdersPageState extends State<VendorOrdersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _searchQuery = '';

  // Mock orders data
  List<VendorOrderData> _orders = [
    VendorOrderData(
      id: '#ORD-2025-001',
      customerName: 'John Doe',
      customerEmail: 'john@example.com',
      product: 'iPhone 15 Pro Max',
      quantity: 1,
      amount: 'TZS 2,890,000',
      status: 'Pending',
      orderDate: '2025-01-15 14:30',
      shippingAddress: '123 Main St, Dar es Salaam',
    ),
    VendorOrderData(
      id: '#ORD-2025-002',
      customerName: 'Jane Smith',
      customerEmail: 'jane@example.com',
      product: 'Samsung Galaxy Watch',
      quantity: 2,
      amount: 'TZS 1,780,000',
      status: 'Processing',
      orderDate: '2025-01-14 10:15',
      shippingAddress: '456 Oak Ave, Arusha',
    ),
    VendorOrderData(
      id: '#ORD-2025-003',
      customerName: 'Bob Johnson',
      customerEmail: 'bob@example.com',
      product: 'Nike Air Jordan',
      quantity: 1,
      amount: 'TZS 345,000',
      status: 'Shipped',
      orderDate: '2025-01-13 16:45',
      shippingAddress: '789 Pine Rd, Mwanza',
    ),
    VendorOrderData(
      id: '#ORD-2025-004',
      customerName: 'Alice Brown',
      customerEmail: 'alice@example.com',
      product: 'MacBook Pro M3',
      quantity: 1,
      amount: 'TZS 4,200,000',
      status: 'Delivered',
      orderDate: '2025-01-10 09:20',
      shippingAddress: '321 Elm St, Dodoma',
    ),
  ];

  List<VendorOrderData> get _filteredOrders {
    return _orders.where((order) {
      if (_selectedFilter != 'All' && order.status != _selectedFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty &&
          !order.id.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !order.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !order.product.toLowerCase().contains(_searchQuery.toLowerCase())) {
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
        title: const Text('Order Management'),
        backgroundColor: AppColors.vendorColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () => _exportOrders(),
            tooltip: 'Export Orders',
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
          child: _buildOrdersList(),
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
          child: _buildOrdersTable(),
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
            'Order Management',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Process and manage customer orders for your store',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search orders by ID, customer, or product...',
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
    final filters = ['All', 'Pending', 'Processing', 'Shipped', 'Delivered'];
    
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
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filters.map((filter) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    selectedColor: AppColors.vendorColor.withValues(alpha: 0.2),
                    checkmarkColor: AppColors.vendorColor,
                  ),
                )).toList(),
              ),
            ),
          ),
          Text(
            '${_filteredOrders.length} orders',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    if (_filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No orders found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredOrders.length,
      itemBuilder: (context, index) {
        final order = _filteredOrders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(VendorOrderData order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.id,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.vendorColor,
                        ),
                      ),
                      Text(
                        order.orderDate,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(order.status),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.customerName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        order.customerEmail,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.inventory_2, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${order.product} (Qty: ${order.quantity})',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Text(
                  order.amount,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.shippingAddress,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => _viewOrderDetails(order),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View'),
                ),
                if (order.status == 'Pending')
                  TextButton.icon(
                    onPressed: () => _processOrder(order),
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: const Text('Process'),
                    style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  ),
                if (order.status == 'Processing')
                  TextButton.icon(
                    onPressed: () => _shipOrder(order),
                    icon: const Icon(Icons.local_shipping, size: 16),
                    label: const Text('Ship'),
                    style: TextButton.styleFrom(foregroundColor: Colors.green),
                  ),
                if (order.status == 'Pending')
                  TextButton.icon(
                    onPressed: () => _cancelOrder(order),
                    icon: const Icon(Icons.cancel, size: 16),
                    label: const Text('Cancel'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Order ID')),
              DataColumn(label: Text('Customer')),
              DataColumn(label: Text('Product')),
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Actions')),
            ],
            rows: _filteredOrders.map((order) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      order.id,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.vendorColor,
                      ),
                    ),
                  ),
                  DataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.customerName, style: const TextStyle(fontWeight: FontWeight.w500)),
                        Text(order.customerEmail, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  DataCell(Text('${order.product} (${order.quantity})')),
                  DataCell(
                    Text(
                      order.amount,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  DataCell(_buildStatusChip(order.status)),
                  DataCell(Text(order.orderDate.split(' ')[0])),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility, size: 16),
                          onPressed: () => _viewOrderDetails(order),
                          tooltip: 'View',
                        ),
                        if (order.status == 'Pending')
                          IconButton(
                            icon: const Icon(Icons.play_arrow, size: 16, color: Colors.blue),
                            onPressed: () => _processOrder(order),
                            tooltip: 'Process',
                          ),
                        if (order.status == 'Processing')
                          IconButton(
                            icon: const Icon(Icons.local_shipping, size: 16, color: Colors.green),
                            onPressed: () => _shipOrder(order),
                            tooltip: 'Ship',
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Pending':
        color = Colors.orange;
        break;
      case 'Processing':
        color = Colors.blue;
        break;
      case 'Shipped':
        color = Colors.purple;
        break;
      case 'Delivered':
        color = Colors.green;
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

  void _viewOrderDetails(VendorOrderData order) {
    ModernBottomSheet.showCustom(
      context: context,
      title: 'Order Details',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDetailRow('Order ID', order.id),
          _buildDetailRow('Customer', order.customerName),
          _buildDetailRow('Email', order.customerEmail),
          _buildDetailRow('Product', order.product),
          _buildDetailRow('Quantity', order.quantity.toString()),
          _buildDetailRow('Amount', order.amount),
          _buildDetailRow('Status', order.status),
          _buildDetailRow('Order Date', order.orderDate),
          _buildDetailRow('Shipping Address', order.shippingAddress),
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

  void _processOrder(VendorOrderData order) async {
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: 'Process Order',
      message: 'Are you sure you want to process order ${order.id}? This will mark it as processing.',
      confirmText: 'Process',
      cancelText: 'Cancel',
      icon: Icons.play_arrow,
      isDangerous: false,
    );

    if (result == true) {
      setState(() {
        final index = _orders.indexWhere((o) => o.id == order.id);
        if (index != -1) {
          _orders[index] = order.copyWith(status: 'Processing');
        }
      });
      if (mounted) {
        ModernToast.success(
          context,
          'Order ${order.id} is now processing',
        );
      }
    }
  }

  void _shipOrder(VendorOrderData order) async {
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: 'Ship Order',
      message: 'Are you sure you want to mark order ${order.id} as shipped?',
      confirmText: 'Ship',
      cancelText: 'Cancel',
      icon: Icons.local_shipping,
      isDangerous: false,
    );

    if (result == true) {
      setState(() {
        final index = _orders.indexWhere((o) => o.id == order.id);
        if (index != -1) {
          _orders[index] = order.copyWith(status: 'Shipped');
        }
      });
      if (mounted) {
        ModernToast.success(
          context,
          'Order ${order.id} has been shipped!',
        );
      }
    }
  }

  void _cancelOrder(VendorOrderData order) async {
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: 'Cancel Order',
      message: 'Are you sure you want to cancel order ${order.id}? This action cannot be undone.',
      confirmText: 'Cancel Order',
      cancelText: 'Keep Order',
      icon: Icons.cancel,
      isDangerous: true,
    );

    if (result == true) {
      setState(() {
        _orders.removeWhere((o) => o.id == order.id);
      });
      if (mounted) {
        ModernToast.success(
          context,
          'Order ${order.id} has been cancelled',
        );
      }
    }
  }

  void _exportOrders() {
    ModernToast.success(
      context,
      'Orders export functionality coming soon!',
    );
  }
}

// Data model for vendor order information
class VendorOrderData {
  final String id;
  final String customerName;
  final String customerEmail;
  final String product;
  final int quantity;
  final String amount;
  final String status;
  final String orderDate;
  final String shippingAddress;

  VendorOrderData({
    required this.id,
    required this.customerName,
    required this.customerEmail,
    required this.product,
    required this.quantity,
    required this.amount,
    required this.status,
    required this.orderDate,
    required this.shippingAddress,
  });

  VendorOrderData copyWith({
    String? id,
    String? customerName,
    String? customerEmail,
    String? product,
    int? quantity,
    String? amount,
    String? status,
    String? orderDate,
    String? shippingAddress,
  }) {
    return VendorOrderData(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      shippingAddress: shippingAddress ?? this.shippingAddress,
    );
  }
}