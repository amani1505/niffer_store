import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';
import 'package:niffer_store/core/widgets/modern_toast.dart';
import 'package:niffer_store/core/widgets/modern_bottom_sheet.dart';
import 'package:niffer_store/core/widgets/page_skeletons.dart';
import 'package:niffer_store/presentation/providers/auth_provider.dart';
import 'package:niffer_store/presentation/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  String _language = 'English';
  bool _isLoading = true;
  
  final _nameController = TextEditingController(text: 'Michael Smith');
  final _emailController = TextEditingController(text: 'michael@example.com');
  final _phoneController = TextEditingController(text: '+255 789 123 456');
  final _addressController = TextEditingController(text: 'Msimbazi Street, Dar es Salaam');

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    // Simulate loading profile data
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Profile'),
        backgroundColor: AppColors.customerColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editProfile,
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;
          
          if (user == null) {
            return const Center(
              child: Text('Please login to view profile'),
            );
          }

          if (_isLoading) {
            return const ProfilePageSkeleton();
          }

          return ResponsiveLayout(
            mobile: _buildMobileLayout(),
            desktop: _buildDesktopLayout(),
          );
        },
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
          _buildPreferences(),
          const SizedBox(height: 20),
          _buildOrderHistory(),
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
                    _buildPreferences(),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _buildOrderHistory(),
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
            AppColors.customerColor,
            AppColors.customerColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.customerColor.withValues(alpha: 0.3),
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
                ),
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: Colors.white24,
                  child: Text(
                    _nameController.text[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
                    color: AppColors.customerColor,
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
              'Valued Customer',
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
          title: 'Address',
          subtitle: _addressController.text,
          icon: Icons.location_on,
          onEdit: () => _editField('Address', _addressController, maxLines: 2),
        ),
        _buildInfoTile(
          title: 'Member Since',
          subtitle: 'June 15, 2024',
          icon: Icons.calendar_today,
        ),
        _buildInfoTile(
          title: 'Customer Level',
          subtitle: 'Gold Member',
          icon: Icons.star,
        ),
      ],
    );
  }

  Widget _buildPreferences() {
    return _buildSection(
      title: 'Preferences',
      icon: Icons.settings,
      children: [
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return _buildSwitchTile(
              title: 'Dark Mode',
              subtitle: 'Use dark theme',
              icon: Icons.dark_mode,
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme(),
            );
          },
        ),
        _buildSwitchTile(
          title: 'Email Notifications',
          subtitle: 'Receive email notifications',
          icon: Icons.mail_outline,
          value: _emailNotifications,
          onChanged: (value) => setState(() => _emailNotifications = value),
        ),
        _buildSwitchTile(
          title: 'Push Notifications',
          subtitle: 'Receive push notifications',
          icon: Icons.notifications,
          value: _pushNotifications,
          onChanged: (value) => setState(() => _pushNotifications = value),
        ),
        _buildSwitchTile(
          title: 'SMS Notifications',
          subtitle: 'Order updates via SMS',
          icon: Icons.sms,
          value: _smsNotifications,
          onChanged: (value) => setState(() => _smsNotifications = value),
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

  Widget _buildOrderHistory() {
    return _buildSection(
      title: 'Order History',
      icon: Icons.shopping_bag,
      children: [
        _buildStatCard(
          title: 'Total Orders',
          value: '23',
          change: '3 this month',
          color: Colors.blue,
          icon: Icons.shopping_bag,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          title: 'Total Spent',
          value: 'TZS 234K',
          change: 'TZS 45K this month',
          color: Colors.green,
          icon: Icons.attach_money,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          title: 'Favorite Store',
          value: 'Tech Haven',
          change: '8 orders',
          color: Colors.purple,
          icon: Icons.store,
        ),
        const SizedBox(height: 16),
        _buildActionTile(
          title: 'View All Orders',
          subtitle: 'See complete order history',
          icon: Icons.history,
          onTap: _viewOrderHistory,
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
          title: 'Address Book',
          subtitle: 'Manage shipping addresses',
          icon: Icons.location_on,
          onTap: _manageAddresses,
        ),
        _buildActionTile(
          title: 'Payment Methods',
          subtitle: 'Manage payment options',
          icon: Icons.payment,
          onTap: _managePayments,
        ),
        _buildActionTile(
          title: 'Wishlist',
          subtitle: 'View saved items',
          icon: Icons.favorite,
          onTap: _viewWishlist,
        ),
        _buildActionTile(
          title: 'Help & Support',
          subtitle: 'Get help with your orders',
          icon: Icons.help_outline,
          onTap: _helpSupport,
        ),
        _buildActionTile(
          title: 'Logout',
          subtitle: 'Sign out of your account',
          icon: Icons.logout,
          color: Colors.red,
          onTap: () => _showLogoutDialog(context),
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
              Icon(icon, color: AppColors.customerColor, size: 24),
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
              color: AppColors.customerColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.customerColor, size: 20),
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
              color: AppColors.customerColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.customerColor, size: 20),
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
            activeColor: AppColors.customerColor,
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
              color: AppColors.customerColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.customerColor, size: 20),
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
                    color: Colors.grey[600],
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
    final actionColor = color ?? AppColors.customerColor;
    
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
                  backgroundColor: AppColors.customerColor,
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

  void _viewOrderHistory() {
    ModernToast.info(context, 'Order history coming soon!');
  }

  void _changePassword() {
    ModernToast.info(context, 'Password change coming soon!');
  }

  void _manageAddresses() {
    ModernToast.info(context, 'Address management coming soon!');
  }

  void _managePayments() {
    ModernToast.info(context, 'Payment management coming soon!');
  }

  void _viewWishlist() {
    ModernToast.info(context, 'Wishlist coming soon!');
  }

  void _helpSupport() {
    ModernToast.info(context, 'Help & support coming soon!');
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthProvider>().logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
