import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';
import 'package:niffer_store/core/widgets/modern_toast.dart';

class GlobalAnalyticsPage extends StatefulWidget {
  const GlobalAnalyticsPage({Key? key}) : super(key: key);

  @override
  State<GlobalAnalyticsPage> createState() => _GlobalAnalyticsPageState();
}

class _GlobalAnalyticsPageState extends State<GlobalAnalyticsPage> {
  String _selectedPeriod = '30 Days';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Analytics'),
        backgroundColor: AppColors.adminColor,
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
          _buildPeriodSelector(),
          const SizedBox(height: 20),
          _buildOverviewCards(),
          const SizedBox(height: 20),
          _buildRevenueChart(),
          const SizedBox(height: 20),
          _buildTopStores(),
          const SizedBox(height: 20),
          _buildTopProducts(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildPeriodSelector(),
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
                child: _buildTopStores(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTopProducts(),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['7 Days', '30 Days', '90 Days', '1 Year'];
    
    return Row(
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
            selectedColor: AppColors.adminColor.withValues(alpha: 0.2),
            checkmarkColor: AppColors.adminColor,
          ),
        )),
      ],
    );
  }

  Widget _buildOverviewCards() {
    final metrics = [
      _MetricCard(
        title: 'Total Revenue',
        value: 'TZS 45.2M',
        change: '+18.2%',
        isPositive: true,
        icon: Icons.attach_money,
        color: Colors.green,
      ),
      _MetricCard(
        title: 'Platform Commission',
        value: 'TZS 2.3M',
        change: '+22.1%',
        isPositive: true,
        icon: Icons.account_balance,
        color: Colors.blue,
      ),
      _MetricCard(
        title: 'Total Orders',
        value: '12,847',
        change: '+15.7%',
        isPositive: true,
        icon: Icons.shopping_bag,
        color: Colors.orange,
      ),
      _MetricCard(
        title: 'Active Users',
        value: '2,847',
        change: '+8.3%',
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
                'Revenue Trend',
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
              _buildChartLegend('Revenue', Colors.blue),
              _buildChartLegend('Commission', Colors.green),
              _buildChartLegend('Orders', Colors.orange),
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

  Widget _buildTopStores() {
    final stores = [
      _TopStore(name: 'TechHub Electronics', revenue: 'TZS 2.1M', growth: '+23%'),
      _TopStore(name: 'Fashion Forward', revenue: 'TZS 1.8M', growth: '+18%'),
      _TopStore(name: 'Home & Garden Plus', revenue: 'TZS 890K', growth: '+12%'),
      _TopStore(name: 'Sports Central', revenue: 'TZS 456K', growth: '+8%'),
      _TopStore(name: 'Book Paradise', revenue: 'TZS 234K', growth: '+5%'),
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
            'Top Performing Stores',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...stores.asMap().entries.map((entry) {
            final index = entry.key;
            final store = entry.value;
            return _buildStoreItem(store, index + 1);
          }),
        ],
      ),
    );
  }

  Widget _buildStoreItem(_TopStore store, int rank) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rank <= 3 ? AppColors.adminColor.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: rank <= 3 ? AppColors.adminColor : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  store.revenue,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              store.growth,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProducts() {
    final products = [
      _TopProduct(name: 'iPhone 15 Pro Max', sales: 234, revenue: 'TZS 678K'),
      _TopProduct(name: 'Samsung Galaxy Watch', sales: 189, revenue: 'TZS 168K'),
      _TopProduct(name: 'Nike Air Jordan', sales: 156, revenue: 'TZS 54K'),
      _TopProduct(name: 'MacBook Pro M3', sales: 89, revenue: 'TZS 374K'),
      _TopProduct(name: 'Sony WH-1000XM5', sales: 78, revenue: 'TZS 23K'),
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
            'Top Selling Products',
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
                DataColumn(label: Text('Sales')),
                DataColumn(label: Text('Revenue')),
              ],
              rows: products.map((product) {
                return DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        width: 200,
                        child: Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
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
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
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

class _TopStore {
  final String name;
  final String revenue;
  final String growth;

  const _TopStore({
    required this.name,
    required this.revenue,
    required this.growth,
  });
}

class _TopProduct {
  final String name;
  final int sales;
  final String revenue;

  const _TopProduct({
    required this.name,
    required this.sales,
    required this.revenue,
  });
}
