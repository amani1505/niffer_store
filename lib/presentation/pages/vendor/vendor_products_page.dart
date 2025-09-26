import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';
import 'package:niffer_store/core/widgets/modern_bottom_sheet.dart';
import 'package:niffer_store/core/widgets/modern_toast.dart';

class VendorProductsPage extends StatefulWidget {
  const VendorProductsPage({Key? key}) : super(key: key);

  @override
  State<VendorProductsPage> createState() => _VendorProductsPageState();
}

class _VendorProductsPageState extends State<VendorProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _searchQuery = '';

  // Mock product data
  List<VendorProductData> _products = [
    VendorProductData(
      id: '1',
      name: 'iPhone 15 Pro Max',
      category: 'Electronics',
      price: 'TZS 2,890,000',
      stock: 15,
      status: 'Active',
      sold: 8,
      views: 234,
      rating: 4.8,
      dateAdded: '2024-01-15',
    ),
    VendorProductData(
      id: '2',
      name: 'Samsung Galaxy Watch',
      category: 'Electronics',
      price: 'TZS 890,000',
      stock: 0,
      status: 'Out of Stock',
      sold: 23,
      views: 567,
      rating: 4.5,
      dateAdded: '2023-12-08',
    ),
    VendorProductData(
      id: '3',
      name: 'Nike Air Jordan',
      category: 'Fashion',
      price: 'TZS 345,000',
      stock: 7,
      status: 'Active',
      sold: 12,
      views: 189,
      rating: 4.9,
      dateAdded: '2024-02-22',
    ),
    VendorProductData(
      id: '4',
      name: 'MacBook Pro M3',
      category: 'Electronics',
      price: 'TZS 4,200,000',
      stock: 3,
      status: 'Draft',
      sold: 0,
      views: 45,
      rating: 0.0,
      dateAdded: '2024-03-10',
    ),
  ];

  List<VendorProductData> get _filteredProducts {
    return _products.where((product) {
      if (_selectedFilter != 'All' && product.status != _selectedFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty &&
          !product.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !product.category.toLowerCase().contains(_searchQuery.toLowerCase())) {
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
        title: const Text('My Products'),
        backgroundColor: AppColors.vendorColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addProduct(),
            tooltip: 'Add Product',
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => _viewProductAnalytics(),
            tooltip: 'Analytics',
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
          child: _buildProductsList(),
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
          child: _buildProductsGrid(),
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Management',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your store inventory and product listings',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: _addProduct,
                icon: const Icon(Icons.add),
                label: const Text('Add Product'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.vendorColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search products by name or category...',
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
    final filters = ['All', 'Active', 'Out of Stock', 'Draft'];
    
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
              selectedColor: AppColors.vendorColor.withValues(alpha: 0.2),
              checkmarkColor: AppColors.vendorColor,
            ),
          )),
          const Spacer(),
          Text(
            '${_filteredProducts.length} products found',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return _buildProductGridCard(product);
      },
    );
  }

  Widget _buildProductCard(VendorProductData product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.inventory_2,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        product.price,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.vendorColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(product.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip('Stock', product.stock.toString(), 
                  product.stock > 0 ? Colors.green : Colors.red),
                const SizedBox(width: 8),
                _buildInfoChip('Sold', product.sold.toString(), Colors.blue),
                const SizedBox(width: 8),
                _buildInfoChip('Views', product.views.toString(), Colors.orange),
              ],
            ),
            if (product.rating > 0) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    product.rating.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Added: ${product.dateAdded}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => _viewProductDetails(product),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View'),
                ),
                TextButton.icon(
                  onPressed: () => _editProduct(product),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                ),
                if (product.status == 'Draft')
                  TextButton.icon(
                    onPressed: () => _publishProduct(product),
                    icon: const Icon(Icons.publish, size: 16),
                    label: const Text('Publish'),
                    style: TextButton.styleFrom(foregroundColor: Colors.green),
                  ),
                if (product.status == 'Active')
                  TextButton.icon(
                    onPressed: () => _unpublishProduct(product),
                    icon: const Icon(Icons.unpublished, size: 16),
                    label: const Text('Unpublish'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGridCard(VendorProductData product) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.inventory_2,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              product.price,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.vendorColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stock: ${product.stock}',
                  style: TextStyle(
                    color: product.stock > 0 ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                _buildStatusChip(product.status),
              ],
            ),
          ],
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
      case 'Out of Stock':
        color = Colors.red;
        break;
      case 'Draft':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _addProduct() {
    ModernBottomSheet.showCustom(
      context: context,
      title: 'Add New Product',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Product creation form will be available soon.'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _viewProductDetails(VendorProductData product) {
    ModernBottomSheet.showCustom(
      context: context,
      title: 'Product Details',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDetailRow('Name', product.name),
          _buildDetailRow('Category', product.category),
          _buildDetailRow('Price', product.price),
          _buildDetailRow('Stock', product.stock.toString()),
          _buildDetailRow('Status', product.status),
          _buildDetailRow('Units Sold', product.sold.toString()),
          _buildDetailRow('Views', product.views.toString()),
          if (product.rating > 0)
            _buildDetailRow('Rating', product.rating.toString()),
          _buildDetailRow('Date Added', product.dateAdded),
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
            width: 80,
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

  void _editProduct(VendorProductData product) {
    ModernBottomSheet.showCustom(
      context: context,
      title: 'Edit Product',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Edit functionality for ${product.name} will be available soon.'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _publishProduct(VendorProductData product) async {
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: 'Publish Product',
      message: 'Are you sure you want to publish ${product.name}? It will become visible to customers.',
      confirmText: 'Publish',
      cancelText: 'Cancel',
      icon: Icons.publish,
      isDangerous: false,
    );

    if (result == true) {
      setState(() {
        final index = _products.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          _products[index] = product.copyWith(status: 'Active');
        }
      });
      if (mounted) {
        ModernToast.success(
          context,
          '${product.name} has been published!',
        );
      }
    }
  }

  void _unpublishProduct(VendorProductData product) async {
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: 'Unpublish Product',
      message: 'Are you sure you want to unpublish ${product.name}? It will no longer be visible to customers.',
      confirmText: 'Unpublish',
      cancelText: 'Cancel',
      icon: Icons.unpublished,
      isDangerous: true,
    );

    if (result == true) {
      setState(() {
        final index = _products.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          _products[index] = product.copyWith(status: 'Draft');
        }
      });
      if (mounted) {
        ModernToast.success(
          context,
          '${product.name} has been unpublished',
        );
      }
    }
  }

  void _viewProductAnalytics() {
    ModernToast.info(
      context,
      'Product analytics view coming soon!',
    );
  }
}

// Data model for vendor product information
class VendorProductData {
  final String id;
  final String name;
  final String category;
  final String price;
  final int stock;
  final String status;
  final int sold;
  final int views;
  final double rating;
  final String dateAdded;

  VendorProductData({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.status,
    required this.sold,
    required this.views,
    required this.rating,
    required this.dateAdded,
  });

  VendorProductData copyWith({
    String? id,
    String? name,
    String? category,
    String? price,
    int? stock,
    String? status,
    int? sold,
    int? views,
    double? rating,
    String? dateAdded,
  }) {
    return VendorProductData(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      status: status ?? this.status,
      sold: sold ?? this.sold,
      views: views ?? this.views,
      rating: rating ?? this.rating,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
}