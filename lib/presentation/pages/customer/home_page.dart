
import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/constants/app_strings.dart';
import 'package:niffer_store/core/utils/auth_utils.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';

import 'package:niffer_store/presentation/providers/auth_provider.dart';
import 'package:niffer_store/presentation/providers/cart_provider.dart';
import 'package:niffer_store/presentation/providers/product_provider.dart';
import 'package:niffer_store/presentation/providers/theme_provider.dart';
import 'package:niffer_store/presentation/widgets/navigation_drawer.dart';
import 'package:niffer_store/presentation/widgets/product_card.dart';
import 'package:niffer_store/core/widgets/skeleton_loader.dart';
import 'package:niffer_store/core/widgets/product_card_skeleton.dart';
import 'package:niffer_store/core/widgets/modern_bottom_sheet.dart';
import 'package:niffer_store/core/widgets/modern_carousel.dart';
import 'package:niffer_store/core/widgets/scrollable_blur_container.dart';
import 'package:niffer_store/core/widgets/modern_product_carousel.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
      context.read<ProductProvider>().loadCategories();
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
      appBar: _buildAppBar(),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        desktop: _buildDesktopLayout(),
      ),
      floatingActionButton: _buildCartFAB(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Multi-Store Commerce'),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: () => themeProvider.toggleTheme(),
            );
          },
        ),
        Consumer2<AuthProvider, CartProvider>(
          builder: (context, authProvider, cartProvider, child) {
            if (authProvider.isAuthenticated) {
              return Badge(
                label: Text(cartProvider.totalQuantity.toString()),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () => context.go(AppRoutes.cart),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.isAuthenticated) {
              return IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () async {
                  await _showLogoutBottomSheet(context, authProvider);
                },
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.login),
                tooltip: 'Login',
                onPressed: () => context.push(AppRoutes.login),
              );
            }
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildGuestModeIndicator() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return const SizedBox.shrink();
        }
        return AuthUtils.buildGuestModeIndicator(context);
      },
    );
  }

  Widget _buildMobileLayout() {
    return ScrollableBlurContainer(
      enableBottomBlur: true,
      blurRadius: 15.0,
      blurColor: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          children: [
            _buildGuestModeIndicator(),
            _buildSearchBar(),
            _buildProductCarouselBanner(),
            _buildCategoriesSection(),
            _buildProductsGridEnhanced(),
          ],
        ),
      ),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 24),
                _buildCarouselBanner(),
                const SizedBox(height: 24),
                _buildCategoriesSection(),
                const SizedBox(height: 24),
                _buildProductsGrid(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search products...',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (query) {
          context.read<ProductProvider>().searchProducts(query);
        },
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SkeletonLoader(
                  height: 24,
                  width: 120,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              const CategoryListSkeleton(),
            ],
          );
        }
        
        if (productProvider.categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.productList),
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: productProvider.categories.length,
                itemBuilder: (context, index) {
                  final category = productProvider.categories[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        productProvider.filterByCategory(category.id);
                        context.go(AppRoutes.productList);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: category.iconUrl,
                              width: 32,
                              height: 32,
                              errorWidget: (context, url, error) => Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.category,
                                  size: 20,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              category.name,
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductCarouselBanner() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final featuredProducts = productProvider.filteredProducts
            .where((product) => product.rating >= 4.0)
            .take(5)
            .toList();

        if (featuredProducts.isEmpty) {
          return _buildCarouselBanner(); // Fallback to regular banner
        }

        return ModernProductCarousel(
          featuredProducts: featuredProducts,
          height: 280,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          borderRadius: BorderRadius.circular(20),
          autoPlayDuration: const Duration(seconds: 4),
          onProductTap: (product) {
            context.go('${AppRoutes.productDetail}/${product.id}');
          },
        );
      },
    );
  }

  Widget _buildCarouselBanner() {
    final carouselItems = [
      CarouselItem(
        title: 'Special Offers',
        subtitle: 'Up to 50% off on selected items',
        badge: 'LIMITED TIME',
        buttonText: 'Shop Now',
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onButtonPressed: () => context.go(AppRoutes.productList),
      ),
      CarouselItem(
        title: 'New Arrivals',
        subtitle: 'Discover the latest trends and styles',
        badge: 'NEW',
        buttonText: 'Explore',
        gradient: LinearGradient(
          colors: [Colors.purple[600]!, Colors.purple[800]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onButtonPressed: () => context.go(AppRoutes.productList),
      ),
      CarouselItem(
        title: 'Free Shipping',
        subtitle: 'On orders above TZS 50,000',
        badge: 'FREE DELIVERY',
        buttonText: 'Learn More',
        gradient: LinearGradient(
          colors: [Colors.green[600]!, Colors.green[800]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onButtonPressed: () => context.go(AppRoutes.productList),
      ),
      CarouselItem(
        title: 'Customer Favorites',
        subtitle: 'Top-rated products by our community',
        badge: 'BESTSELLER',
        buttonText: 'View All',
        gradient: LinearGradient(
          colors: [Colors.orange[600]!, Colors.orange[800]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onButtonPressed: () => context.go(AppRoutes.productList),
      ),
    ];

    return CarouselBanner(
      items: carouselItems,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      borderRadius: BorderRadius.circular(16),
      autoPlayDuration: const Duration(seconds: 5),
    );
  }

  Widget _buildProductsGrid() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SkeletonLoader(
                  height: 24,
                  width: 160,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              ProductGridSkeleton(
                crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : 3,
                itemCount: 6,
              ),
            ],
          );
        }

        if (productProvider.filteredProducts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
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
            ),
          );
        }

        // Show limited products on home page
        final products = productProvider.filteredProducts.take(6).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Products',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.productList),
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              },
            ),
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }

  Widget _buildProductsGridEnhanced() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SkeletonLoader(
                  height: 24,
                  width: 160,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              ProductGridSkeleton(
                crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : 3,
                itemCount: 6,
              ),
            ],
          );
        }

        if (productProvider.filteredProducts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
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
            ),
          );
        }

        // Show limited products on home page with animations
        final products = productProvider.filteredProducts.take(6).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Products',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.productList),
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildAnimatedProductGrid(products),
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedProductGrid(List products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: Transform.scale(
                  scale: 0.8 + (0.2 * value),
                  child: ProductCard(product: products[index]),
                ),
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildCartFAB() {
    return Consumer2<AuthProvider, CartProvider>(
      builder: (context, authProvider, cartProvider, child) {
        if (!authProvider.isAuthenticated || cartProvider.isEmpty) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton.extended(
          onPressed: () => context.go(AppRoutes.cart),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          icon: Badge(
            label: Text(cartProvider.totalQuantity.toString()),
            child: const Icon(Icons.shopping_cart),
          ),
          label: Text('TZS ${cartProvider.totalPrice.toStringAsFixed(0)}'),
        );
      },
    );
  }

  Future<void> _showLogoutBottomSheet(BuildContext context, AuthProvider authProvider) async {
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: 'Logout',
      message: 'Are you sure you want to logout from your account?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
      icon: Icons.person_outline,
      isDangerous: true,
    );

    if (result == true) {
      await authProvider.logout();
    }
  }
}

