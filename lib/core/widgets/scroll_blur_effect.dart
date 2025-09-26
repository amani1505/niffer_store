import 'dart:ui';
import 'package:flutter/material.dart';

class ScrollBlurEffect extends StatefulWidget {
  final Widget child;
  final double blurRadius;
  final Color? overlayColor;
  final double fadeHeight;
  final bool enableTopBlur;
  final bool enableBottomBlur;
  final Gradient? topGradient;
  final Gradient? bottomGradient;

  const ScrollBlurEffect({
    super.key,
    required this.child,
    this.blurRadius = 10.0,
    this.overlayColor,
    this.fadeHeight = 60.0,
    this.enableTopBlur = true,
    this.enableBottomBlur = true,
    this.topGradient,
    this.bottomGradient,
  });

  @override
  State<ScrollBlurEffect> createState() => _ScrollBlurEffectState();
}

class _ScrollBlurEffectState extends State<ScrollBlurEffect>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _topBlurAnimation;
  late Animation<double> _bottomBlurAnimation;

  bool _isAtTop = true;
  bool _isAtBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _topBlurAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _bottomBlurAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    ));

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    final isAtTop = position.pixels <= 0;
    final isAtBottom = position.pixels >= position.maxScrollExtent - 10;

    if (isAtTop != _isAtTop || isAtBottom != _isAtBottom) {
      setState(() {
        _isAtTop = isAtTop;
        _isAtBottom = isAtBottom;
      });

      if (!isAtTop || !isAtBottom) {
        _animationController.forward();
      } else if (isAtTop && isAtBottom) {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          _onScroll();
        }
        return false;
      },
      child: Stack(
        children: [
          // Main scrollable content
          widget.child,
          
          // Top blur effect
          if (widget.enableTopBlur)
            AnimatedBuilder(
              animation: _topBlurAnimation,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: widget.fadeHeight,
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _isAtTop ? 0.0 : _topBlurAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: widget.topGradient ??
                              LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  (widget.overlayColor ?? Theme.of(context).scaffoldBackgroundColor)
                                      .withValues(alpha: 0.9),
                                  (widget.overlayColor ?? Theme.of(context).scaffoldBackgroundColor)
                                      .withValues(alpha: 0.7),
                                  (widget.overlayColor ?? Theme.of(context).scaffoldBackgroundColor)
                                      .withValues(alpha: 0.3),
                                  Colors.transparent,
                                ],
                              ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: widget.blurRadius * _topBlurAnimation.value,
                            sigmaY: widget.blurRadius * _topBlurAnimation.value,
                          ),
                          child: Container(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

          // Bottom blur effect  
          if (widget.enableBottomBlur)
            AnimatedBuilder(
              animation: _bottomBlurAnimation,
              builder: (context, child) {
                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: widget.fadeHeight,
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _isAtBottom ? 0.0 : _bottomBlurAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: widget.bottomGradient ??
                              LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  (widget.overlayColor ?? Theme.of(context).scaffoldBackgroundColor)
                                      .withValues(alpha: 0.9),
                                  (widget.overlayColor ?? Theme.of(context).scaffoldBackgroundColor)
                                      .withValues(alpha: 0.7),
                                  (widget.overlayColor ?? Theme.of(context).scaffoldBackgroundColor)
                                      .withValues(alpha: 0.3),
                                  Colors.transparent,
                                ],
                              ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: widget.blurRadius * _bottomBlurAnimation.value,
                            sigmaY: widget.blurRadius * _bottomBlurAnimation.value,
                          ),
                          child: Container(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

          // Scroll indicators with glow effect
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Stack(
                children: [
                  // Top scroll indicator
                  if (!_isAtTop)
                    Positioned(
                      top: 8,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _topBlurAnimation.value * 0.6,
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  // Bottom scroll indicator
                  if (!_isAtBottom)
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _bottomBlurAnimation.value * 0.6,
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ModernScrollView extends StatefulWidget {
  final Widget child;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final bool enableBlur;
  final Color? blurColor;
  final double blurIntensity;

  const ModernScrollView({
    super.key,
    required this.child,
    this.controller,
    this.padding,
    this.enableBlur = true,
    this.blurColor,
    this.blurIntensity = 10.0,
  });

  @override
  State<ModernScrollView> createState() => _ModernScrollViewState();
}

class _ModernScrollViewState extends State<ModernScrollView> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget scrollView = SingleChildScrollView(
      controller: _controller,
      padding: widget.padding,
      child: widget.child,
    );

    if (widget.enableBlur) {
      return ScrollBlurEffect(
        blurRadius: widget.blurIntensity,
        overlayColor: widget.blurColor,
        child: scrollView,
      );
    }

    return scrollView;
  }
}

class GlowingScrollIndicator extends StatefulWidget {
  final ScrollController controller;
  final Color? color;
  final double thickness;
  final double minHeight;
  final EdgeInsets margin;

  const GlowingScrollIndicator({
    super.key,
    required this.controller,
    this.color,
    this.thickness = 4.0,
    this.minHeight = 40.0,
    this.margin = const EdgeInsets.all(2.0),
  });

  @override
  State<GlowingScrollIndicator> createState() => _GlowingScrollIndicatorState();
}

class _GlowingScrollIndicatorState extends State<GlowingScrollIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    widget.controller.addListener(_onScroll);
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (widget.controller.hasClients) {
      _glowController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.controller, _glowAnimation]),
      builder: (context, child) {
        if (!widget.controller.hasClients) {
          return const SizedBox.shrink();
        }

        final scrollExtent = widget.controller.position.maxScrollExtent;
        final currentScroll = widget.controller.offset;
        final viewportDimension = widget.controller.position.viewportDimension;

        if (scrollExtent <= 0) {
          return const SizedBox.shrink();
        }

        final scrollRatio = (currentScroll / scrollExtent).clamp(0.0, 1.0);
        final indicatorHeight = (viewportDimension / (scrollExtent + viewportDimension) * viewportDimension)
            .clamp(widget.minHeight, viewportDimension);

        final indicatorPosition = scrollRatio * (viewportDimension - indicatorHeight);

        return Positioned(
          right: widget.margin.right,
          top: widget.margin.top + indicatorPosition,
          child: Container(
            width: widget.thickness,
            height: indicatorHeight,
            decoration: BoxDecoration(
              color: widget.color ?? Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(widget.thickness / 2),
              boxShadow: [
                BoxShadow(
                  color: (widget.color ?? Theme.of(context).primaryColor)
                      .withValues(alpha: _glowAnimation.value * 0.6),
                  blurRadius: 8 * _glowAnimation.value,
                  spreadRadius: 2 * _glowAnimation.value,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}