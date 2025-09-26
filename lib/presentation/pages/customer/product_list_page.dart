import 'package:flutter/material.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';
import 'package:niffer_store/core/widgets/infinite_scroll_grid.dart';
import 'package:niffer_store/core/widgets/product_card_skeleton.dart';
import 'package:niffer_store/domain/entities/product.dart';
import 'package:niffer_store/presentation/providers/cart_provider.dart';
import 'package:niffer_store/presentation/providers/product_provider.dart';
import 'package:niffer_store/presentation/widgets/navigation_drawer.dart';
import 'package:niffer_store/presentation/widgets/product_card.dart';
import 'package:provider/provider.dart';



class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = context.read<ProductProvider>();
      if (productProvider.products.isEmpty) {
        productProvider.loadProducts();
      }
      if (productProvider.categories.isEmpty) {
        productProvider.loadCategories();
      }
    });
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
        title: const Text('Products'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Badge(
                label: Text(cartProvider.totalQuantity.toString()),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    // Navigate to cart
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: ResponsiveHelper.isMobile(context) ? const CustomNavigationDrawer() : null,
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
        Expanded(child: _buildProductGrid()),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        if (!ResponsiveHelper.isMobile(context))
          const SizedBox(
            width: 280,
            child: CustomNavigationDrawer(),
          ),
        Expanded(
          child: Column(
            children: [
              _buildSearchAndFilter(),
              Expanded(child: _buildProductGrid()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            productProvider.searchProducts('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (query) => productProvider.searchProducts(query),
              ),
              const SizedBox(height: 16),
              
              // Category Filter
              if (productProvider.categories.isNotEmpty)
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productProvider.categories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: const Text('All'),
                            selected: productProvider.selectedCategoryId == null,
                            onSelected: (selected) {
                              if (selected) {
                                productProvider.filterByCategory(null);
                              }
                            },
                          ),
                        );
                      }
                      
                      final category = productProvider.categories[index - 1];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category.name),
                          selected: productProvider.selectedCategoryId == category.id,
                          onSelected: (selected) {
                            productProvider.filterByCategory(
                              selected ? category.id : null,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductGrid() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading && productProvider.filteredProducts.isEmpty) {
          return ProductGridSkeleton(
            crossAxisCount: ResponsiveHelper.getResponsiveWidth(
              context,
              mobile: 2,
              tablet: 3,
              desktop: 4,
            ).toInt(),
            itemCount: 8,
            showStoreName: true,
          );
        }

        return InfiniteScrollGrid<Product>(
          initialItems: productProvider.filteredProducts,
          itemBuilder: (context, product, index) {
            return ProductCard(
              product: product,
              showStoreName: true,
            );
          },
          onLoadMore: (page) async {
            await productProvider.loadMoreProducts();
            return productProvider.filteredProducts
                .skip((page - 1) * 10)
                .take(10)
                .toList();
          },
          crossAxisCount: ResponsiveHelper.getResponsiveWidth(
            context,
            mobile: 2,
            tablet: 3,
            desktop: 4,
          ).toInt(),
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          padding: const EdgeInsets.all(16),
          enableShimmerLoading: true,
          shimmerItemCount: 8,
          emptyWidget: _buildEmptyState(productProvider),
          onRefresh: () async {
            await productProvider.loadProducts();
          },
        );
      },
    );
  }

  Widget _buildEmptyState(ProductProvider productProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
          if (productProvider.searchQuery.isNotEmpty || 
              productProvider.selectedCategoryId != null) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                _searchController.clear();
                productProvider.clearFilters();
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ],
      ),
    );
  }
}