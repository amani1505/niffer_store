import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/constants/app_strings.dart';
import 'package:niffer_store/core/utils/auth_utils.dart';
import 'package:niffer_store/core/widgets/modern_toast.dart';
import 'package:niffer_store/core/widgets/image_skeleton.dart';
import 'package:niffer_store/domain/entities/product.dart';
import 'package:niffer_store/presentation/providers/auth_provider.dart';
import 'package:niffer_store/presentation/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ProductCard extends StatelessWidget {
  final Product product;
  final bool showStoreName;

  const ProductCard({
    super.key,
    required this.product,
    this.showStoreName = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => context.go('${AppRoutes.productList}/${product.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: _buildProductName(context),
                          ),
                          if (showStoreName) ...[
                            const SizedBox(height: 1),
                            Flexible(
                              child: _buildStoreName(context),
                            ),
                          ],
                          const SizedBox(height: 2),
                          _buildPriceRow(context),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    _buildActionButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const ImageSkeleton(
              width: double.infinity,
              height: double.infinity,
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey.withValues(alpha: 0.1),
              child: const Icon(
                Icons.image_not_supported_outlined,
                size: 48,
                color: Colors.grey,
              ),
            ),
          ),
          if (product.hasDiscount)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
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
            ),
          if (!product.isInStock)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: const Center(
                  child: Text(
                    'OUT OF STOCK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductName(BuildContext context) {
    return Text(
      product.name,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStoreName(BuildContext context) {
    return Text(
      'Store Name', // This would come from store data
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: AppColors.textSecondary,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            'TZS ${product.finalPrice.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (product.hasDiscount) ...[
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              'TZS ${product.price.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                decoration: TextDecoration.lineThrough,
                color: AppColors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final isInCart = cartProvider.isInCart(product.id);
        final quantity = cartProvider.getItemQuantity(product.id);

        if (!product.isInStock) {
          return SizedBox(
            width: double.infinity,
            height: 28, // Even smaller height to prevent overflow
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                textStyle: const TextStyle(fontSize: 10),
                minimumSize: const Size(0, 28),
              ),
              child: const Text('Out of Stock'),
            ),
          );
        }

        if (isInCart) {
          return SizedBox(
            height: 28, // Even smaller height to prevent overflow
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  height: 28,
                  child: IconButton(
                    onPressed: () => cartProvider.updateQuantity(product.id, quantity - 1),
                    icon: const Icon(Icons.remove, size: 14),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    quantity.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: IconButton(
                    onPressed: () => cartProvider.updateQuantity(product.id, quantity + 1),
                    icon: const Icon(Icons.add, size: 14),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return SizedBox(
          width: double.infinity,
          height: 28, // Even smaller height to prevent overflow
          child: ElevatedButton(
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              
              if (authProvider.isAuthenticated) {
                cartProvider.addItem(product);
                context.showSuccessToast('${product.name} added to cart');
              } else {
                await AuthUtils.requireAuthForCart(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              textStyle: const TextStyle(fontSize: 10),
              minimumSize: const Size(0, 28),
            ),
            child: const Text('Add to Cart'),
          ),
        );
      },
    );
  }
}
