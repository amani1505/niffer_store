import 'dart:async';
import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';

class CarouselBanner extends StatefulWidget {
  final List<CarouselItem> items;
  final Duration autoPlayDuration;
  final Duration animationDuration;
  final bool autoPlay;
  final double height;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;

  const CarouselBanner({
    super.key,
    required this.items,
    this.autoPlayDuration = const Duration(seconds: 4),
    this.animationDuration = const Duration(milliseconds: 300),
    this.autoPlay = true,
    this.height = 200,
    this.margin,
    this.borderRadius,
  });

  @override
  State<CarouselBanner> createState() => _CarouselBannerState();
}

class _CarouselBannerState extends State<CarouselBanner> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    if (widget.autoPlay && widget.items.length > 1) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.autoPlayDuration, (timer) {
      if (mounted) {
        final nextIndex = (_currentIndex + 1) % widget.items.length;
        _pageController.animateToPage(
          nextIndex,
          duration: widget.animationDuration,
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoPlay() {
    _timer?.cancel();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _goToSlide(int index) {
    _pageController.animateToPage(
      index,
      duration: widget.animationDuration,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: widget.height,
      margin: widget.margin,
      child: Stack(
        children: [
          // Carousel
          GestureDetector(
            onTapDown: (_) => _stopAutoPlay(),
            onTapUp: (_) => widget.autoPlay ? _startAutoPlay() : null,
            onTapCancel: () => widget.autoPlay ? _startAutoPlay() : null,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return _buildCarouselItem(item);
              },
            ),
          ),

          // Indicators
          if (widget.items.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.items.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _goToSlide(entry.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _currentIndex == entry.key ? 24 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentIndex == entry.key
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // Navigation buttons (optional for larger screens)
          if (widget.items.length > 1 && MediaQuery.of(context).size.width > 600) ...[
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: _buildNavButton(
                  icon: Icons.chevron_left,
                  onTap: () {
                    final prevIndex = _currentIndex == 0 
                        ? widget.items.length - 1 
                        : _currentIndex - 1;
                    _goToSlide(prevIndex);
                  },
                ),
              ),
            ),
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: _buildNavButton(
                  icon: Icons.chevron_right,
                  onTap: () {
                    final nextIndex = (_currentIndex + 1) % widget.items.length;
                    _goToSlide(nextIndex);
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCarouselItem(CarouselItem item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
        gradient: item.gradient ??
            LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        image: item.backgroundImage != null
            ? DecorationImage(
                image: item.backgroundImage!,
                fit: BoxFit.cover,
                colorFilter: item.overlay != null
                    ? ColorFilter.mode(item.overlay!, BlendMode.overlay)
                    : null,
              )
            : null,
      ),
      child: Stack(
        children: [
          // Background decorative elements
          if (item.showDecorations) ...[
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: -40,
              bottom: -40,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.badge != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: item.badgeColor ?? Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      item.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Flexible(
                  child: Text(
                    item.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: item.titleColor ?? Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.subtitle != null) ...[
                  const SizedBox(height: 6),
                  Flexible(
                    child: Text(
                      item.subtitle!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: item.subtitleColor ?? Colors.white.withValues(alpha: 0.9),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                if (item.buttonText != null) ...[
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: item.onButtonPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: item.buttonColor ?? Colors.white,
                      foregroundColor: item.buttonTextColor ?? AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      item.buttonText!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Tap handler for the entire item
          if (item.onTap != null)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: item.onTap,
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

class CarouselItem {
  final String title;
  final String? subtitle;
  final String? badge;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final ImageProvider? backgroundImage;
  final Color? overlay;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? badgeColor;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final bool showDecorations;

  const CarouselItem({
    required this.title,
    this.subtitle,
    this.badge,
    this.buttonText,
    this.onButtonPressed,
    this.onTap,
    this.gradient,
    this.backgroundImage,
    this.overlay,
    this.titleColor,
    this.subtitleColor,
    this.badgeColor,
    this.buttonColor,
    this.buttonTextColor,
    this.showDecorations = true,
  });
}

// Predefined carousel items for different purposes
class CarouselItems {
  static List<CarouselItem> getDefaultPromoBanners() {
    return [
      CarouselItem(
        title: 'Special Offers',
        subtitle: 'Up to 50% off on selected items',
        badge: 'LIMITED TIME',
        buttonText: 'Shop Now',
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onButtonPressed: () {
          // Navigate to products
        },
      ),
      CarouselItem(
        title: 'New Arrivals',
        subtitle: 'Discover the latest trends in fashion',
        badge: 'NEW',
        buttonText: 'Explore',
        gradient: LinearGradient(
          colors: [Colors.purple[600]!, Colors.purple[800]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onButtonPressed: () {
          // Navigate to new arrivals
        },
      ),
      CarouselItem(
        title: 'Free Shipping',
        subtitle: 'On orders above TZS 50,000',
        badge: 'FREE DELIVERY',
        buttonText: 'Learn More',
        gradient: LinearGradient(
          colors: [Colors.green[600]!, Colors.green[800]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onButtonPressed: () {
          // Show shipping info
        },
      ),
    ];
  }
}