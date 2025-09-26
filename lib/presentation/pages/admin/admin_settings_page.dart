import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';
import 'package:niffer_store/core/widgets/modern_toast.dart';
import 'package:niffer_store/core/widgets/modern_bottom_sheet.dart';
import 'package:niffer_store/core/widgets/theme_toggle.dart';
import 'package:niffer_store/presentation/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({Key? key}) : super(key: key);

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsAlerts = false;
  bool _maintenanceMode = false;
  bool _autoBackups = true;
  bool _twoFactorAuth = false;
  String _language = 'English';
  String _timezone = 'East Africa Time (UTC+3)';
  String _currency = 'TZS';
  double _commissionRate = 5.0;
  int _orderRetentionDays = 365;
  
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
        backgroundColor: AppColors.adminColor,
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
          _buildAccountSection(),
          const SizedBox(height: 20),
          _buildNotificationSection(),
          const SizedBox(height: 20),
          _buildThemeSection(),
          const SizedBox(height: 20),
          _buildPlatformSection(),
          const SizedBox(height: 20),
          _buildSecuritySection(),
          const SizedBox(height: 20),
          _buildSystemSection(),
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
                    _buildAccountSection(),
                    const SizedBox(height: 24),
                    _buildNotificationSection(),
                    const SizedBox(height: 24),
                    _buildThemeSection(),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _buildPlatformSection(),
                    const SizedBox(height: 24),
                    _buildSecuritySection(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSystemSection(),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return _buildSettingsCard(
      title: 'Account Settings',
      icon: Icons.account_circle,
      children: [
        _buildSettingsItem(
          title: 'Admin Name',
          subtitle: 'John Doe',
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editField('Name', 'John Doe'),
          ),
        ),
        _buildSettingsItem(
          title: 'Email Address',
          subtitle: 'admin@nifferstore.com',
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editField('Email', 'admin@nifferstore.com'),
          ),
        ),
        _buildSettingsItem(
          title: 'Phone Number',
          subtitle: '+255 123 456 789',
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editField('Phone', '+255 123 456 789'),
          ),
        ),
        _buildSettingsItem(
          title: 'Change Password',
          subtitle: 'Last changed 30 days ago',
          trailing: TextButton(
            onPressed: _changePassword,
            child: const Text('Change'),
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
          title: 'Push Notifications',
          subtitle: 'Receive push notifications',
          value: _pushNotifications,
          onChanged: (value) => setState(() => _pushNotifications = value),
        ),
        _buildSwitchItem(
          title: 'SMS Alerts',
          subtitle: 'Critical alerts via SMS',
          value: _smsAlerts,
          onChanged: (value) => setState(() => _smsAlerts = value),
        ),
      ],
    );
  }

  Widget _buildPlatformSection() {
    return _buildSettingsCard(
      title: 'Platform Settings',
      icon: Icons.settings,
      children: [
        _buildDropdownItem(
          title: 'Language',
          value: _language,
          items: ['English', 'Swahili', 'French'],
          onChanged: (value) => setState(() => _language = value!),
        ),
        _buildDropdownItem(
          title: 'Timezone',
          value: _timezone,
          items: [
            'East Africa Time (UTC+3)',
            'Central Africa Time (UTC+1)',
            'West Africa Time (UTC+1)',
          ],
          onChanged: (value) => setState(() => _timezone = value!),
        ),
        _buildDropdownItem(
          title: 'Base Currency',
          value: _currency,
          items: ['TZS', 'USD', 'EUR'],
          onChanged: (value) => setState(() => _currency = value!),
        ),
        _buildSliderItem(
          title: 'Platform Commission Rate',
          subtitle: '${_commissionRate.toStringAsFixed(1)}%',
          value: _commissionRate,
          min: 0.0,
          max: 20.0,
          divisions: 40,
          onChanged: (value) => setState(() => _commissionRate = value),
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return _buildSettingsCard(
      title: 'Security Settings',
      icon: Icons.security,
      children: [
        _buildSwitchItem(
          title: 'Two-Factor Authentication',
          subtitle: 'Add extra security to your account',
          value: _twoFactorAuth,
          onChanged: (value) => setState(() => _twoFactorAuth = value),
        ),
        _buildSettingsItem(
          title: 'Login History',
          subtitle: 'View recent login attempts',
          trailing: TextButton(
            onPressed: _viewLoginHistory,
            child: const Text('View'),
          ),
        ),
        _buildSettingsItem(
          title: 'Active Sessions',
          subtitle: '2 active sessions',
          trailing: TextButton(
            onPressed: _manageActiveSessions,
            child: const Text('Manage'),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemSection() {
    return _buildSettingsCard(
      title: 'System Settings',
      icon: Icons.computer,
      children: [
        _buildSwitchItem(
          title: 'Maintenance Mode',
          subtitle: 'Put platform in maintenance mode',
          value: _maintenanceMode,
          onChanged: (value) {
            if (value) {
              _confirmMaintenanceMode(value);
            } else {
              setState(() => _maintenanceMode = value);
            }
          },
        ),
        _buildSwitchItem(
          title: 'Automatic Backups',
          subtitle: 'Daily automated data backups',
          value: _autoBackups,
          onChanged: (value) => setState(() => _autoBackups = value),
        ),
        _buildSliderItem(
          title: 'Order Data Retention',
          subtitle: '$_orderRetentionDays days',
          value: _orderRetentionDays.toDouble(),
          min: 30,
          max: 730,
          divisions: 35,
          onChanged: (value) => setState(() => _orderRetentionDays = value.round()),
        ),
        _buildSettingsItem(
          title: 'Database Management',
          subtitle: 'Backup and restore options',
          trailing: TextButton(
            onPressed: _manageDatabse,
            child: const Text('Manage'),
          ),
        ),
        _buildSettingsItem(
          title: 'System Logs',
          subtitle: 'View system activity logs',
          trailing: TextButton(
            onPressed: _viewSystemLogs,
            child: const Text('View'),
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
              Icon(icon, color: AppColors.adminColor, size: 24),
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
            activeColor: AppColors.adminColor,
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
                  color: AppColors.adminColor,
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
            activeColor: AppColors.adminColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    ModernToast.success(
      context,
      'Settings saved successfully!',
    );
  }

  void _editField(String field, String currentValue) async {
    final controller = TextEditingController(text: currentValue);
    
    final result = await ModernBottomSheet.showCustom(
      context: context,
      title: 'Edit $field',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
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
                onPressed: () => Navigator.pop(context, controller.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.adminColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );

    if (result != null && result != false && result != currentValue) {
      ModernToast.success(context, '$field updated successfully!');
    }
    
    controller.dispose();
  }

  void _changePassword() async {
    final result = await ModernBottomSheet.showCustom(
      context: context,
      title: 'Change Password',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'New Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
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
                onPressed: () {
                  if (_passwordController.text == _confirmPasswordController.text) {
                    Navigator.pop(context, true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.adminColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Update'),
              ),
            ],
          ),
        ],
      ),
    );

    if (result == true) {
      ModernToast.success(context, 'Password updated successfully!');
      _passwordController.clear();
      _confirmPasswordController.clear();
    }
  }

  void _confirmMaintenanceMode(bool enable) async {
    final result = await ModernBottomSheet.showConfirmation(
      context: context,
      title: 'Enable Maintenance Mode',
      message: 'This will make the platform unavailable to users. Are you sure?',
      confirmText: 'Enable',
      cancelText: 'Cancel',
      icon: Icons.warning,
      isDangerous: true,
    );

    if (result == true) {
      setState(() => _maintenanceMode = enable);
      ModernToast.success(context, 'Maintenance mode enabled');
    }
  }

  void _viewLoginHistory() {
    ModernToast.info(context, 'Login history feature coming soon!');
  }

  void _manageActiveSessions() {
    ModernToast.info(context, 'Session management feature coming soon!');
  }

  void _manageDatabse() {
    ModernToast.info(context, 'Database management feature coming soon!');
  }

  void _viewSystemLogs() {
    ModernToast.info(context, 'System logs feature coming soon!');
  }

  Widget _buildThemeSection() {
    return _buildSettingsCard(
      title: 'Theme Preferences',
      icon: Icons.palette,
      children: [
        ThemeSelector(
          primaryColor: AppColors.adminColor,
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
              activeColor: AppColors.adminColor,
              size: 50,
            ),
          ],
        ),
      ],
    );
  }
}