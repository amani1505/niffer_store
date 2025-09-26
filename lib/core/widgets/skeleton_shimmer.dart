import 'package:flutter/material.dart';

class SkeletonShimmer extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;
  final ShimmerDirection direction;

  const SkeletonShimmer({
    super.key,
    required this.child,
    this.isLoading = true,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.ltr,
  });

  @override
  State<SkeletonShimmer> createState() => _SkeletonShimmerState();
}

class _SkeletonShimmerState extends State<SkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.period,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(SkeletonShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = widget.baseColor ?? 
        (isDark ? Colors.grey[700]! : Colors.grey[300]!);
    final highlightColor = widget.highlightColor ?? 
        (isDark ? Colors.grey[500]! : Colors.grey[100]!);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
              begin: _getBegin(),
              end: _getEnd(),
              transform: GradientRotation(_animation.value * 0.5),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }

  Alignment _getBegin() {
    switch (widget.direction) {
      case ShimmerDirection.ltr:
        return Alignment(-1.0 + _animation.value, 0.0);
      case ShimmerDirection.rtl:
        return Alignment(1.0 - _animation.value, 0.0);
      case ShimmerDirection.ttb:
        return Alignment(0.0, -1.0 + _animation.value);
      case ShimmerDirection.btt:
        return Alignment(0.0, 1.0 - _animation.value);
    }
  }

  Alignment _getEnd() {
    switch (widget.direction) {
      case ShimmerDirection.ltr:
        return Alignment(-0.5 + _animation.value, 0.0);
      case ShimmerDirection.rtl:
        return Alignment(0.5 - _animation.value, 0.0);
      case ShimmerDirection.ttb:
        return Alignment(0.0, -0.5 + _animation.value);
      case ShimmerDirection.btt:
        return Alignment(0.0, 0.5 - _animation.value);
    }
  }
}

enum ShimmerDirection { ltr, rtl, ttb, btt }

class SkeletonContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool isLoading;

  const SkeletonContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      isLoading: isLoading,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: borderRadius ?? BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class SkeletonText extends StatelessWidget {
  final double? width;
  final double height;
  final bool isLoading;

  const SkeletonText({
    super.key,
    this.width,
    this.height = 16,
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(height / 2),
      isLoading: isLoading,
    );
  }
}

class SkeletonAvatar extends StatelessWidget {
  final double size;
  final bool isLoading;

  const SkeletonAvatar({
    super.key,
    this.size = 40,
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
      isLoading: isLoading,
    );
  }
}

class SkeletonProductCard extends StatelessWidget {
  final bool isLoading;
  final bool isGridView;

  const SkeletonProductCard({
    super.key,
    this.isLoading = true,
    this.isGridView = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isGridView) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              SkeletonContainer(
                width: double.infinity,
                height: 120,
                borderRadius: BorderRadius.circular(8),
                isLoading: isLoading,
              ),
              const SizedBox(height: 12),
              // Product Title
              SkeletonText(
                width: double.infinity,
                height: 16,
                isLoading: isLoading,
              ),
              const SizedBox(height: 8),
              // Product Price
              SkeletonText(
                width: 80,
                height: 14,
                isLoading: isLoading,
              ),
              const SizedBox(height: 8),
              // Rating
              Row(
                children: [
                  SkeletonText(
                    width: 60,
                    height: 12,
                    isLoading: isLoading,
                  ),
                  const Spacer(),
                  SkeletonText(
                    width: 40,
                    height: 12,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Product Image
              SkeletonContainer(
                width: 80,
                height: 80,
                borderRadius: BorderRadius.circular(8),
                isLoading: isLoading,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title
                    SkeletonText(
                      width: double.infinity,
                      height: 16,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 8),
                    // Product Description
                    SkeletonText(
                      width: double.infinity * 0.7,
                      height: 12,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 8),
                    // Product Price
                    SkeletonText(
                      width: 80,
                      height: 14,
                      isLoading: isLoading,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class SkeletonListTile extends StatelessWidget {
  final bool isLoading;
  final bool hasLeading;
  final bool hasTrailing;
  final bool hasSubtitle;

  const SkeletonListTile({
    super.key,
    this.isLoading = true,
    this.hasLeading = true,
    this.hasTrailing = true,
    this.hasSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: hasLeading
          ? SkeletonAvatar(isLoading: isLoading)
          : null,
      title: SkeletonText(
        width: double.infinity,
        height: 16,
        isLoading: isLoading,
      ),
      subtitle: hasSubtitle
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                SkeletonText(
                  width: double.infinity * 0.7,
                  height: 12,
                  isLoading: isLoading,
                ),
              ],
            )
          : null,
      trailing: hasTrailing
          ? SkeletonText(
              width: 60,
              height: 12,
              isLoading: isLoading,
            )
          : null,
    );
  }
}

class SkeletonCard extends StatelessWidget {
  final bool isLoading;
  final double? height;
  final EdgeInsets? padding;

  const SkeletonCard({
    super.key,
    this.isLoading = true,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: height,
        padding: padding ?? const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                SkeletonText(
                  width: 120,
                  height: 20,
                  isLoading: isLoading,
                ),
                const Spacer(),
                SkeletonContainer(
                  width: 24,
                  height: 24,
                  borderRadius: BorderRadius.circular(4),
                  isLoading: isLoading,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Content lines
            SkeletonText(
              width: double.infinity,
              height: 14,
              isLoading: isLoading,
            ),
            const SizedBox(height: 8),
            SkeletonText(
              width: double.infinity * 0.8,
              height: 14,
              isLoading: isLoading,
            ),
            const SizedBox(height: 8),
            SkeletonText(
              width: double.infinity * 0.6,
              height: 14,
              isLoading: isLoading,
            ),
            if (height != null) const Spacer(),
            const SizedBox(height: 16),
            // Footer
            Row(
              children: [
                SkeletonText(
                  width: 80,
                  height: 12,
                  isLoading: isLoading,
                ),
                const Spacer(),
                SkeletonText(
                  width: 60,
                  height: 12,
                  isLoading: isLoading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SkeletonOrderCard extends StatelessWidget {
  final bool isLoading;

  const SkeletonOrderCard({
    super.key,
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header
            Row(
              children: [
                SkeletonText(
                  width: 80,
                  height: 16,
                  isLoading: isLoading,
                ),
                const Spacer(),
                SkeletonContainer(
                  width: 60,
                  height: 20,
                  borderRadius: BorderRadius.circular(10),
                  isLoading: isLoading,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Customer info
            Row(
              children: [
                SkeletonAvatar(size: 32, isLoading: isLoading),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonText(
                      width: 100,
                      height: 14,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 4),
                    SkeletonText(
                      width: 80,
                      height: 12,
                      isLoading: isLoading,
                    ),
                  ],
                ),
                const Spacer(),
                SkeletonText(
                  width: 60,
                  height: 14,
                  isLoading: isLoading,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            // Product items
            ...List.generate(2, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SkeletonContainer(
                    width: 40,
                    height: 40,
                    borderRadius: BorderRadius.circular(8),
                    isLoading: isLoading,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonText(
                          width: double.infinity,
                          height: 14,
                          isLoading: isLoading,
                        ),
                        const SizedBox(height: 4),
                        SkeletonText(
                          width: 80,
                          height: 12,
                          isLoading: isLoading,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class SkeletonAnalyticsCard extends StatelessWidget {
  final bool isLoading;

  const SkeletonAnalyticsCard({
    super.key,
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SkeletonContainer(
                  width: 40,
                  height: 40,
                  borderRadius: BorderRadius.circular(8),
                  isLoading: isLoading,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonText(
                        width: double.infinity,
                        height: 24,
                        isLoading: isLoading,
                      ),
                      const SizedBox(height: 4),
                      SkeletonText(
                        width: 100,
                        height: 14,
                        isLoading: isLoading,
                      ),
                    ],
                  ),
                ),
                SkeletonContainer(
                  width: 50,
                  height: 20,
                  borderRadius: BorderRadius.circular(10),
                  isLoading: isLoading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SkeletonGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final bool isLoading;
  final Widget Function(int index) itemBuilder;

  const SkeletonGrid({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.isLoading = true,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return isLoading ? itemBuilder(index) : Container();
      },
    );
  }
}

class SkeletonList extends StatelessWidget {
  final int itemCount;
  final bool isLoading;
  final Widget Function(int index) itemBuilder;
  final EdgeInsets? padding;

  const SkeletonList({
    super.key,
    this.itemCount = 5,
    this.isLoading = true,
    required this.itemBuilder,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return isLoading ? itemBuilder(index) : Container();
      },
    );
  }
}