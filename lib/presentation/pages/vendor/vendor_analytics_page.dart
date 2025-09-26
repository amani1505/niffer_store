import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';
import 'package:niffer_store/core/widgets/modern_toast.dart';

class VendorAnalyticsPage extends StatefulWidget {
  const VendorAnalyticsPage({Key? key}) : super(key: key);

  @override
  State<VendorAnalyticsPage> createState() => _VendorAnalyticsPageState();
}

class _VendorAnalyticsPageState extends State<VendorAnalyticsPage> {
  String _selectedPeriod = '30 Days';
  String _selectedCategory = 'All Categories';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Analytics'),
        backgroundColor: AppColors.vendorColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportReport(),
            tooltip: 'Export Report',
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildFilters(),
          const SizedBox(height: 20),
          _buildOverviewCards(),
          const SizedBox(height: 20),
          _buildRevenueChart(),
          const SizedBox(height: 20),
          _buildTopProducts(),
          const SizedBox(height: 20),
          _buildOrderAnalytics(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildFilters(),
          const SizedBox(height: 24),
          _buildOverviewCards(),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildRevenueChart(),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildOrderAnalytics(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTopProducts(),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final periods = ['7 Days', '30 Days', '90 Days', '1 Year'];
    final categories = ['All Categories', 'Electronics', 'Fashion', 'Home & Garden', 'Sports', 'Books'];
    
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Time Period:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 16),
            ...periods.map((period) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(period),
                selected: _selectedPeriod == period,
                onSelected: (selected) {
                  setState(() {
                    _selectedPeriod = period;
                  });
                },
                selectedColor: AppColors.vendorColor.withValues(alpha: 0.2),
                checkmarkColor: AppColors.vendorColor,
              ),
            )),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              'Category:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      selectedColor: AppColors.vendorColor.withValues(alpha: 0.2),
                      checkmarkColor: AppColors.vendorColor,
                    ),
                  )).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCards() {
    final metrics = [
      _MetricCard(
        title: 'Total Revenue',
        value: 'TZS 1.2M',
        change: '+15.3%',
        isPositive: true,
        icon: Icons.attach_money,
        color: Colors.green,
      ),
      _MetricCard(
        title: 'Total Orders',
        value: '847',
        change: '+12.7%',
        isPositive: true,
        icon: Icons.shopping_bag,
        color: Colors.blue,
      ),
      _MetricCard(
        title: 'Products Sold',
        value: '1,234',
        change: '+8.5%',
        isPositive: true,
        icon: Icons.inventory,
        color: Colors.orange,
      ),
      _MetricCard(
        title: 'Avg Order Value',
        value: 'TZS 1,420',
        change: '+2.1%',
        isPositive: true,
        icon: Icons.trending_up,
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
        childAspectRatio: ResponsiveHelper.isMobile(context) ? 1.2 : 1.3,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) => _buildMetricCard(metrics[index]),
    );
  }

  Widget _buildMetricCard(_MetricCard metric) {
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
                metric.icon,
                color: metric.color,
                size: 24,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: metric.isPositive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  metric.change,
                  style: TextStyle(
                    color: metric.isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            metric.value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
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
                'Revenue & Sales Trend',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.show_chart, color: Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.trending_up, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Chart visualization coming soon'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildChartLegend('Revenue', AppColors.vendorColor),
              _buildChartLegend('Orders', Colors.blue),
              _buildChartLegend('Products', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildTopProducts() {
    final products = [
      _TopProduct(
        name: 'iPhone 15 Pro Max',
        category: 'Electronics',
        sales: 89,
        revenue: 'TZS 267K',
        profit: 'TZS 48K',
        profitMargin: 18.0,
      ),
      _TopProduct(
        name: 'Nike Air Jordan Retro',
        category: 'Sports',
        sales: 156,
        revenue: 'TZS 54K',
        profit: 'TZS 12K',
        profitMargin: 22.0,
      ),
      _TopProduct(
        name: 'Samsung Galaxy Watch',
        category: 'Electronics',
        sales: 67,
        revenue: 'TZS 87K',
        profit: 'TZS 19K',
        profitMargin: 21.8,
      ),
      _TopProduct(
        name: 'Adidas Running Shoes',
        category: 'Sports',
        sales: 124,
        revenue: 'TZS 31K',
        profit: 'TZS 7K',
        profitMargin: 22.6,
      ),
      _TopProduct(
        name: 'Sony WH-1000XM5',
        category: 'Electronics',
        sales: 43,
        revenue: 'TZS 15K',
        profit: 'TZS 3K',
        profitMargin: 20.0,
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
            'Top Performing Products',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Product')),
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Sales')),
                DataColumn(label: Text('Revenue')),
                DataColumn(label: Text('Profit')),
                DataColumn(label: Text('Margin %')),
              ],
              rows: products.map((product) {
                return DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        width: 150,
                        child: Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(product.category).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          product.category,
                          style: TextStyle(
                            color: _getCategoryColor(product.category),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text('${product.sales} units')),
                    DataCell(
                      Text(
                        product.revenue,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        product.profit,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${product.profitMargin.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: product.profitMargin >= 20 ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderAnalytics() {
    final orderStats = [
      _OrderStat(status: 'Pending', count: 23, color: Colors.orange),
      _OrderStat(status: 'Processing', count: 41, color: Colors.blue),
      _OrderStat(status: 'Shipped', count: 67, color: Colors.purple),
      _OrderStat(status: 'Delivered', count: 716, color: Colors.green),
      _OrderStat(status: 'Cancelled', count: 8, color: Colors.red),
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
            'Order Status Breakdown',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...orderStats.map((stat) => _buildOrderStatItem(stat)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Completion Rate',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '94.2%',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Cancellation Rate',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '0.9%',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatItem(_OrderStat stat) {
    final total = 855; // Total orders for percentage calculation
    final percentage = (stat.count / total * 100);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: stat.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              stat.status,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '${stat.count}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '(${percentage.toStringAsFixed(1)}%)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Electronics':
        return Colors.blue;
      case 'Sports':
        return Colors.orange;
      case 'Fashion':
        return Colors.purple;
      case 'Home & Garden':
        return Colors.green;
      case 'Books':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  void _exportReport() {
    ModernToast.success(
      context,
      'Analytics report export coming soon!',
    );
  }
}

// Data models
class _MetricCard {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.color,
  });
}

class _TopProduct {
  final String name;
  final String category;
  final int sales;
  final String revenue;
  final String profit;
  final double profitMargin;

  const _TopProduct({
    required this.name,
    required this.category,
    required this.sales,
    required this.revenue,
    required this.profit,
    required this.profitMargin,
  });
}

class _OrderStat {
  final String status;
  final int count;
  final Color color;

  const _OrderStat({
    required this.status,
    required this.count,
    required this.color,
  });
}