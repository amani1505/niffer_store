import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/utils/auth_utils.dart';
import 'package:niffer_store/core/widgets/custom_button.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';
import 'package:niffer_store/core/widgets/product_detail_skeleton.dart';
import 'package:niffer_store/core/widgets/image_skeleton.dart';
import 'package:niffer_store/presentation/providers/auth_provider.dart';
import 'package:niffer_store/presentation/providers/cart_provider.dart';
import 'package:niffer_store/presentation/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _selectedImageIndex = 0;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().getProductById(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          Consumer2<AuthProvider, CartProvider>(
            builder: (context, authProvider, cartProvider, child) {
              if (authProvider.isAuthenticated) {
                return Badge(
                  label: Text(cartProvider.totalQuantity.toString()),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      // Navigate to cart - will be implemented by app navigation
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return const ProductDetailSkeleton();
          }

          final product = productProvider.selectedProduct;
          if (product == null) {
            return const Center(
              child: Text('Product not found'),
            );
          }

          return ResponsiveLayout(
            mobile: _buildMobileLayout(product),
            desktop: _buildDesktopLayout(product),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(product) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageGallery(product),
          _buildProductInfo(product),
          _buildAddToCartSection(product),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(product) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _buildImageGallery(product),
          ),
          const SizedBox(width: 32),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildProductInfo(product),
                const SizedBox(height: 32),
                _buildAddToCartSection(product),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(product) {
    return Column(
      children: [
        // Main Image
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: product.imageUrls.isNotEmpty 
                    ? product.imageUrls[_selectedImageIndex]
                    : '',
                fit: BoxFit.cover,
                placeholder: (context, url) => const ImageSkeleton(
                  width: double.infinity,
                  height: double.infinity,
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.withOpacity(0.1),
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
        
        // Thumbnail Images
        if (product.imageUrls.length > 1)
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: product.imageUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedImageIndex = index;
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedImageIndex == index
                            ? AppColors.primary
                            : Colors.grey.withOpacity(0.3),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrls[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const ImageSkeleton(
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.withOpacity(0.1),
                          child: const Icon(Icons.image, size: 24),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildProductInfo(product) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            product.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Price
          Row(
            children: [
              Text(
                '\${product.finalPrice.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              if (product.hasDiscount) ...[
                const SizedBox(width: 12),
                Text(
                  '\${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '-${product.discountPercentage.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          
          // Stock Status
          Row(
            children: [
              Icon(
                product.isInStock ? Icons.check_circle : Icons.cancel,
                color: product.isInStock ? AppColors.success : AppColors.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                product.isInStock ? 'In Stock' : 'Out of Stock',
                style: TextStyle(
                  color: product.isInStock ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (product.isInStock) ...[
                const SizedBox(width: 16),
                Text(
                  '${product.stockQuantity} available',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),
          
          // Description
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          
          // Rating
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < product.rating.floor()
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
              ),
              const SizedBox(width: 8),
              Text(
                '${product.rating} (${product.reviewCount} reviews)',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartSection(product) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          if (product.isInStock) ...[
            // Quantity Selector
            Row(
              children: [
                Text(
                  'Quantity:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Row(
                  children: [
                    IconButton(
                      onPressed: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                      icon: const Icon(Icons.remove),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _quantity.toString(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _quantity < product.stockQuantity
                          ? () => setState(() => _quantity++)
                          : null,
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          
          // Add to Cart Button
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return CustomButton(
                text: product.isInStock ? 'Add to Cart' : 'Out of Stock',
                onPressed: product.isInStock
                    ? () async {
                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                        
                        if (authProvider.isAuthenticated) {
                          cartProvider.addItem(product, quantity: _quantity);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${product.name} added to cart',
                              ),
                              action: SnackBarAction(
                                label: 'View Cart',
                                onPressed: () {
                                  // Navigate to cart
                                },
                              ),
                            ),
                          );
                        } else {
                          await AuthUtils.requireAuthForCart(context);
                        }
                      }
                    : null,
                icon: Icons.shopping_cart,
                width: double.infinity,
              );
            },
          ),
        ],
      ),
    );
  }
}