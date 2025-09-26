import 'package:flutter/material.dart';

class SkeletonLoader extends StatefulWidget {
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;

  const SkeletonLoader({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.margin,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: widget.height,
      width: widget.width,
      margin: widget.margin,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: isDark
                    ? [
                        Colors.grey[800]!,
                        Colors.grey[700]!,
                        Colors.grey[600]!,
                        Colors.grey[700]!,
                        Colors.grey[800]!,
                      ]
                    : [
                        Colors.grey[300]!,
                        Colors.grey[200]!,
                        Colors.grey[100]!,
                        Colors.grey[200]!,
                        Colors.grey[300]!,
                      ],
                stops: [
                  _animation.value - 0.3,
                  _animation.value - 0.15,
                  _animation.value,
                  _animation.value + 0.15,
                  _animation.value + 0.3,
                ],
                transform: GradientRotation(0.0),
              ),
            ),
          );
        },
      ),
    );
  }
}
