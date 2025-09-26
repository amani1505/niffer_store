import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class AnimatedScrollView extends StatefulWidget {
  final List<Widget> children;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final double itemSpacing;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool enableParallax;
  final bool enableFadeIn;
  final bool enableSlideIn;
  final bool enableScale;
  final double parallaxFactor;

  const AnimatedScrollView({
    super.key,
    required this.children,
    this.controller,
    this.padding,
    this.itemSpacing = 8.0,
    this.animationDuration = const Duration(milliseconds: 600),
    this.animationCurve = Curves.easeOutCubic,
    this.enableParallax = true,
    this.enableFadeIn = true,
    this.enableSlideIn = true,
    this.enableScale = false,
    this.parallaxFactor = 0.3,
  });

  @override
  State<AnimatedScrollView> createState() => _AnimatedScrollViewState();
}

class _AnimatedScrollViewState extends State<AnimatedScrollView>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.children.length,
      (index) => AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      ),
    );

    _fadeAnimations = _controllers
        .map((controller) => Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: controller,
              curve: widget.animationCurve,
            )))
        .toList();

    _slideAnimations = _controllers
        .map((controller) => Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: controller,
              curve: widget.animationCurve,
            )))
        .toList();

    _scaleAnimations = _controllers
        .map((controller) => Tween<double>(
              begin: 0.8,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: controller,
              curve: widget.animationCurve,
            )))
        .toList();
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(
        Duration(milliseconds: i * 100),
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
    for (var controller in _controllers) {
      controller.dispose();
    }
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      padding: widget.padding,
      itemCount: widget.children.length,
      separatorBuilder: (context, index) => SizedBox(height: widget.itemSpacing),
      itemBuilder: (context, index) {
        return AnimatedScrollItem(
          controller: _scrollController,
          index: index,
          enableParallax: widget.enableParallax,
          parallaxFactor: widget.parallaxFactor,
          child: _buildAnimatedChild(index),
        );
      },
    );
  }

  Widget _buildAnimatedChild(int index) {
    Widget child = widget.children[index];

    if (widget.enableScale) {
      child = ScaleTransition(
        scale: _scaleAnimations[index],
        child: child,
      );
    }

    if (widget.enableSlideIn) {
      child = SlideTransition(
        position: _slideAnimations[index],
        child: child,
      );
    }

    if (widget.enableFadeIn) {
      child = FadeTransition(
        opacity: _fadeAnimations[index],
        child: child,
      );
    }

    return child;
  }
}

class AnimatedScrollItem extends StatefulWidget {
  final ScrollController controller;
  final int index;
  final Widget child;
  final bool enableParallax;
  final double parallaxFactor;

  const AnimatedScrollItem({
    super.key,
    required this.controller,
    required this.index,
    required this.child,
    this.enableParallax = true,
    this.parallaxFactor = 0.3,
  });

  @override
  State<AnimatedScrollItem> createState() => _AnimatedScrollItemState();
}

class _AnimatedScrollItemState extends State<AnimatedScrollItem> {
  double _parallaxOffset = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.enableParallax) {
      widget.controller.addListener(_updateParallax);
    }
  }

  @override
  void dispose() {
    if (widget.enableParallax) {
      widget.controller.removeListener(_updateParallax);
    }
    super.dispose();
  }

  void _updateParallax() {
    if (mounted && widget.controller.hasClients) {
      setState(() {
        _parallaxOffset = widget.controller.offset * widget.parallaxFactor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enableParallax) {
      return Transform.translate(
        offset: Offset(0, _parallaxOffset * (widget.index % 2 == 0 ? 1 : -1)),
        child: widget.child,
      );
    }
    return widget.child;
  }
}

class ScrollAnimationTrigger extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double triggerOffset;
  final ScrollAnimationType animationType;

  const ScrollAnimationTrigger({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOut,
    this.triggerOffset = 100.0,
    this.animationType = ScrollAnimationType.fadeSlide,
  });

  @override
  State<ScrollAnimationTrigger> createState() => _ScrollAnimationTriggerState();
}

class _ScrollAnimationTriggerState extends State<ScrollAnimationTrigger>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkVisibility(ScrollController controller) {
    if (!controller.hasClients) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    final isNowVisible = position.dy < screenHeight - widget.triggerOffset;

    if (isNowVisible && !_isVisible) {
      setState(() => _isVisible = true);
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics is ScrollController) {
          _checkVisibility(notification.metrics as ScrollController);
        }
        return false;
      },
      child: _buildAnimatedChild(),
    );
  }

  Widget _buildAnimatedChild() {
    switch (widget.animationType) {
      case ScrollAnimationType.fade:
        return FadeTransition(
          opacity: _fadeAnimation,
          child: widget.child,
        );
      case ScrollAnimationType.slide:
        return SlideTransition(
          position: _slideAnimation,
          child: widget.child,
        );
      case ScrollAnimationType.scale:
        return ScaleTransition(
          scale: _scaleAnimation,
          child: widget.child,
        );
      case ScrollAnimationType.fadeSlide:
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: widget.child,
          ),
        );
      case ScrollAnimationType.fadeScale:
        return ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: widget.child,
          ),
        );
    }
  }
}

enum ScrollAnimationType {
  fade,
  slide,
  scale,
  fadeSlide,
  fadeScale,
}

class ParallaxBackground extends StatefulWidget {
  final Widget child;
  final String? backgroundImage;
  final double parallaxFactor;
  final Color? overlayColor;
  final double overlayOpacity;

  const ParallaxBackground({
    super.key,
    required this.child,
    this.backgroundImage,
    this.parallaxFactor = 0.5,
    this.overlayColor,
    this.overlayOpacity = 0.3,
  });

  @override
  State<ParallaxBackground> createState() => _ParallaxBackgroundState();
}

class _ParallaxBackgroundState extends State<ParallaxBackground> {
  double _scrollOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          setState(() {
            _scrollOffset = notification.metrics.pixels;
          });
        }
        return false;
      },
      child: Stack(
        children: [
          // Parallax background
          if (widget.backgroundImage != null)
            Positioned.fill(
              child: Transform.translate(
                offset: Offset(0, _scrollOffset * widget.parallaxFactor),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget.backgroundImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    color: (widget.overlayColor ?? Colors.black)
                        .withValues(alpha: widget.overlayOpacity),
                  ),
                ),
              ),
            ),
          // Content
          widget.child,
        ],
      ),
    );
  }
}

class StaggeredAnimationList extends StatefulWidget {
  final List<Widget> children;
  final Duration itemDelay;
  final Duration itemDuration;
  final Curve curve;
  final bool reverse;

  const StaggeredAnimationList({
    super.key,
    required this.children,
    this.itemDelay = const Duration(milliseconds: 100),
    this.itemDuration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutCubic,
    this.reverse = false,
  });

  @override
  State<StaggeredAnimationList> createState() => _StaggeredAnimationListState();
}

class _StaggeredAnimationListState extends State<StaggeredAnimationList>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _controllers = List.generate(
      widget.children.length,
      (index) => AnimationController(
        duration: widget.itemDuration,
        vsync: this,
      ),
    );

    _animations = _controllers
        .map((controller) => CurvedAnimation(
              parent: controller,
              curve: widget.curve,
            ))
        .toList();
  }

  void _startAnimations() {
    final indices = widget.reverse
        ? List.generate(widget.children.length, (i) => widget.children.length - 1 - i)
        : List.generate(widget.children.length, (i) => i);

    for (int i = 0; i < indices.length; i++) {
      final index = indices[i];
      Future.delayed(
        widget.itemDelay * i,
        () {
          if (mounted) {
            _controllers[index].forward();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(_animations[index]),
          child: FadeTransition(
            opacity: _animations[index],
            child: child,
          ),
        );
      }).toList(),
    );
  }
}

class BouncyScrollPhysics extends ScrollPhysics {
  final double bounciness;

  const BouncyScrollPhysics({
    super.parent,
    this.bounciness = 0.8,
  });

  @override
  BouncyScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return BouncyScrollPhysics(
      parent: buildParent(ancestor),
      bounciness: bounciness,
    );
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      return value - position.pixels;
    }
    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      return value - position.pixels;
    }
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      return value - position.minScrollExtent;
    }
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) {
      return value - position.maxScrollExtent;
    }
    return 0.0;
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    if (position.outOfRange) {
      double end;
      if (position.pixels > position.maxScrollExtent) {
        end = position.maxScrollExtent;
      } else {
        end = position.minScrollExtent;
      }
      return SpringSimulation(
        const SpringDescription(
          mass: 1,
          stiffness: 100,
          damping: 10,
        ),
        position.pixels,
        end,
        velocity,
      );
    }
    return super.createBallisticSimulation(position, velocity);
  }
}