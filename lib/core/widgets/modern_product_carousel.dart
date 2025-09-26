import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/widgets/image_skeleton.dart';
import 'package:niffer_store/domain/entities/product.dart';

class ModernProductCarousel extends StatefulWidget {
  final List<Product> featuredProducts;
  final double height;
  final EdgeInsets margin;
  final BorderRadius borderRadius;
  final Duration autoPlayDuration;
  final bool enableAutoPlay;
  final Function(Product)? onProductTap;
  final Function(int)? onPageChanged;

  const ModernProductCarousel({
    super.key,
    required this.featuredProducts,
    this.height = 280,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.autoPlayDuration = const Duration(seconds: 4),
    this.enableAutoPlay = true,
    this.onProductTap,
    this.onPageChanged,
  });

  @override
  State<ModernProductCarousel> createState() => _ModernProductCarouselState();
}

class _ModernProductCarouselState extends State<ModernProductCarousel>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _scaleController;
  Timer? _autoPlayTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    if (widget.enableAutoPlay && widget.featuredProducts.isNotEmpty) {
      _startAutoPlay();
    }

    _animationController.forward();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(widget.autoPlayDuration, (timer) {
      if (mounted && widget.featuredProducts.isNotEmpty) {
        final nextPage = (_currentPage + 1) % widget.featuredProducts.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _scaleController.dispose();
    _autoPlayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.featuredProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final animationValue = _animationController.value;
        
        return Transform.translate(
          offset: Offset(0, 50 * (1 - animationValue)),
          child: Opacity(
            opacity: animationValue,
            child: _buildCarousel(),
          ),
        );
      },
    );
  }

  Widget _buildCarousel() {
    return Container(
      height: widget.height,
      margin: widget.margin,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
          widget.onPageChanged?.call(index);
        },
        itemCount: widget.featuredProducts.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 1;
              if (_pageController.position.haveDimensions) {
                value = (_pageController.page ?? 0) - index;
                value = (1 - (value.abs() * 0.1)).clamp(0.0, 1.0);
              }

              return Transform.scale(
                scale: value,
                child: _buildProductCard(widget.featuredProducts[index], index),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Product product, int index) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTapCancel: () => _scaleController.reverse(),
      onTap: () {
        _stopAutoPlay();
        widget.onProductTap?.call(product);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) _startAutoPlay();
        });
      },
      child: AnimatedBuilder(
        animation: _scaleController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_scaleController.value * 0.05),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: widget.borderRadius,
                child: Stack(
                  children: [
                    _buildProductImage(product),
                    _buildGradientOverlay(),
                    _buildProductInfo(product),
                    _buildDiscountBadge(product),
                    _buildFloatingElements(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    return Positioned.fill(
      child: CachedNetworkImage(
        imageUrl: product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
        fit: BoxFit.cover,
        placeholder: (context, url) => const ImageSkeleton(
          width: double.infinity,
          height: double.infinity,
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[300]!,
                Colors.grey[400]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              size: 48,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.transparent,
              Colors.black.withValues(alpha: 0.3),
              Colors.black.withValues(alpha: 0.7),
            ],
            stops: const [0.0, 0.4, 0.7, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(Product product) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            product.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 3,
                  color: Colors.black54,
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'TZS ${product.finalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (product.hasDiscount) ...[
                const SizedBox(width: 8),
                Text(
                  'TZS ${product.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
              const Spacer(),
              _buildRating(product.rating),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountBadge(Product product) {
    if (!product.hasDiscount) return const SizedBox.shrink();

    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
    );
  }

  Widget _buildRating(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            size: 14,
            color: Colors.amber,
          ),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingElements() {
    return Positioned.fill(
      child: Stack(
        children: [
          // Floating dots animation
          for (int i = 0; i < 6; i++)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final delay = i * 0.2;
                final animationValue = (_animationController.value - delay).clamp(0.0, 1.0);
                
                return Positioned(
                  left: 20 + (i * 30.0) + (math.sin(animationValue * math.pi * 2) * 10),
                  top: 30 + (math.cos(animationValue * math.pi * 2) * 15),
                  child: Opacity(
                    opacity: (0.1 + animationValue * 0.2).clamp(0.0, 0.3),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// Page indicators for the carousel
class CarouselIndicators extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double spacing;

  const CarouselIndicators({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.grey,
    this.dotSize = 8,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: currentIndex == index ? dotSize * 1.5 : dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: currentIndex == index ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(dotSize / 2),
          ),
        ),
      ),
    );
  }
}