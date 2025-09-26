import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';

class ProductBanner extends StatefulWidget {
  final List<ProductBannerData> products;
  final double height;
  final Duration autoScrollDuration;
  final bool enableAutoScroll;
  final bool enableParallax;
  final VoidCallback? onViewAll;

  const ProductBanner({
    super.key,
    required this.products,
    this.height = 200,
    this.autoScrollDuration = const Duration(seconds: 4),
    this.enableAutoScroll = true,
    this.enableParallax = true,
    this.onViewAll,
  });

  @override
  State<ProductBanner> createState() => _ProductBannerState();
}

class _ProductBannerState extends State<ProductBanner>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  int _currentIndex = 0;
  bool _isManualScrolling = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideController.forward();
    _fadeController.forward();

    if (widget.enableAutoScroll && widget.products.isNotEmpty) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    Future.delayed(widget.autoScrollDuration, () {
      if (mounted && !_isManualScrolling && widget.products.isNotEmpty) {
        final nextIndex = (_currentIndex + 1) % widget.products.length;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      height: widget.height,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          Expanded(child: _buildPageView()),
          const SizedBox(height: 12),
          _buildIndicators(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Featured Products',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Discover amazing deals',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          if (widget.onViewAll != null)
            TextButton(
              onPressed: widget.onViewAll,
              child: const Text('View All'),
            ),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
          _isManualScrolling = true;
        });
        Future.delayed(const Duration(seconds: 2), () {
          _isManualScrolling = false;
        });
      },
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, (1 - _slideAnimation.value) * 50),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildProductCard(widget.products[index], index),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductCard(ProductBannerData product, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          // Background with gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  product.backgroundColor?.withValues(alpha: 0.8) ?? AppColors.primary.withValues(alpha: 0.8),
                  product.backgroundColor?.withValues(alpha: 0.6) ?? AppColors.primary.withValues(alpha: 0.6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: (product.backgroundColor ?? AppColors.primary).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          // Background pattern
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: RadialGradient(
                  center: const Alignment(0.7, -0.3),
                  radius: 1.2,
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Product image
          if (product.imageUrl != null)
            Positioned(
              right: -20,
              top: -10,
              bottom: -10,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: product.imageUrl!.startsWith('http')
                          ? NetworkImage(product.imageUrl!) as ImageProvider
                          : AssetImage(product.imageUrl!),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withValues(alpha: 0.1),
                        BlendMode.overlay,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Content overlay
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (product.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        product.badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    product.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.subtitle ?? '',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (product.originalPrice != null) ...[
                        Text(
                          product.originalPrice!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        product.price,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Glassmorphism effect
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
          ),

          // Touch ripple
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => product.onTap?.call(),
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.products.asMap().entries.map((entry) {
        final index = entry.key;
        final isActive = index == _currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.3),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: widget.height,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'No featured products',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductBannerData {
  final String title;
  final String? subtitle;
  final String price;
  final String? originalPrice;
  final String? imageUrl;
  final String? badge;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const ProductBannerData({
    required this.title,
    this.subtitle,
    required this.price,
    this.originalPrice,
    this.imageUrl,
    this.badge,
    this.backgroundColor,
    this.onTap,
  });
}

class HeroBanner extends StatefulWidget {
  final List<HeroBannerData> banners;
  final double height;
  final Duration autoScrollDuration;
  final bool enableAutoScroll;
  final bool enableParallax;

  const HeroBanner({
    super.key,
    required this.banners,
    this.height = 300,
    this.autoScrollDuration = const Duration(seconds: 5),
    this.enableAutoScroll = true,
    this.enableParallax = true,
  });

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _animationController.forward();
    
    if (widget.enableAutoScroll && widget.banners.isNotEmpty) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    Future.delayed(widget.autoScrollDuration, () {
      if (mounted && widget.banners.isNotEmpty) {
        final nextIndex = (_currentIndex + 1) % widget.banners.length;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return SizedBox(height: widget.height);
    }

    return Container(
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemCount: widget.banners.length,
            itemBuilder: (context, index) {
              return _buildBannerItem(widget.banners[index]);
            },
          ),
          
          // Gradient overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),

          // Page indicators
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.banners.asMap().entries.map((entry) {
                final index = entry.key;
                final isActive = index == _currentIndex;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 32 : 12,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: isActive ? Colors.white : Colors.white38,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerItem(HeroBannerData banner) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        if (banner.imageUrl != null)
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: banner.imageUrl!.startsWith('http')
                    ? NetworkImage(banner.imageUrl!) as ImageProvider
                    : AssetImage(banner.imageUrl!),
                fit: BoxFit.cover,
              ),
            ),
          ),

        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.7),
              ],
            ),
          ),
        ),

        // Content
        Positioned(
          bottom: 60,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (banner.badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    banner.badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                banner.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              if (banner.subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  banner.subtitle!,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                  ),
                ),
              ],
              if (banner.actionText != null) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: banner.onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(banner.actionText!),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class HeroBannerData {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String? badge;
  final String? actionText;
  final VoidCallback? onAction;

  const HeroBannerData({
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.badge,
    this.actionText,
    this.onAction,
  });
}