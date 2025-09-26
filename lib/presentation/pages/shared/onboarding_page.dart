import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:niffer_store/core/constants/app_strings.dart';
import 'package:niffer_store/core/services/storage_service.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> 
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentPage = 0;
  static const String _onboardingKey = 'has_seen_onboarding';

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Discover Amazing Products",
      description: "Browse through thousands of products from multiple stores, all in one place.",
      lottieAsset: "assets/animations/shopping_bags.json",
      svgAsset: "assets/vectors/shopping.svg",
      backgroundColor: const Color(0xFF6C63FF),
      gradientColors: [const Color(0xFF6C63FF), const Color(0xFF3F3D56)],
    ),
    OnboardingData(
      title: "Shop from Multiple Stores",
      description: "Find products from your favorite stores and discover new ones with great deals.",
      lottieAsset: "assets/animations/store_selection.json",
      svgAsset: "assets/vectors/stores.svg",
      backgroundColor: const Color(0xFF00BFA6),
      gradientColors: [const Color(0xFF00BFA6), const Color(0xFF00ACC1)],
    ),
    OnboardingData(
      title: "Secure & Fast Checkout",
      description: "Experience seamless and secure payment with multiple payment options.",
      lottieAsset: "assets/animations/secure_payment.json",
      svgAsset: "assets/vectors/payment.svg",
      backgroundColor: const Color(0xFFFF6B6B),
      gradientColors: [const Color(0xFFFF6B6B), const Color(0xFFFF5722)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _startAnimations();
  }

  void _startAnimations() {
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _slideController.forward();
    });
  }

  void _restartAnimations() {
    _animationController.reset();
    _slideController.reset();
    _startAnimations();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    _restartAnimations();
    HapticFeedback.lightImpact();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    await StorageService.saveBool(_onboardingKey, true);
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  void _skipOnboarding() async {
    await _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _pages[_currentPage].gradientColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.appName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_currentPage < _pages.length - 1)
            TextButton(
              onPressed: _skipOnboarding,
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildAnimation(data),
            ),
          ),
          const SizedBox(height: 60),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  data.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimation(OnboardingData data) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(140),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1200),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: _buildVectorPlaceholder(data.svgAsset),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVectorPlaceholder(String asset) {
    // Placeholder for vector graphics - you would use flutter_svg here
    IconData iconData;
    if (asset.contains('shopping')) {
      iconData = Icons.shopping_bag;
    } else if (asset.contains('stores')) {
      iconData = Icons.storefront;
    } else {
      iconData = Icons.payment;
    }

    return Icon(
      iconData,
      size: 120,
      color: Colors.white,
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          _buildPageIndicator(),
          const SizedBox(height: 40),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index 
                ? Colors.white 
                : Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentPage > 0)
          Expanded(
            child: _buildNavButton(
              text: 'Previous',
              onPressed: _previousPage,
              isPrimary: false,
            ),
          ),
        if (_currentPage > 0) const SizedBox(width: 16),
        Expanded(
          child: _buildNavButton(
            text: _currentPage == _pages.length - 1 
                ? 'Get Started' 
                : 'Next',
            onPressed: _currentPage == _pages.length - 1 
                ? _completeOnboarding 
                : _nextPage,
            isPrimary: true,
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary 
              ? Colors.white 
              : Colors.white.withValues(alpha: 0.2),
          foregroundColor: isPrimary 
              ? _pages[_currentPage].backgroundColor 
              : Colors.white,
          elevation: isPrimary ? 8 : 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isPrimary 
                ? BorderSide.none 
                : BorderSide(color: Colors.white.withValues(alpha: 0.3)),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

}

class OnboardingData {
  final String title;
  final String description;
  final String lottieAsset;
  final String svgAsset;
  final Color backgroundColor;
  final List<Color> gradientColors;

  OnboardingData({
    required this.title,
    required this.description,
    required this.lottieAsset,
    required this.svgAsset,
    required this.backgroundColor,
    required this.gradientColors,
  });
}