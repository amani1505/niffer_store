import 'package:flutter/material.dart';
import 'package:niffer_store/core/widgets/skeleton_shimmer.dart';

class InfiniteScrollPagination<T> extends StatefulWidget {
  final Future<List<T>> Function(int page) onLoadMore;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context)? separatorBuilder;
  final Widget? firstPageProgressIndicator;
  final Widget? newPageProgressIndicator;
  final Widget? firstPageErrorIndicator;
  final Widget? newPageErrorIndicator;
  final Widget? noItemsFoundIndicator;
  final Widget? noMoreItemsIndicator;
  final int firstPageKey;
  final int pageSize;
  final bool enablePullToRefresh;
  final ScrollController? scrollController;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final bool addSemanticIndexes;

  const InfiniteScrollPagination({
    super.key,
    required this.onLoadMore,
    required this.itemBuilder,
    this.separatorBuilder,
    this.firstPageProgressIndicator,
    this.newPageProgressIndicator,
    this.firstPageErrorIndicator,
    this.newPageErrorIndicator,
    this.noItemsFoundIndicator,
    this.noMoreItemsIndicator,
    this.firstPageKey = 1,
    this.pageSize = 20,
    this.enablePullToRefresh = true,
    this.scrollController,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.addSemanticIndexes = true,
  });

  @override
  State<InfiniteScrollPagination<T>> createState() => _InfiniteScrollPaginationState<T>();
}

class _InfiniteScrollPaginationState<T> extends State<InfiniteScrollPagination<T>> {
  final List<T> _items = [];
  late ScrollController _scrollController;
  
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasError = false;
  bool _hasReachedMax = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.firstPageKey;
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadFirstPage();
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    } else {
      _scrollController.removeListener(_scrollListener);
    }
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadFirstPage() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final newItems = await widget.onLoadMore(_currentPage);
      setState(() {
        _items.clear();
        _items.addAll(newItems);
        _hasReachedMax = newItems.length < widget.pageSize;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || _hasReachedMax || _hasError) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newItems = await widget.onLoadMore(_currentPage + 1);
      setState(() {
        _items.addAll(newItems);
        _currentPage++;
        _hasReachedMax = newItems.length < widget.pageSize;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _refresh() async {
    _currentPage = widget.firstPageKey;
    _hasReachedMax = false;
    _hasError = false;
    await _loadFirstPage();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _items.isEmpty) {
      return widget.firstPageProgressIndicator ?? _buildFirstPageLoading();
    }

    if (_hasError && _items.isEmpty) {
      return widget.firstPageErrorIndicator ?? _buildFirstPageError();
    }

    if (_items.isEmpty) {
      return widget.noItemsFoundIndicator ?? _buildNoItemsFound();
    }

    Widget listView = ListView.separated(
      controller: _scrollController,
      padding: widget.padding,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      addSemanticIndexes: widget.addSemanticIndexes,
      itemCount: _items.length + (_isLoading ? 1 : 0) + (_hasReachedMax ? 1 : 0) + (_hasError ? 1 : 0),
      separatorBuilder: (context, index) {
        if (widget.separatorBuilder != null && index < _items.length) {
          return widget.separatorBuilder!(context);
        }
        return const SizedBox.shrink();
      },
      itemBuilder: (context, index) {
        if (index < _items.length) {
          return widget.itemBuilder(context, _items[index], index);
        }

        if (_isLoading) {
          return widget.newPageProgressIndicator ?? _buildNewPageLoading();
        }

        if (_hasError) {
          return widget.newPageErrorIndicator ?? _buildNewPageError();
        }

        if (_hasReachedMax) {
          return widget.noMoreItemsIndicator ?? _buildNoMoreItems();
        }

        return const SizedBox.shrink();
      },
    );

    if (widget.enablePullToRefresh) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: listView,
      );
    }

    return listView;
  }

  Widget _buildFirstPageLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLoadingAnimation(),
          const SizedBox(height: 16),
          Text(
            'Loading amazing products...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewPageLoading() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLoadingAnimation(size: 20),
          const SizedBox(width: 12),
          const Text(
            'Loading more...',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingAnimation({double size = 30}) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildFirstPageError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Please try again',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadFirstPage,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewPageError() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Failed to load more items',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _loadMore,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoItemsFound() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMoreItems() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'You\'ve reached the end!',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No more items to load',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class AlibabaStylePagination<T> extends StatefulWidget {
  final Future<PaginationResult<T>> Function(int page) onLoadMore;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final int pageSize;
  final bool enablePullToRefresh;
  final ScrollController? scrollController;
  final EdgeInsets? padding;
  final SliverGridDelegate? gridDelegate;
  final bool isGrid;

  const AlibabaStylePagination({
    super.key,
    required this.onLoadMore,
    required this.itemBuilder,
    this.pageSize = 20,
    this.enablePullToRefresh = true,
    this.scrollController,
    this.padding,
    this.gridDelegate,
    this.isGrid = false,
  });

  @override
  State<AlibabaStylePagination<T>> createState() => _AlibabaStylePaginationState<T>();
}

class _AlibabaStylePaginationState<T> extends State<AlibabaStylePagination<T>>
    with TickerProviderStateMixin {
  final List<T> _items = [];
  late ScrollController _scrollController;
  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;

  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasError = false;
  bool _hasReachedMax = false;
  int _totalItems = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_scrollListener);
    
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));
    
    _loadFirstPage();
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    } else {
      _scrollController.removeListener(_scrollListener);
    }
    _loadingController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent - 100) {
      _loadMore();
    }
  }

  Future<void> _loadFirstPage() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    _loadingController.repeat();

    try {
      final result = await widget.onLoadMore(1);
      setState(() {
        _items.clear();
        _items.addAll(result.items);
        _totalItems = result.totalItems;
        _hasReachedMax = _items.length >= _totalItems;
        _isLoading = false;
        _currentPage = 1;
      });
      _loadingController.stop();
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      _loadingController.stop();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || _hasReachedMax || _hasError) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await widget.onLoadMore(_currentPage + 1);
      setState(() {
        _items.addAll(result.items);
        _currentPage++;
        _hasReachedMax = _items.length >= result.totalItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _items.isEmpty) {
      return _buildSkeletonLoading();
    }

    if (_hasError && _items.isEmpty) {
      return _buildErrorState();
    }

    if (_items.isEmpty) {
      return _buildEmptyState();
    }

    Widget content;
    
    if (widget.isGrid) {
      content = GridView.builder(
        controller: _scrollController,
        padding: widget.padding,
        gridDelegate: widget.gridDelegate ?? const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _items.length + (_isLoading ? 2 : 0) + (_hasReachedMax ? 1 : 0),
        itemBuilder: _buildGridItem,
      );
    } else {
      content = ListView.builder(
        controller: _scrollController,
        padding: widget.padding,
        itemCount: _items.length + (_isLoading ? 1 : 0) + (_hasReachedMax ? 1 : 0),
        itemBuilder: _buildListItem,
      );
    }

    if (widget.enablePullToRefresh) {
      return RefreshIndicator(
        onRefresh: _loadFirstPage,
        child: content,
      );
    }

    return content;
  }

  Widget _buildListItem(BuildContext context, int index) {
    if (index < _items.length) {
      return widget.itemBuilder(context, _items[index], index);
    }

    if (_isLoading) {
      return _buildLoadingIndicator();
    }

    if (_hasReachedMax) {
      return _buildEndIndicator();
    }

    return const SizedBox.shrink();
  }

  Widget _buildGridItem(BuildContext context, int index) {
    if (index < _items.length) {
      return widget.itemBuilder(context, _items[index], index);
    }

    if (_isLoading && index >= _items.length && index < _items.length + 2) {
      return const SkeletonProductCard();
    }

    if (_hasReachedMax && index == _items.length) {
      return _buildGridEndIndicator();
    }

    return const SizedBox.shrink();
  }

  Widget _buildSkeletonLoading() {
    if (widget.isGrid) {
      return SkeletonGrid(
        itemBuilder: (index) => const SkeletonProductCard(),
      );
    } else {
      return SkeletonList(
        itemBuilder: (index) => const SkeletonProductCard(isGridView: false),
      );
    }
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _loadingAnimation,
            builder: (context, child) {
              return Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      Colors.transparent,
                      Theme.of(context).primaryColor,
                    ],
                    stops: const [0.0, 1.0],
                    transform: GradientRotation(_loadingAnimation.value * 2 * 3.14159),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          const Text(
            'Loading more awesome products...',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildEndIndicator() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Icon(
            Icons.check_circle_outline,
            size: 32,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ve seen all $_totalItems products!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Thanks for browsing',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridEndIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 24,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'All done!',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Connection error',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your internet connection',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadFirstPage,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No products found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different search terms',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class PaginationResult<T> {
  final List<T> items;
  final int totalItems;
  final int currentPage;
  final bool hasNextPage;

  const PaginationResult({
    required this.items,
    required this.totalItems,
    required this.currentPage,
    required this.hasNextPage,
  });
}