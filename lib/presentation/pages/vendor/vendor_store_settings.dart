import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';
import 'package:niffer_store/core/widgets/modern_toast.dart';
import 'package:niffer_store/core/widgets/modern_bottom_sheet.dart';
import 'package:niffer_store/core/widgets/theme_toggle.dart';

class VendorStoreSettings extends StatefulWidget {
  const VendorStoreSettings({Key? key}) : super(key: key);

  @override
  State<VendorStoreSettings> createState() => _VendorStoreSettingsState();
}

class _VendorStoreSettingsState extends State<VendorStoreSettings> {
  bool _storeActive = true;
  bool _emailNotifications = true;
  bool _orderNotifications = true;
  bool _marketingEmails = false;
  bool _autoAcceptOrders = false;
  bool _allowReviews = true;
  bool _showInventory = true;
  String _storeName = 'Tech Haven Electronics';
  String _storeDescription = 'Premium electronics and gadgets for tech enthusiasts';
  String _businessCategory = 'Electronics';
  String _country = 'Tanzania';
  String _city = 'Dar es Salaam';
  String _processingTime = '1-2 business days';
  String _returnPolicy = '30 days return policy';
  double _shippingFee = 5000.0;
  double _freeShippingThreshold = 50000.0;
  
  final _storeNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _storeNameController.text = _storeName;
    _descriptionController.text = _storeDescription;
    _addressController.text = 'Mlimani City Mall, Shop 123';
    _phoneController.text = '+255 123 456 789';
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Settings'),
        backgroundColor: AppColors.vendorColor,
        foregroundColor: Colors.white,
        actions: [
          const ThemeToggle(
            activeColor: Colors.white,
            isCompact: true,
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
            tooltip: 'Save Settings',
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
          _buildStoreInfoSection(),
          const SizedBox(height: 20),
          _buildBusinessSection(),
          const SizedBox(height: 20),
          _buildNotificationSection(),
          const SizedBox(height: 20),
          _buildThemeSection(),
          const SizedBox(height: 20),
          _buildShippingSection(),
          const SizedBox(height: 20),
          _buildPreferencesSection(),
          const SizedBox(height: 20),
          _buildAccountSection(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildStoreInfoSection(),
                    const SizedBox(height: 24),
                    _buildBusinessSection(),
                    const SizedBox(height: 24),
                    _buildShippingSection(),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _buildNotificationSection(),
                    const SizedBox(height: 24),
                    _buildThemeSection(),
                    const SizedBox(height: 24),
                    _buildPreferencesSection(),
                    const SizedBox(height: 24),
                    _buildAccountSection(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoreInfoSection() {
    return _buildSettingsCard(
      title: 'Store Information',
      icon: Icons.store,
      children: [
        _buildTextFieldItem(
          title: 'Store Name',
          controller: _storeNameController,
          onChanged: (value) => _storeName = value,
        ),
        _buildTextFieldItem(
          title: 'Store Description',
          controller: _descriptionController,
          onChanged: (value) => _storeDescription = value,
          maxLines: 3,
        ),
        _buildTextFieldItem(
          title: 'Store Address',
          controller: _addressController,
        ),
        _buildTextFieldItem(
          title: 'Phone Number',
          controller: _phoneController,
        ),
        _buildSettingsItem(
          title: 'Store Logo',
          subtitle: 'Upload your store logo',
          trailing: TextButton(
            onPressed: _uploadLogo,
            child: const Text('Upload'),
          ),
        ),
        _buildSettingsItem(
          title: 'Store Banner',
          subtitle: 'Upload store banner image',
          trailing: TextButton(
            onPressed: _uploadBanner,
            child: const Text('Upload'),
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessSection() {
    return _buildSettingsCard(
      title: 'Business Details',
      icon: Icons.business,
      children: [
        _buildDropdownItem(
          title: 'Business Category',
          value: _businessCategory,
          items: [
            'Electronics',
            'Fashion & Clothing',
            'Home & Garden',
            'Sports & Outdoors',
            'Books & Education',
            'Health & Beauty',
          ],
          onChanged: (value) => setState(() => _businessCategory = value!),
        ),
        _buildDropdownItem(
          title: 'Country',
          value: _country,
          items: ['Tanzania', 'Kenya', 'Uganda'],
          onChanged: (value) => setState(() => _country = value!),
        ),
        _buildDropdownItem(
          title: 'City',
          value: _city,
          items: [
            'Dar es Salaam',
            'Arusha',
            'Mwanza',
            'Dodoma',
            'Mbeya',
            'Zanzibar',
          ],
          onChanged: (value) => setState(() => _city = value!),
        ),
        _buildSettingsItem(
          title: 'Business License',
          subtitle: 'Upload business registration',
          trailing: TextButton(
            onPressed: _uploadLicense,
            child: const Text('Upload'),
          ),
        ),
        _buildSettingsItem(
          title: 'Tax Information',
          subtitle: 'Manage tax settings',
          trailing: TextButton(
            onPressed: _manageTax,
            child: const Text('Manage'),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    return _buildSettingsCard(
      title: 'Notification Settings',
      icon: Icons.notifications,
      children: [
        _buildSwitchItem(
          title: 'Email Notifications',
          subtitle: 'Receive notifications via email',
          value: _emailNotifications,
          onChanged: (value) => setState(() => _emailNotifications = value),
        ),
        _buildSwitchItem(
          title: 'Order Notifications',
          subtitle: 'Get notified of new orders',
          value: _orderNotifications,
          onChanged: (value) => setState(() => _orderNotifications = value),
        ),
        _buildSwitchItem(
          title: 'Marketing Emails',
          subtitle: 'Receive marketing updates',
          value: _marketingEmails,
          onChanged: (value) => setState(() => _marketingEmails = value),
        ),
      ],
    );
  }

  Widget _buildShippingSection() {
    return _buildSettingsCard(
      title: 'Shipping & Delivery',
      icon: Icons.local_shipping,
      children: [
        _buildSliderItem(
          title: 'Shipping Fee',
          subtitle: 'TZS ${_shippingFee.toStringAsFixed(0)}',
          value: _shippingFee,
          min: 0,
          max: 20000,
          divisions: 40,
          onChanged: (value) => setState(() => _shippingFee = value),
        ),
        _buildSliderItem(
          title: 'Free Shipping Threshold',
          subtitle: 'TZS ${_freeShippingThreshold.toStringAsFixed(0)}',
          value: _freeShippingThreshold,
          min: 10000,
          max: 200000,
          divisions: 38,
          onChanged: (value) => setState(() => _freeShippingThreshold = value),
        ),
        _buildDropdownItem(
          title: 'Processing Time',
          value: _processingTime,
          items: [
            'Same day',
            '1-2 business days',
            '3-5 business days',
            '1 week',
            '2 weeks',
          ],
          onChanged: (value) => setState(() => _processingTime = value!),
        ),
        _buildDropdownItem(
          title: 'Return Policy',
          value: _returnPolicy,
          items: [
            'No returns',
            '7 days return policy',
            '14 days return policy',
            '30 days return policy',
            '60 days return policy',
          ],
          onChanged: (value) => setState(() => _returnPolicy = value!),
        ),
        _buildSettingsItem(
          title: 'Shipping Zones',
          subtitle: 'Configure delivery areas',
          trailing: TextButton(
            onPressed: _manageShippingZones,
            child: const Text('Manage'),
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return _buildSettingsCard(
      title: 'Store Preferences',
      icon: Icons.tune,
      children: [
        _buildSwitchItem(
          title: 'Store Status',
          subtitle: _storeActive ? 'Store is active' : 'Store is inactive',
          value: _storeActive,
          onChanged: (value) {
            if (!value) {
              _confirmStoreDeactivation(value);
            } else {
              setState(() => _storeActive = value);
            }
          },
        ),
        _buildSwitchItem(
          title: 'Auto Accept Orders',
          subtitle: 'Automatically accept incoming orders',
          value: _autoAcceptOrders,
          onChanged: (value) => setState(() => _autoAcceptOrders = value),
        ),
        _buildSwitchItem(
          title: 'Allow Customer Reviews',
          subtitle: 'Let customers review your products',
          value: _allowReviews,
          onChanged: (value) => setState(() => _allowReviews = value),
        ),
        _buildSwitchItem(
          title: 'Show Inventory Count',
          subtitle: 'Display stock quantities to customers',
          value: _showInventory,
          onChanged: (value) => setState(() => _showInventory = value),
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return _buildSettingsCard(
      title: 'Account Management',
      icon: Icons.account_circle,
      children: [
        _buildSettingsItem(
          title: 'Change Password',
          subtitle: 'Update your account password',
          trailing: TextButton(
            onPressed: _changePassword,
            child: const Text('Change'),
          ),
        ),
        _buildSettingsItem(
          title: 'Payment Settings',
          subtitle: 'Bank account and payment info',
          trailing: TextButton(
            onPressed: _managePayments,
            child: const Text('Manage'),
          ),
        ),
        _buildSettingsItem(
          title: 'Store Statistics',
          subtitle: 'View detailed store analytics',
          trailing: TextButton(
            onPressed: _viewStatistics,
            child: const Text('View'),
          ),
        ),
        _buildSettingsItem(
          title: 'Data Export',
          subtitle: 'Export store and order data',
          trailing: TextButton(
            onPressed: _exportData,
            child: const Text('Export'),
          ),
        ),
        _buildSettingsItem(
          title: 'Close Store',
          subtitle: 'Permanently close your store',
          trailing: TextButton(
            onPressed: _closeStore,
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Close'),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
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
            children: [
              Icon(icon, color: AppColors.vendorColor, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildSwitchItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.vendorColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldItem({
    required String title,
    required TextEditingController controller,
    ValueChanged<String>? onChanged,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            onChanged: onChanged,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.vendorColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownItem({
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                items: items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderItem({
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.vendorColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: AppColors.vendorColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    ModernToast.success(
      context,
      'Store settings saved successfully!',
    );
  }

  void _uploadLogo() {
    ModernToast.info(context, 'Logo upload feature coming soon!');
  }

  void _uploadBanner() {
    ModernToast.info(context, 'Banner upload feature coming soon!');
  }

  void _uploadLicense() {
    ModernToast.info(context, 'License upload feature coming soon!');
  }

  void _manageTax() {
    ModernToast.info(context, 'Tax management feature coming soon!');
  }

  void _manageShippingZones() {
    ModernToast.info(context, 'Shipping zones management coming soon!');
  }

  void _changePassword() {
    ModernToast.info(context, 'Password change feature coming soon!');
  }

  void _managePayments() {
    ModernToast.info(context, 'Payment management feature coming soon!');
  }

  void _viewStatistics() {
    ModernToast.info(context, 'Detailed statistics feature coming soon!');
  }

  void _exportData() {
    ModernToast.info(context, 'Data export feature coming soon!');
  }

  void _confirmStoreDeactivation(bool deactivate) async {
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: 'Deactivate Store',
      message: 'This will make your store unavailable to customers. Are you sure?',
      confirmText: 'Deactivate',
      cancelText: 'Cancel',
      icon: Icons.warning,
      isDangerous: true,
    );

    if (result == true) {
      setState(() => _storeActive = deactivate);
      ModernToast.success(context, 'Store deactivated successfully');
    }
  }

  void _closeStore() async {
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: 'Close Store Permanently',
      message: 'This action cannot be undone. All your store data will be removed. Are you sure?',
      confirmText: 'Close Store',
      cancelText: 'Cancel',
      icon: Icons.delete_forever,
      isDangerous: true,
    );

    if (result == true) {
      ModernToast.error(context, 'Store closure feature coming soon!');
    }
  }

  Widget _buildThemeSection() {
    return _buildSettingsCard(
      title: 'Theme Preferences',
      icon: Icons.palette,
      children: [
        ThemeSelector(
          primaryColor: AppColors.vendorColor,
          showSystemOption: true,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text(
              'Quick Toggle:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 12),
            const AnimatedThemeToggle(
              activeColor: AppColors.vendorColor,
              size: 50,
            ),
          ],
        ),
      ],
    );
  }
}