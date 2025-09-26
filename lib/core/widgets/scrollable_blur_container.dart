import 'dart:ui';
import 'package:flutter/material.dart';

class ScrollableBlurContainer extends StatefulWidget {
  final Widget child;
  final double blurRadius;
  final Color blurColor;
  final double bottomBlurHeight;
  final bool enableTopBlur;
  final bool enableBottomBlur;
  final ScrollController? controller;

  const ScrollableBlurContainer({
    super.key,
    required this.child,
    this.blurRadius = 10.0,
    this.blurColor = Colors.white,
    this.bottomBlurHeight = 80.0,
    this.enableTopBlur = false,
    this.enableBottomBlur = true,
    this.controller,
  });

  @override
  State<ScrollableBlurContainer> createState() => _ScrollableBlurContainerState();
}

class _ScrollableBlurContainerState extends State<ScrollableBlurContainer>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _topBlurAnimationController;
  late AnimationController _bottomBlurAnimationController;
  late Animation<double> _topBlurOpacity;
  late Animation<double> _bottomBlurOpacity;

  bool _showTopBlur = false;
  bool _showBottomBlur = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    
    _topBlurAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _bottomBlurAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _topBlurOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _topBlurAnimationController,
      curve: Curves.easeInOut,
    ));

    _bottomBlurOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bottomBlurAnimationController,
      curve: Curves.easeInOut,
    ));

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final position = _scrollController.position;
    final showTop = widget.enableTopBlur && position.pixels > 50;
    final showBottom = widget.enableBottomBlur && 
        position.pixels < (position.maxScrollExtent - 100);

    if (showTop != _showTopBlur) {
      setState(() => _showTopBlur = showTop);
      if (showTop) {
        _topBlurAnimationController.forward();
      } else {
        _topBlurAnimationController.reverse();
      }
    }

    if (showBottom != _showBottomBlur) {
      setState(() => _showBottomBlur = showBottom);
      if (showBottom) {
        _bottomBlurAnimationController.forward();
      } else {
        _bottomBlurAnimationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _topBlurAnimationController.dispose();
    _bottomBlurAnimationController.dispose();
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        
        // Top blur gradient
        if (widget.enableTopBlur)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: widget.bottomBlurHeight,
            child: AnimatedBuilder(
              animation: _topBlurOpacity,
              builder: (context, child) {
                return Opacity(
                  opacity: _topBlurOpacity.value,
                  child: _buildBlurContainer(isTop: true),
                );
              },
            ),
          ),

        // Bottom blur gradient
        if (widget.enableBottomBlur)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: widget.bottomBlurHeight,
            child: AnimatedBuilder(
              animation: _bottomBlurOpacity,
              builder: (context, child) {
                return Opacity(
                  opacity: _bottomBlurOpacity.value,
                  child: _buildBlurContainer(isTop: false),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBlurContainer({required bool isTop}) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: widget.blurRadius,
          sigmaY: widget.blurRadius,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: isTop ? Alignment.topCenter : Alignment.bottomCenter,
              end: isTop ? Alignment.bottomCenter : Alignment.topCenter,
              colors: [
                widget.blurColor.withValues(alpha: 0.8),
                widget.blurColor.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}