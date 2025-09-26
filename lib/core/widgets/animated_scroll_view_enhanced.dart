import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedScrollViewEnhanced extends StatefulWidget {
  final List<Widget> children;
  final ScrollController? controller;
  final EdgeInsets? padding;
  final bool reverse;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final double itemAnimationDelay;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool enablePullToRefresh;
  final Future<void> Function()? onRefresh;
  final bool enableInfiniteScroll;
  final Future<void> Function()? onLoadMore;
  final Widget? loadingIndicator;

  const AnimatedScrollViewEnhanced({
    super.key,
    required this.children,
    this.controller,
    this.padding,
    this.reverse = false,
    this.physics,
    this.shrinkWrap = false,
    this.itemAnimationDelay = 0.1,
    this.animationDuration = const Duration(milliseconds: 600),
    this.animationCurve = Curves.easeOutQuart,
    this.enablePullToRefresh = false,
    this.onRefresh,
    this.enableInfiniteScroll = false,
    this.onLoadMore,
    this.loadingIndicator,
  });

  @override
  State<AnimatedScrollViewEnhanced> createState() => _AnimatedScrollViewEnhancedState();
}

class _AnimatedScrollViewEnhancedState extends State<AnimatedScrollViewEnhanced>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _staggerAnimationController;
  final List<AnimationController> _itemControllers = [];
  final List<Animation<double>> _itemAnimations = [];
  bool _isLoadingMore = false;
  final bool _hasScrolledToEnd = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    
    _staggerAnimationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _initializeItemAnimations();
    _startStaggeredAnimations();

    if (widget.enableInfiniteScroll) {
      _scrollController.addListener(_onScroll);
    }
  }

  void _initializeItemAnimations() {
    for (int i = 0; i < widget.children.length; i++) {
      final controller = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );
      
      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: widget.animationCurve,
      ));

      _itemControllers.add(controller);
      _itemAnimations.add(animation);
    }
  }

  void _startStaggeredAnimations() {
    for (int i = 0; i < _itemControllers.length; i++) {
      Future.delayed(
        Duration(milliseconds: (i * widget.itemAnimationDelay * 1000).round()),
        () {
          if (mounted) {
            _itemControllers[i].forward();
          }
        },
      );
    }
  }

  void _onScroll() {
    if (!_isLoadingMore && widget.onLoadMore != null) {
      final position = _scrollController.position;
      final threshold = position.maxScrollExtent - 200; // Load more when 200px from bottom
      
      if (position.pixels >= threshold && !_hasScrolledToEnd) {
        _loadMore();
      }
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    
    setState(() => _isLoadingMore = true);
    HapticFeedback.lightImpact();
    
    try {
      await widget.onLoadMore?.call();
    } finally {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  @override
  void dispose() {
    _staggerAnimationController.dispose();
    for (final controller in _itemControllers) {
      controller.dispose();
    }
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget scrollView = CustomScrollView(
      controller: _scrollController,
      reverse: widget.reverse,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics ?? const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverPadding(
          padding: widget.padding ?? EdgeInsets.zero,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < widget.children.length) {
                  return _buildAnimatedItem(index);
                }
                return null;
              },
              childCount: widget.children.length,
            ),
          ),
        ),
        
        // Infinite scroll loading indicator
        if (widget.enableInfiniteScroll)
          SliverToBoxAdapter(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isLoadingMore ? 80 : 0,
              child: _isLoadingMore
                  ? widget.loadingIndicator ?? _buildDefaultLoadingIndicator()
                  : const SizedBox.shrink(),
            ),
          ),
      ],
    );

    // Add pull-to-refresh if enabled
    if (widget.enablePullToRefresh && widget.onRefresh != null) {
      scrollView = RefreshIndicator(
        onRefresh: widget.onRefresh!,
        displacement: 40,
        strokeWidth: 3,
        backgroundColor: Theme.of(context).cardColor,
        color: Theme.of(context).primaryColor,
        child: scrollView,
      );
    }

    return scrollView;
  }

  Widget _buildAnimatedItem(int index) {
    return AnimatedBuilder(
      animation: _itemAnimations[index],
      builder: (context, child) {
        final animationValue = _itemAnimations[index].value;
        
        return Transform.translate(
          offset: Offset(0, 50 * (1 - animationValue)),
          child: Opacity(
            opacity: animationValue,
            child: Transform.scale(
              scale: 0.95 + (0.05 * animationValue),
              child: widget.children[index],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefaultLoadingIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Loading more...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SliverAnimatedList extends StatefulWidget {
  final List<Widget> children;
  final double itemAnimationDelay;
  final Duration animationDuration;
  final Curve animationCurve;

  const SliverAnimatedList({
    super.key,
    required this.children,
    this.itemAnimationDelay = 0.1,
    this.animationDuration = const Duration(milliseconds: 600),
    this.animationCurve = Curves.easeOutQuart,
  });

  @override
  State<SliverAnimatedList> createState() => _SliverAnimatedListState();
}

class _SliverAnimatedListState extends State<SliverAnimatedList>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startStaggeredAnimations();
  }

  void _initializeAnimations() {
    for (int i = 0; i < widget.children.length; i++) {
      final controller = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );
      
      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: widget.animationCurve,
      ));

      _controllers.add(controller);
      _animations.add(animation);
    }
  }

  void _startStaggeredAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(
        Duration(milliseconds: (i * widget.itemAnimationDelay * 1000).round()),
        () {
          if (mounted) {
            _controllers[i].forward();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              final animationValue = _animations[index].value;
              
              return Transform.translate(
                offset: Offset(0, 30 * (1 - animationValue)),
                child: Opacity(
                  opacity: animationValue,
                  child: widget.children[index],
                ),
              );
            },
          );
        },
        childCount: widget.children.length,
      ),
    );
  }
}