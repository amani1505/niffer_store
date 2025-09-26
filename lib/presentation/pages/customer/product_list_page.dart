import 'package:flutter/material.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';
import 'package:niffer_store/core/widgets/infinite_scroll_grid.dart';
import 'package:niffer_store/core/widgets/product_card_skeleton.dart';
import 'package:niffer_store/domain/entities/product.dart';
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
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return _buildProductGrid();
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        if (!ResponsiveHelper.isMobile(context))
          const SizedBox(
            width: 280,
            child: CustomNavigationDrawer(),
          ),
        Expanded(child: _buildProductGrid()),
      ],
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
        ],
      ),
    );
  }
}