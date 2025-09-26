import 'dart:math';
import 'package:flutter/material.dart';

class GlowingButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color glowColor;
  final double glowRadius;
  final Duration glowDuration;
  final bool enableGlow;
  final double borderRadius;
  final EdgeInsets padding;

  const GlowingButton({
    super.key,
    required this.child,
    this.onPressed,
    this.glowColor = Colors.blue,
    this.glowRadius = 20,
    this.glowDuration = const Duration(milliseconds: 1500),
    this.enableGlow = true,
    this.borderRadius = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  State<GlowingButton> createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.glowDuration,
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.enableGlow) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: widget.enableGlow
                ? [
                    BoxShadow(
                      color: widget.glowColor.withValues(
                        alpha: _glowAnimation.value * 0.6,
                      ),
                      blurRadius: widget.glowRadius * _glowAnimation.value,
                      spreadRadius: 2 * _glowAnimation.value,
                    ),
                  ]
                : null,
          ),
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.glowColor,
              foregroundColor: Colors.white,
              padding: widget.padding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              elevation: 0,
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

class PulseEffect extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool repeat;
  final Curve curve;

  const PulseEffect({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.repeat = true,
    this.curve = Curves.easeInOut,
  });

  @override
  State<PulseEffect> createState() => _PulseEffectState();
}

class _PulseEffectState extends State<PulseEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.repeat) {
      _controller.repeat(reverse: true);
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}

class GlowingCard extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double glowRadius;
  final Duration glowDuration;
  final bool enableGlow;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color? backgroundColor;

  const GlowingCard({
    super.key,
    required this.child,
    this.glowColor = Colors.blue,
    this.glowRadius = 15,
    this.glowDuration = const Duration(milliseconds: 2000),
    this.enableGlow = true,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(8),
    this.backgroundColor,
  });

  @override
  State<GlowingCard> createState() => _GlowingCardState();
}

class _GlowingCardState extends State<GlowingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.glowDuration,
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.2,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.enableGlow) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: widget.enableGlow
                ? [
                    BoxShadow(
                      color: widget.glowColor.withValues(
                        alpha: _glowAnimation.value * 0.5,
                      ),
                      blurRadius: widget.glowRadius * _glowAnimation.value,
                      spreadRadius: 1 * _glowAnimation.value,
                    ),
                  ]
                : null,
          ),
          child: Card(
            elevation: 0,
            color: widget.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Padding(
              padding: widget.padding,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration period;
  final ShimmerDirection direction;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFEBEBF4),
    this.highlightColor = const Color(0xFFF4F4F4),
    this.period = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.ltr,
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.period,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: _getGradientBegin(),
              end: _getGradientEnd(),
              transform: GradientRotation(_controller.value * 2 * pi),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }

  AlignmentGeometry _getGradientBegin() {
    switch (widget.direction) {
      case ShimmerDirection.ltr:
        return Alignment.centerLeft;
      case ShimmerDirection.rtl:
        return Alignment.centerRight;
      case ShimmerDirection.ttb:
        return Alignment.topCenter;
      case ShimmerDirection.btt:
        return Alignment.bottomCenter;
    }
  }

  AlignmentGeometry _getGradientEnd() {
    switch (widget.direction) {
      case ShimmerDirection.ltr:
        return Alignment.centerRight;
      case ShimmerDirection.rtl:
        return Alignment.centerLeft;
      case ShimmerDirection.ttb:
        return Alignment.bottomCenter;
      case ShimmerDirection.btt:
        return Alignment.topCenter;
    }
  }
}

enum ShimmerDirection { ltr, rtl, ttb, btt }

class RippleEffect extends StatefulWidget {
  final Widget child;
  final Color rippleColor;
  final Duration duration;
  final double maxRadius;
  final VoidCallback? onTap;

  const RippleEffect({
    super.key,
    required this.child,
    this.rippleColor = Colors.blue,
    this.duration = const Duration(milliseconds: 600),
    this.maxRadius = 100,
    this.onTap,
  });

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _radiusAnimation;
  late Animation<double> _opacityAnimation;

  Offset? _tapPosition;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _radiusAnimation = Tween<double>(
      begin: 0,
      end: widget.maxRadius,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.6,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimating = false;
          _tapPosition = null;
        });
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startRipple(Offset position) {
    setState(() {
      _tapPosition = position;
      _isAnimating = true;
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _startRipple(details.localPosition);
        widget.onTap?.call();
      },
      child: Stack(
        children: [
          widget.child,
          if (_isAnimating && _tapPosition != null)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Positioned.fill(
                  child: CustomPaint(
                    painter: RipplePainter(
                      center: _tapPosition!,
                      radius: _radiusAnimation.value,
                      color: widget.rippleColor.withValues(
                        alpha: _opacityAnimation.value,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final Offset center;
  final double radius;
  final Color color;

  RipplePainter({
    required this.center,
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FloatingParticles extends StatefulWidget {
  final int particleCount;
  final Color particleColor;
  final double minSize;
  final double maxSize;
  final Duration animationDuration;
  final double height;
  final double width;

  const FloatingParticles({
    super.key,
    this.particleCount = 20,
    this.particleColor = Colors.white,
    this.minSize = 2,
    this.maxSize = 6,
    this.animationDuration = const Duration(seconds: 8),
    this.height = 200,
    this.width = double.infinity,
  });

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat();

    _particles = List.generate(widget.particleCount, (index) {
      return Particle(
        x: Random().nextDouble(),
        y: Random().nextDouble(),
        size: widget.minSize + Random().nextDouble() * (widget.maxSize - widget.minSize),
        speed: 0.1 + Random().nextDouble() * 0.5,
        opacity: 0.3 + Random().nextDouble() * 0.7,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: ParticlePainter(
              particles: _particles,
              animationValue: _controller.value,
              color: widget.particleColor,
            ),
            size: Size(widget.width, widget.height),
          );
        },
      ),
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });

  void update(double animationValue) {
    y -= speed * 0.01;
    x += sin(animationValue * 2 * pi + y * 10) * 0.002;
    
    if (y < -0.1) {
      y = 1.1;
      x = Random().nextDouble();
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;
  final Color color;

  ParticlePainter({
    required this.particles,
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      particle.update(animationValue);
      
      paint.color = color.withValues(alpha: particle.opacity);
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NeonBorder extends StatefulWidget {
  final Widget child;
  final Color neonColor;
  final double strokeWidth;
  final double borderRadius;
  final Duration flickerDuration;
  final bool enableFlicker;

  const NeonBorder({
    super.key,
    required this.child,
    this.neonColor = Colors.cyan,
    this.strokeWidth = 2,
    this.borderRadius = 8,
    this.flickerDuration = const Duration(milliseconds: 2000),
    this.enableFlicker = true,
  });

  @override
  State<NeonBorder> createState() => _NeonBorderState();
}

class _NeonBorderState extends State<NeonBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flickerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.flickerDuration,
      vsync: this,
    );

    _flickerAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.enableFlicker) {
      _controller.repeat(reverse: true);
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flickerAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: widget.neonColor.withValues(
                alpha: _flickerAnimation.value * 0.8,
              ),
              width: widget.strokeWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.neonColor.withValues(
                  alpha: _flickerAnimation.value * 0.5,
                ),
                blurRadius: 10 * _flickerAnimation.value,
                spreadRadius: 2 * _flickerAnimation.value,
              ),
              BoxShadow(
                color: widget.neonColor.withValues(
                  alpha: _flickerAnimation.value * 0.3,
                ),
                blurRadius: 20 * _flickerAnimation.value,
                spreadRadius: 4 * _flickerAnimation.value,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

class GlowingText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Color glowColor;
  final double glowRadius;
  final Duration glowDuration;
  final bool enableGlow;

  const GlowingText(
    this.text, {
    super.key,
    this.style,
    this.glowColor = Colors.white,
    this.glowRadius = 10,
    this.glowDuration = const Duration(milliseconds: 1500),
    this.enableGlow = true,
  });

  @override
  State<GlowingText> createState() => _GlowingTextState();
}

class _GlowingTextState extends State<GlowingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.glowDuration,
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.enableGlow) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Text(
          widget.text,
          style: (widget.style ?? const TextStyle()).copyWith(
            shadows: widget.enableGlow
                ? [
                    Shadow(
                      color: widget.glowColor.withValues(
                        alpha: _glowAnimation.value * 0.8,
                      ),
                      blurRadius: widget.glowRadius * _glowAnimation.value,
                    ),
                    Shadow(
                      color: widget.glowColor.withValues(
                        alpha: _glowAnimation.value * 0.4,
                      ),
                      blurRadius: widget.glowRadius * _glowAnimation.value * 2,
                    ),
                  ]
                : null,
          ),
        );
      },
    );
  }
}