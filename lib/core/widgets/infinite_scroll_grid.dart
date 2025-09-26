import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:niffer_store/core/widgets/product_card_skeleton.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item, int index);
typedef LoadMoreCallback<T> = Future<List<T>> Function(int page);

class InfiniteScrollGrid<T> extends StatefulWidget {
  final List<T> initialItems;
  final ItemBuilder<T> itemBuilder;
  final LoadMoreCallback<T> onLoadMore;
  final int crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsets padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final Widget? loadingIndicator;
  final Widget? errorWidget;
  final Widget? emptyWidget;
  final int itemsPerPage;
  final bool enablePullToRefresh;
  final Future<void> Function()? onRefresh;
  final double loadMoreThreshold;
  final bool enableShimmerLoading;
  final int shimmerItemCount;

  const InfiniteScrollGrid({
    super.key,
    required this.initialItems,
    required this.itemBuilder,
    required this.onLoadMore,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.75,
    this.mainAxisSpacing = 16,
    this.crossAxisSpacing = 16,
    this.padding = const EdgeInsets.all(16),
    this.physics,
    this.controller,
    this.loadingIndicator,
    this.errorWidget,
    this.emptyWidget,
    this.itemsPerPage = 20,
    this.enablePullToRefresh = true,
    this.onRefresh,
    this.loadMoreThreshold = 200,
    this.enableShimmerLoading = true,
    this.shimmerItemCount = 6,
  });

  @override
  State<InfiniteScrollGrid<T>> createState() => _InfiniteScrollGridState<T>();
}

class _InfiniteScrollGridState<T> extends State<InfiniteScrollGrid<T>>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _loadingAnimationController;
  late AnimationController _itemAnimationController;
  final List<T> _items = [];
  final List<AnimationController> _itemControllers = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasReachedEnd = false;
  String? _error;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _itemAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _items.addAll(widget.initialItems);
    _scrollController.addListener(_onScroll);
    
    if (widget.enableShimmerLoading) {
      _loadingAnimationController.repeat();
    }
    
    _animateInitialItems();
  }

  void _animateInitialItems() {
    for (int i = 0; i < _items.length; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 300 + (i * 50)),
        vsync: this,
      );
      _itemControllers.add(controller);
      
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          controller.forward();
        }
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - widget.loadMoreThreshold) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading || _hasReachedEnd) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      if (!mounted) return;

      setState(() {
        _isLoading = true;
        _error = null;
      });

      HapticFeedback.lightImpact();

      try {
        final newItems = await widget.onLoadMore(_currentPage);
        
        if (mounted) {
          setState(() {
            if (newItems.isEmpty) {
              _hasReachedEnd = true;
            } else {
              _items.addAll(newItems);
              _currentPage++;
              
              // Add animation controllers for new items
              for (int i = 0; i < newItems.length; i++) {
                final controller = AnimationController(
                  duration: Duration(milliseconds: 300 + (i * 50)),
                  vsync: this,
                );
                _itemControllers.add(controller);
                
                Future.delayed(Duration(milliseconds: i * 100), () {
                  if (mounted) {
                    controller.forward();
                  }
                });
              }
            }
            _isLoading = false;
          });
        }
      } catch (error) {
        if (mounted) {
          setState(() {
            _error = error.toString();
            _isLoading = false;
          });
        }
      }
    });
  }

  Future<void> _refreshItems() async {
    if (widget.onRefresh != null) {
      await widget.onRefresh!();
    } else {
      // Reset and reload
      setState(() {
        _items.clear();
        _items.addAll(widget.initialItems);
        _currentPage = 1;
        _hasReachedEnd = false;
        _error = null;
      });
      
      // Dispose old controllers
      for (final controller in _itemControllers) {
        controller.dispose();
      }
      _itemControllers.clear();
      
      _animateInitialItems();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _loadingAnimationController.dispose();
    _itemAnimationController.dispose();
    _debounceTimer?.cancel();
    
    for (final controller in _itemControllers) {
      controller.dispose();
    }
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty && !_isLoading) {
      return widget.emptyWidget ?? _buildEmptyState();
    }

    Widget grid = CustomScrollView(
      controller: _scrollController,
      physics: widget.physics ?? const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverPadding(
          padding: widget.padding,
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              childAspectRatio: widget.childAspectRatio,
              mainAxisSpacing: widget.mainAxisSpacing,
              crossAxisSpacing: widget.crossAxisSpacing,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < _items.length) {
                  return _buildAnimatedItem(_items[index], index);
                }
                return null;
              },
              childCount: _items.length,
            ),
          ),
        ),
        
        // Loading indicator
        if (_isLoading && !_hasReachedEnd)
          SliverToBoxAdapter(
            child: widget.enableShimmerLoading
                ? _buildShimmerLoading()
                : _buildRegularLoading(),
          ),
        
        // Error widget
        if (_error != null)
          SliverToBoxAdapter(
            child: _buildErrorWidget(),
          ),
        
        // End reached indicator
        if (_hasReachedEnd && _items.isNotEmpty)
          SliverToBoxAdapter(
            child: _buildEndReachedIndicator(),
          ),
      ],
    );

    if (widget.enablePullToRefresh) {
      grid = RefreshIndicator(
        onRefresh: _refreshItems,
        displacement: 40,
        strokeWidth: 3,
        backgroundColor: Theme.of(context).cardColor,
        color: Theme.of(context).primaryColor,
        child: grid,
      );
    }

    return grid;
  }

  Widget _buildAnimatedItem(T item, int index) {
    if (index >= _itemControllers.length) {
      return widget.itemBuilder(context, item, index);
    }

    return AnimatedBuilder(
      animation: _itemControllers[index],
      builder: (context, child) {
        final animationValue = _itemControllers[index].value;
        
        return Transform.translate(
          offset: Offset(0, 50 * (1 - animationValue)),
          child: Opacity(
            opacity: animationValue,
            child: Transform.scale(
              scale: 0.8 + (0.2 * animationValue),
              child: widget.itemBuilder(context, item, index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Container(
      padding: widget.padding,
      child: ProductGridSkeleton(
        crossAxisCount: widget.crossAxisCount,
        childAspectRatio: widget.childAspectRatio,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
        itemCount: widget.shimmerItemCount,
        showStoreName: true,
        padding: EdgeInsets.zero,
      ),
    );
  }


  Widget _buildRegularLoading() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading more items...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load more items',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadMoreItems,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEndReachedIndicator() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: Colors.green[400],
          ),
          const SizedBox(height: 16),
          Text(
            'You\'ve reached the end!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No more items to load',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}