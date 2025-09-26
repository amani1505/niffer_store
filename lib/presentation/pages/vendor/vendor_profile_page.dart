import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';
import 'package:niffer_store/core/widgets/modern_toast.dart';
import 'package:niffer_store/core/widgets/modern_bottom_sheet.dart';

class VendorProfilePage extends StatefulWidget {
  const VendorProfilePage({Key? key}) : super(key: key);

  @override
  State<VendorProfilePage> createState() => _VendorProfilePageState();
}

class _VendorProfilePageState extends State<VendorProfilePage> {
  bool _isDarkMode = false;
  bool _emailNotifications = true;
  bool _orderNotifications = true;
  bool _marketingEmails = false;
  String _language = 'English';
  
  final _nameController = TextEditingController(text: 'Sarah Johnson');
  final _emailController = TextEditingController(text: 'sarah@techhaven.com');
  final _phoneController = TextEditingController(text: '+255 987 654 321');
  final _bioController = TextEditingController(text: 'Tech enthusiast and entrepreneur running Tech Haven Electronics');
  final _storeNameController = TextEditingController(text: 'Tech Haven Electronics');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _storeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Profile'),
        backgroundColor: AppColors.vendorColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editProfile,
            tooltip: 'Edit Profile',
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
          _buildProfileHeader(),
          const SizedBox(height: 20),
          _buildPersonalInfo(),
          const SizedBox(height: 20),
          _buildStoreInfo(),
          const SizedBox(height: 20),
          _buildPreferences(),
          const SizedBox(height: 20),
          _buildStats(),
          const SizedBox(height: 20),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildPersonalInfo(),
                    const SizedBox(height: 24),
                    _buildStoreInfo(),
                    const SizedBox(height: 24),
                    _buildPreferences(),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _buildStats(),
                    const SizedBox(height: 24),
                    _buildActions(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.vendorColor,
            AppColors.vendorColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.vendorColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/vendor_avatar.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 46,
                  backgroundColor: Colors.white24,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: AppColors.vendorColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _nameController.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _emailController.text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Store Vendor',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return _buildSection(
      title: 'Personal Information',
      icon: Icons.person_outline,
      children: [
        _buildInfoTile(
          title: 'Full Name',
          subtitle: _nameController.text,
          icon: Icons.badge,
          onEdit: () => _editField('Name', _nameController),
        ),
        _buildInfoTile(
          title: 'Email Address',
          subtitle: _emailController.text,
          icon: Icons.email,
          onEdit: () => _editField('Email', _emailController),
        ),
        _buildInfoTile(
          title: 'Phone Number',
          subtitle: _phoneController.text,
          icon: Icons.phone,
          onEdit: () => _editField('Phone', _phoneController),
        ),
        _buildInfoTile(
          title: 'Bio',
          subtitle: _bioController.text,
          icon: Icons.description,
          onEdit: () => _editField('Bio', _bioController, maxLines: 3),
        ),
        _buildInfoTile(
          title: 'Location',
          subtitle: 'Dar es Salaam, Tanzania',
          icon: Icons.location_on,
          onEdit: () => _editLocation(),
        ),
        _buildInfoTile(
          title: 'Member Since',
          subtitle: 'March 10, 2024',
          icon: Icons.calendar_today,
        ),
      ],
    );
  }

  Widget _buildStoreInfo() {
    return _buildSection(
      title: 'Store Information',
      icon: Icons.store,
      children: [
        _buildInfoTile(
          title: 'Store Name',
          subtitle: _storeNameController.text,
          icon: Icons.storefront,
          onEdit: () => _editField('Store Name', _storeNameController),
        ),
        _buildInfoTile(
          title: 'Category',
          subtitle: 'Electronics',
          icon: Icons.category,
          onEdit: () => _editCategory(),
        ),
        _buildInfoTile(
          title: 'Store Status',
          subtitle: 'Active',
          icon: Icons.check_circle,
        ),
        _buildInfoTile(
          title: 'Verification Status',
          subtitle: 'Verified',
          icon: Icons.verified,
        ),
        _buildInfoTile(
          title: 'Store Rating',
          subtitle: '4.8 ⭐ (234 reviews)',
          icon: Icons.star,
        ),
        _buildInfoTile(
          title: 'Store Address',
          subtitle: 'Mlimani City Mall, Shop 123',
          icon: Icons.business,
          onEdit: () => _editStoreAddress(),
        ),
      ],
    );
  }

  Widget _buildPreferences() {
    return _buildSection(
      title: 'Preferences',
      icon: Icons.settings,
      children: [
        _buildSwitchTile(
          title: 'Dark Mode',
          subtitle: 'Use dark theme',
          icon: Icons.dark_mode,
          value: _isDarkMode,
          onChanged: (value) => setState(() => _isDarkMode = value),
        ),
        _buildSwitchTile(
          title: 'Email Notifications',
          subtitle: 'Receive email notifications',
          icon: Icons.mail_outline,
          value: _emailNotifications,
          onChanged: (value) => setState(() => _emailNotifications = value),
        ),
        _buildSwitchTile(
          title: 'Order Notifications',
          subtitle: 'Get notified of new orders',
          icon: Icons.notifications,
          value: _orderNotifications,
          onChanged: (value) => setState(() => _orderNotifications = value),
        ),
        _buildSwitchTile(
          title: 'Marketing Emails',
          subtitle: 'Receive marketing updates',
          icon: Icons.campaign,
          value: _marketingEmails,
          onChanged: (value) => setState(() => _marketingEmails = value),
        ),
        _buildDropdownTile(
          title: 'Language',
          subtitle: _language,
          icon: Icons.language,
          items: ['English', 'Swahili', 'French'],
          onChanged: (value) => setState(() => _language = value!),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return _buildSection(
      title: 'Store Performance',
      icon: Icons.analytics,
      children: [
        _buildStatCard(
          title: 'Total Products',
          value: '89',
          change: '+5 this month',
          color: Colors.blue,
          icon: Icons.inventory,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          title: 'Total Sales',
          value: 'TZS 1.2M',
          change: '+15.3% this month',
          color: Colors.green,
          icon: Icons.attach_money,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          title: 'Orders',
          value: '847',
          change: '+12.7% this month',
          color: Colors.purple,
          icon: Icons.shopping_bag,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          title: 'Customers',
          value: '234',
          change: '+8.5% this month',
          color: Colors.orange,
          icon: Icons.people,
        ),
      ],
    );
  }

  Widget _buildActions() {
    return _buildSection(
      title: 'Account Actions',
      icon: Icons.manage_accounts,
      children: [
        _buildActionTile(
          title: 'Change Password',
          subtitle: 'Update your password',
          icon: Icons.lock_outline,
          onTap: _changePassword,
        ),
        _buildActionTile(
          title: 'Store Settings',
          subtitle: 'Manage store preferences',
          icon: Icons.settings,
          onTap: _storeSettings,
        ),
        _buildActionTile(
          title: 'Payment Settings',
          subtitle: 'Bank account details',
          icon: Icons.payment,
          onTap: _paymentSettings,
        ),
        _buildActionTile(
          title: 'Sales Report',
          subtitle: 'Download sales data',
          icon: Icons.download,
          onTap: _downloadReport,
        ),
        _buildActionTile(
          title: 'Support Center',
          subtitle: 'Get help and support',
          icon: Icons.help_outline,
          onTap: _supportCenter,
        ),
        _buildActionTile(
          title: 'Close Store',
          subtitle: 'Temporarily close store',
          icon: Icons.store_mall_directory,
          color: Colors.red,
          onTap: _closeStore,
        ),
      ],
    );
  }

  Widget _buildSection({
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

  Widget _buildInfoTile({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.vendorColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.vendorColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit, size: 16),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.vendorColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.vendorColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.vendorColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.vendorColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: subtitle,
                      isExpanded: true,
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
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String change,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  change,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    Color? color,
    required VoidCallback onTap,
  }) {
    final actionColor = color ?? AppColors.vendorColor;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: actionColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: actionColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: color,
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
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editProfile() {
    ModernToast.info(context, 'Edit profile mode activated');
  }

  void _editField(String field, TextEditingController controller, {int maxLines = 1}) async {
    final result = await ModernBottomSheet.showCustom(
      context: context,
      title: 'Edit $field',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              labelText: field,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.vendorColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      setState(() {});
      ModernToast.success(context, '$field updated successfully!');
    }
  }

  void _editLocation() {
    ModernToast.info(context, 'Location editor coming soon!');
  }

  void _editCategory() {
    ModernToast.info(context, 'Category editor coming soon!');
  }

  void _editStoreAddress() {
    ModernToast.info(context, 'Store address editor coming soon!');
  }

  void _changePassword() {
    ModernToast.info(context, 'Password change coming soon!');
  }

  void _storeSettings() {
    ModernToast.info(context, 'Store settings coming soon!');
  }

  void _paymentSettings() {
    ModernToast.info(context, 'Payment settings coming soon!');
  }

  void _downloadReport() {
    ModernToast.info(context, 'Sales report download coming soon!');
  }

  void _supportCenter() {
    ModernToast.info(context, 'Support center coming soon!');
  }

  void _closeStore() async {
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: 'Close Store',
      message: 'This will temporarily make your store unavailable to customers.',
      confirmText: 'Close',
      cancelText: 'Cancel',
      icon: Icons.store_mall_directory,
      isDangerous: true,
    );

    if (result == true && mounted) {
      ModernToast.error(context, 'Store closure coming soon!');
    }
  }
}