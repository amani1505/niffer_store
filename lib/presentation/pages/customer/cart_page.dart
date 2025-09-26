
import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/widgets/custom_button.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';
import 'package:niffer_store/core/widgets/image_skeleton.dart';
import 'package:niffer_store/core/widgets/login_dialog.dart';
import 'package:niffer_store/presentation/providers/auth_provider.dart';
import 'package:niffer_store/presentation/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';


class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        elevation: 0,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isEmpty) {
            return _buildEmptyCart(context);
          }

          return ResponsiveLayout(
            mobile: _buildMobileLayout(cartProvider),
            desktop: _buildDesktopLayout(cartProvider),
          );
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isEmpty) {
            return const SizedBox.shrink();
          }
          
          return _buildCheckoutSection(context, cartProvider);
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 120,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Your cart is empty',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Add some products to get started',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Continue Shopping',
              onPressed: () => Navigator.of(context).pop(),
              icon: Icons.shopping_bag,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(CartProvider cartProvider) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cartProvider.items.length,
            itemBuilder: (context, index) {
              return _buildCartItem(cartProvider.items[index], cartProvider);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(CartProvider cartProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: cartProvider.items.length,
            itemBuilder: (context, index) {
              return _buildCartItem(cartProvider.items[index], cartProvider);
            },
          ),
        ),
        Container(
          width: 350,
          padding: const EdgeInsets.all(24),
          child: _buildOrderSummary(cartProvider),
        ),
      ],
    );
  }

  Widget _buildCartItem(item, CartProvider cartProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: item.productImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const ImageSkeleton(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.withOpacity(0.1),
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.storeName.isNotEmpty ? item.storeName : 'Store',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity Controls
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => cartProvider.updateQuantity(
                        item.productId,
                        item.quantity - 1,
                      ),
                      icon: const Icon(Icons.remove),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.withOpacity(0.1),
                        minimumSize: const Size(32, 32),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        item.quantity.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => cartProvider.updateQuantity(
                        item.productId,
                        item.quantity + 1,
                      ),
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.withOpacity(0.1),
                        minimumSize: const Size(32, 32),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => cartProvider.removeItem(item.productId),
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('Remove'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cartProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Items (${cartProvider.totalQuantity})'),
                Text('\${cartProvider.totalPrice.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Shipping'),
                Text('Free', style: TextStyle(color: AppColors.success)),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\${cartProvider.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, CartProvider cartProvider) {
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
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!ResponsiveHelper.isMobile(context))
              _buildOrderSummary(cartProvider),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total: \${cartProvider.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        '${cartProvider.totalQuantity} items',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return CustomButton(
                      text: 'Checkout',
                      onPressed: authProvider.isAuthenticated
                          ? () {
                              // Navigate to checkout
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Checkout feature coming soon!'),
                                ),
                              );
                            }
                          : () {
                              LoginRequiredBottomSheet.show(
                                context: context,
                                title: 'Login to Checkout',
                                message: 'Please login to proceed with your order and complete the checkout process.',
                                actionText: 'You\'ll be able to track your orders and enjoy a personalized shopping experience.',
                              );
                            },
                      icon: Icons.payment,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}





