import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:niffer_store/core/constants/app_strings.dart';
import 'package:niffer_store/core/widgets/modern_bottom_sheet.dart';
import 'package:niffer_store/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthUtils {
  /// Checks if user is authenticated and shows login prompt if not
  /// Returns true if authenticated or if user chooses to login
  static Future<bool> requireAuth(
    BuildContext context, {
    String title = 'Login Required',
    String message = 'Please login to continue with this action.',
    String actionName = 'this action',
  }) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.isAuthenticated) {
      return true;
    }

    // Show auth required dialog
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: title,
      message: message,
      confirmText: 'Login',
      cancelText: 'Continue Browsing',
      icon: Icons.login,
      confirmColor: Theme.of(context).primaryColor,
    );

    if (result == true && context.mounted) {
      // Navigate to login page
      context.push(AppRoutes.login);
      return false; // Don't execute the action now, user will return after login
    }

    return false; // User chose to continue browsing without auth
  }

  /// Shows a specific auth prompt for adding to cart
  static Future<bool> requireAuthForCart(BuildContext context) {
    return requireAuth(
      context,
      title: 'Login to Add to Cart',
      message: 'Please login to add items to your cart and manage your orders.',
      actionName: 'add to cart',
    );
  }

  /// Shows a specific auth prompt for checkout
  static Future<bool> requireAuthForCheckout(BuildContext context) {
    return requireAuth(
      context,
      title: 'Login to Checkout',
      message: 'Please login to proceed with checkout and place your order.',
      actionName: 'checkout',
    );
  }

  /// Shows a specific auth prompt for order history
  static Future<bool> requireAuthForOrders(BuildContext context) {
    return requireAuth(
      context,
      title: 'Login to View Orders',
      message: 'Please login to view your order history and track shipments.',
      actionName: 'view orders',
    );
  }

  /// Shows a specific auth prompt for profile
  static Future<bool> requireAuthForProfile(BuildContext context) {
    return requireAuth(
      context,
      title: 'Login to View Profile',
      message: 'Please login to view and manage your profile information.',
      actionName: 'view profile',
    );
  }

  /// Generic method to check auth and show appropriate UI
  static Widget buildAuthRequiredWidget({
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onLoginPressed,
    IconData icon = Icons.login,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onLoginPressed,
                icon: const Icon(Icons.login),
                label: const Text('Login to Continue'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.push(AppRoutes.register),
              child: const Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a guest mode indicator
  static Widget buildGuestModeIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.visibility,
            size: 16,
            color: Colors.orange[700],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Browsing as guest',
              style: TextStyle(
                color: Colors.orange[700],
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.push(AppRoutes.login),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(40, 24),
            ),
            child: Text(
              'Login',
              style: TextStyle(
                color: Colors.orange[700],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}