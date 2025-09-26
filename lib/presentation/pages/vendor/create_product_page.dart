import 'dart:io';
import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';
import 'package:niffer_store/core/widgets/modern_toast.dart';
import 'package:niffer_store/core/widgets/modern_bottom_sheet.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({Key? key}) : super(key: key);

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  // Form controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _compareAtPriceController = TextEditingController();
  final _skuController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _inventoryController = TextEditingController();
  final _weightController = TextEditingController();

  // Form state
  String _selectedCategory = 'Electronics';
  String _selectedBrand = '';
  String _selectedCondition = 'New';
  bool _trackInventory = true;
  bool _allowOutOfStock = false;
  bool _requiresShipping = true;
  bool _isTaxable = true;
  bool _isDigital = false;

  List<String> _tags = [];
  List<File> _images = [];
  List<ProductVariant> _variants = [];
  List<ProductAttribute> _attributes = [];

  final List<String> _categories = [
    'Electronics',
    'Fashion & Clothing',
    'Home & Garden',
    'Sports & Outdoors',
    'Health & Beauty',
    'Books & Education',
    'Toys & Games',
    'Automotive',
    'Food & Beverages',
    'Other',
  ];

  final List<String> _conditions = ['New', 'Used - Like New', 'Used - Good', 'Used - Fair'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _glowController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _compareAtPriceController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _inventoryController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Product'),
        backgroundColor: AppColors.vendorColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Basic Info', icon: Icon(Icons.info_outline)),
            Tab(text: 'Images', icon: Icon(Icons.photo_library)),
            Tab(text: 'Variants', icon: Icon(Icons.tune)),
            Tab(text: 'Advanced', icon: Icon(Icons.settings)),
          ],
        ),
        actions: [
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: _glowAnimation.value * 0.5),
                      blurRadius: 10 * _glowAnimation.value,
                      spreadRadius: 2 * _glowAnimation.value,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.vendorColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Save Product',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
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
    return Form(
      key: _formKey,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildBasicInfoTab(),
          _buildImagesTab(),
          _buildVariantsTab(),
          _buildAdvancedTab(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Container(
          width: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              right: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: _buildDesktopTabs(),
        ),
        Expanded(
          child: Form(
            key: _formKey,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBasicInfoTab(),
                _buildImagesTab(),
                _buildVariantsTab(),
                _buildAdvancedTab(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopTabs() {
    return Column(
      children: [
        _buildDesktopTab(0, 'Basic Info', Icons.info_outline),
        _buildDesktopTab(1, 'Images', Icons.photo_library),
        _buildDesktopTab(2, 'Variants', Icons.tune),
        _buildDesktopTab(3, 'Advanced', Icons.settings),
      ],
    );
  }

  Widget _buildDesktopTab(int index, String title, IconData icon) {
    final isSelected = _tabController.index == index;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => _tabController.animateTo(index),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected 
                ? AppColors.vendorColor.withValues(alpha: 0.1)
                : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                ? Border.all(color: AppColors.vendorColor.withValues(alpha: 0.3))
                : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.vendorColor : Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? AppColors.vendorColor : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Product Information'),
          const SizedBox(height: 16),
          _buildAnimatedTextField(
            controller: _nameController,
            label: 'Product Name',
            hint: 'Enter product name',
            icon: Icons.shopping_bag,
            validator: (value) => value?.isEmpty == true ? 'Name is required' : null,
          ),
          const SizedBox(height: 16),
          _buildAnimatedTextField(
            controller: _descriptionController,
            label: 'Description',
            hint: 'Describe your product...',
            icon: Icons.description,
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAnimatedTextField(
                  controller: _priceController,
                  label: 'Price (TZS)',
                  hint: '0.00',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.isEmpty == true ? 'Price is required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAnimatedTextField(
                  controller: _compareAtPriceController,
                  label: 'Compare at Price (Optional)',
                  hint: '0.00',
                  icon: Icons.compare,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCategoryDropdown(),
          const SizedBox(height: 16),
          _buildConditionDropdown(),
          const SizedBox(height: 24),
          _buildSectionHeader('Product Details'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAnimatedTextField(
                  controller: _skuController,
                  label: 'SKU (Stock Keeping Unit)',
                  hint: 'AUTO-GENERATED',
                  icon: Icons.qr_code,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAnimatedTextField(
                  controller: _barcodeController,
                  label: 'Barcode (Optional)',
                  hint: 'Scan or enter barcode',
                  icon: Icons.qr_code_scanner,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTagsInput(),
        ],
      ),
    );
  }

  Widget _buildImagesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Product Images'),
          const SizedBox(height: 8),
          Text(
            'Add up to 10 high-quality images. The first image will be the main product image.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 16),
          _buildImageUploadGrid(),
          const SizedBox(height: 24),
          _buildImageGuidelines(),
        ],
      ),
    );
  }

  Widget _buildVariantsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Product Variants'),
          const SizedBox(height: 8),
          Text(
            'Create variations of your product (e.g., different sizes, colors).',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 16),
          _buildVariantsList(),
          const SizedBox(height: 16),
          _buildAddVariantButton(),
          const SizedBox(height: 24),
          _buildSectionHeader('Product Attributes'),
          const SizedBox(height: 16),
          _buildAttributesList(),
          const SizedBox(height: 16),
          _buildAddAttributeButton(),
        ],
      ),
    );
  }

  Widget _buildAdvancedTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Inventory Management'),
          const SizedBox(height: 16),
          _buildInventorySettings(),
          const SizedBox(height: 24),
          _buildSectionHeader('Shipping & Tax'),
          const SizedBox(height: 16),
          _buildShippingSettings(),
          const SizedBox(height: 24),
          _buildSectionHeader('SEO & Visibility'),
          const SizedBox(height: 16),
          _buildSEOSettings(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.vendorColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.vendorColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.vendorColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.vendorColor, width: 2),
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        color: Theme.of(context).cardColor,
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: InputDecoration(
          labelText: 'Category',
          prefixIcon: Icon(Icons.category, color: AppColors.vendorColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: _categories.map((category) {
          return DropdownMenuItem(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: (value) => setState(() => _selectedCategory = value!),
      ),
    );
  }

  Widget _buildConditionDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        color: Theme.of(context).cardColor,
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedCondition,
        decoration: InputDecoration(
          labelText: 'Condition',
          prefixIcon: Icon(Icons.new_releases, color: AppColors.vendorColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: _conditions.map((condition) {
          return DropdownMenuItem(
            value: condition,
            child: Text(condition),
          );
        }).toList(),
        onChanged: (value) => setState(() => _selectedCondition = value!),
      ),
    );
  }

  Widget _buildTagsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._tags.map((tag) => _buildTagChip(tag)),
            _buildAddTagButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildTagChip(String tag) {
    return Chip(
      label: Text(tag),
      backgroundColor: AppColors.vendorColor.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: AppColors.vendorColor),
      deleteIcon: Icon(Icons.close, size: 16, color: AppColors.vendorColor),
      onDeleted: () => setState(() => _tags.remove(tag)),
    );
  }

  Widget _buildAddTagButton() {
    return ActionChip(
      label: const Text('+ Add Tag'),
      onPressed: _addTag,
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildImageUploadGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: _images.length + (_images.length < 10 ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _images.length) {
          return _buildImageTile(_images[index], index);
        } else {
          return _buildAddImageTile();
        }
      },
    );
  }

  Widget _buildImageTile(File image, int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: FileImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (index == 0)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.vendorColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Main',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => setState(() => _images.removeAt(index)),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageTile() {
    return GestureDetector(
      onTap: _addImage,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.vendorColor.withValues(alpha: 0.3),
            style: BorderStyle.solid,
            width: 2,
          ),
          color: AppColors.vendorColor.withValues(alpha: 0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 32,
              color: AppColors.vendorColor,
            ),
            const SizedBox(height: 8),
            Text(
              'Add Image',
              style: TextStyle(
                color: AppColors.vendorColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGuidelines() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Image Guidelines',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildGuideline('Use high-resolution images (at least 1000x1000 pixels)'),
          _buildGuideline('Show product from multiple angles'),
          _buildGuideline('Use good lighting and clear backgrounds'),
          _buildGuideline('Avoid watermarks or text overlays'),
          _buildGuideline('Supported formats: JPG, PNG, WebP'),
        ],
      ),
    );
  }

  Widget _buildGuideline(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.blue[600],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.blue[700], fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantsList() {
    if (_variants.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Icon(
              Icons.tune,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No variants added yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add variants like size, color, or style',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _variants.map((variant) => _buildVariantCard(variant)).toList(),
    );
  }

  Widget _buildVariantCard(ProductVariant variant) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${variant.option} - ${variant.value}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _variants.remove(variant)),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
            if (variant.additionalPrice != 0) ...[
              const SizedBox(height: 8),
              Text(
                'Additional Price: TZS ${variant.additionalPrice.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.green[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAddVariantButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _addVariant,
        icon: const Icon(Icons.add),
        label: const Text('Add Variant'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.vendorColor,
          side: BorderSide(color: AppColors.vendorColor),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildAttributesList() {
    if (_attributes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Icon(
              Icons.list_alt,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No attributes added yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add product specifications and details',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _attributes.map((attribute) => _buildAttributeCard(attribute)).toList(),
    );
  }

  Widget _buildAttributeCard(ProductAttribute attribute) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attribute.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    attribute.value,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => setState(() => _attributes.remove(attribute)),
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAttributeButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _addAttribute,
        icon: const Icon(Icons.add),
        label: const Text('Add Attribute'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.vendorColor,
          side: BorderSide(color: AppColors.vendorColor),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildInventorySettings() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Track inventory'),
          subtitle: const Text('Track quantity when orders are placed'),
          value: _trackInventory,
          activeColor: AppColors.vendorColor,
          onChanged: (value) => setState(() => _trackInventory = value),
        ),
        if (_trackInventory) ...[
          const SizedBox(height: 16),
          _buildAnimatedTextField(
            controller: _inventoryController,
            label: 'Inventory Quantity',
            hint: '0',
            icon: Icons.inventory,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Continue selling when out of stock'),
            value: _allowOutOfStock,
            activeColor: AppColors.vendorColor,
            onChanged: (value) => setState(() => _allowOutOfStock = value),
          ),
        ],
      ],
    );
  }

  Widget _buildShippingSettings() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('This is a physical product'),
          subtitle: const Text('Requires shipping'),
          value: _requiresShipping,
          activeColor: AppColors.vendorColor,
          onChanged: (value) => setState(() => _requiresShipping = value),
        ),
        if (_requiresShipping) ...[
          const SizedBox(height: 16),
          _buildAnimatedTextField(
            controller: _weightController,
            label: 'Weight (kg)',
            hint: '0.0',
            icon: Icons.monitor_weight,
            keyboardType: TextInputType.number,
          ),
        ],
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Charge tax on this product'),
          value: _isTaxable,
          activeColor: AppColors.vendorColor,
          onChanged: (value) => setState(() => _isTaxable = value),
        ),
      ],
    );
  }

  Widget _buildSEOSettings() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Digital product'),
          subtitle: const Text('No physical shipping required'),
          value: _isDigital,
          activeColor: AppColors.vendorColor,
          onChanged: (value) => setState(() => _isDigital = value),
        ),
      ],
    );
  }

  void _addTag() async {
    final tag = await _showTextInputDialog(
      title: 'Add Tag',
      hint: 'Enter tag name',
    );
    
    if (tag != null && tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() => _tags.add(tag));
    }
  }

  void _addImage() {
    // TODO: Implement image picker
    ModernToast.info(context, 'Image picker feature coming soon!');
  }

  void _addVariant() async {
    final result = await ModernBottomSheet.showCustom(
      context: context,
      title: 'Add Variant',
      content: AddVariantForm(),
    );

    if (result is ProductVariant) {
      setState(() => _variants.add(result));
    }
  }

  void _addAttribute() async {
    final result = await ModernBottomSheet.showCustom(
      context: context,
      title: 'Add Attribute',
      content: AddAttributeForm(),
    );

    if (result is ProductAttribute) {
      setState(() => _attributes.add(result));
    }
  }

  Future<String?> _showTextInputDialog({
    required String title,
    required String hint,
  }) async {
    String? result;
    await showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: hint),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                result = controller.text;
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
    return result;
  }

  void _saveProduct() {
    if (_formKey.currentState?.validate() == true) {
      ModernToast.success(context, 'Product saved successfully!');
      Navigator.pop(context);
    }
  }
}

class ProductVariant {
  final String option;
  final String value;
  final double additionalPrice;

  ProductVariant({
    required this.option,
    required this.value,
    this.additionalPrice = 0.0,
  });
}

class ProductAttribute {
  final String name;
  final String value;

  ProductAttribute({
    required this.name,
    required this.value,
  });
}

class AddVariantForm extends StatefulWidget {
  @override
  State<AddVariantForm> createState() => _AddVariantFormState();
}

class _AddVariantFormState extends State<AddVariantForm> {
  final _optionController = TextEditingController();
  final _valueController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _optionController,
          decoration: const InputDecoration(
            labelText: 'Option (e.g., Size, Color)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _valueController,
          decoration: const InputDecoration(
            labelText: 'Value (e.g., Large, Red)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _priceController,
          decoration: const InputDecoration(
            labelText: 'Additional Price (Optional)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (_optionController.text.isNotEmpty && _valueController.text.isNotEmpty) {
                  final variant = ProductVariant(
                    option: _optionController.text,
                    value: _valueController.text,
                    additionalPrice: double.tryParse(_priceController.text) ?? 0.0,
                  );
                  Navigator.pop(context, variant);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.vendorColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ],
    );
  }
}

class AddAttributeForm extends StatefulWidget {
  @override
  State<AddAttributeForm> createState() => _AddAttributeFormState();
}

class _AddAttributeFormState extends State<AddAttributeForm> {
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Attribute Name (e.g., Material, Brand)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _valueController,
          decoration: const InputDecoration(
            labelText: 'Attribute Value (e.g., Cotton, Nike)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty && _valueController.text.isNotEmpty) {
                  final attribute = ProductAttribute(
                    name: _nameController.text,
                    value: _valueController.text,
                  );
                  Navigator.pop(context, attribute);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.vendorColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ],
    );
  }
}