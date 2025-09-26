import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/presentation/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeToggle extends StatelessWidget {
  final Color? activeColor;
  final Color? inactiveColor;
  final double? iconSize;
  final bool showLabel;
  final String? lightLabel;
  final String? darkLabel;
  final bool isCompact;

  const ThemeToggle({
    super.key,
    this.activeColor,
    this.inactiveColor,
    this.iconSize,
    this.showLabel = true,
    this.lightLabel,
    this.darkLabel,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;
        final effectiveActiveColor = activeColor ?? 
            (isDark ? Colors.orange : AppColors.primary);

        if (isCompact) {
          return _buildCompactToggle(context, themeProvider, isDark, effectiveActiveColor);
        }

        return _buildFullToggle(context, themeProvider, isDark, effectiveActiveColor);
      },
    );
  }

  Widget _buildCompactToggle(BuildContext context, ThemeProvider themeProvider, bool isDark, Color effectiveActiveColor) {
    return IconButton(
      onPressed: () => themeProvider.toggleTheme(),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return RotationTransition(
            turns: animation,
            child: child,
          );
        },
        child: Icon(
          isDark ? Icons.light_mode : Icons.dark_mode,
          key: ValueKey(isDark),
          color: effectiveActiveColor,
          size: iconSize ?? 24,
        ),
      ),
      tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
    );
  }

  Widget _buildFullToggle(BuildContext context, ThemeProvider themeProvider, bool isDark, Color effectiveActiveColor) {
    return InkWell(
      onTap: () => themeProvider.toggleTheme(),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: effectiveActiveColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  key: ValueKey(isDark),
                  color: effectiveActiveColor,
                  size: iconSize ?? 20,
                ),
              ),
            ),
            if (showLabel) ...[
              const SizedBox(width: 12),
              Text(
                isDark 
                  ? (lightLabel ?? 'Light Mode')
                  : (darkLabel ?? 'Dark Mode'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AnimatedThemeToggle extends StatefulWidget {
  final Color? activeColor;
  final Color? inactiveColor;
  final double? size;

  const AnimatedThemeToggle({
    super.key,
    this.activeColor,
    this.inactiveColor,
    this.size,
  });

  @override
  State<AnimatedThemeToggle> createState() => _AnimatedThemeToggleState();
}

class _AnimatedThemeToggleState extends State<AnimatedThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleTheme(ThemeProvider themeProvider) {
    themeProvider.toggleTheme();
    if (themeProvider.isDarkMode) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;
        final effectiveActiveColor = widget.activeColor ?? 
            (isDark ? Colors.orange : AppColors.primary);
        final effectiveInactiveColor = widget.inactiveColor ?? Colors.grey[400]!;
        final effectiveSize = widget.size ?? 60.0;

        // Set initial animation state
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isDark && !_controller.isCompleted) {
            _controller.forward();
          } else if (!isDark && _controller.isCompleted) {
            _controller.reverse();
          }
        });

        return GestureDetector(
          onTap: () => _toggleTheme(themeProvider),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: effectiveSize,
                height: effectiveSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(Colors.amber[100]!, Colors.indigo[900]!, _animation.value)!,
                      Color.lerp(Colors.orange[200]!, Colors.purple[900]!, _animation.value)!,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.lerp(Colors.orange, Colors.purple, _animation.value)!
                          .withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Sun
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.elasticOut,
                      top: _animation.value * (effectiveSize - 24),
                      left: (effectiveSize - 24) / 2,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: 1 - _animation.value,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.wb_sunny,
                            color: Colors.orange,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    // Moon
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.elasticOut,
                      top: (1 - _animation.value) * (effectiveSize - 24),
                      left: (effectiveSize - 24) / 2,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _animation.value,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.nights_stay,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    // Stars (only visible in dark mode)
                    ...List.generate(6, (index) {
                      final positions = [
                        const Offset(10, 15),
                        const Offset(45, 10),
                        const Offset(50, 30),
                        const Offset(15, 35),
                        const Offset(40, 45),
                        const Offset(20, 50),
                      ];
                      
                      return AnimatedPositioned(
                        duration: Duration(milliseconds: 600 + (index * 100)),
                        curve: Curves.elasticOut,
                        left: positions[index].dx,
                        top: positions[index].dy,
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 300 + (index * 50)),
                          opacity: _animation.value,
                          child: AnimatedScale(
                            duration: Duration(milliseconds: 600 + (index * 100)),
                            scale: _animation.value,
                            child: const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 4,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ThemeSelector extends StatelessWidget {
  final Color? primaryColor;
  final bool showSystemOption;

  const ThemeSelector({
    super.key,
    this.primaryColor,
    this.showSystemOption = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final effectivePrimaryColor = primaryColor ?? AppColors.primary;
        
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.palette,
                      color: effectivePrimaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Theme Settings',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildThemeOption(
                  context,
                  themeProvider,
                  'Light Mode',
                  'Clean and bright interface',
                  Icons.light_mode,
                  ThemeMode.light,
                  effectivePrimaryColor,
                ),
                const SizedBox(height: 8),
                _buildThemeOption(
                  context,
                  themeProvider,
                  'Dark Mode',
                  'Easy on the eyes',
                  Icons.dark_mode,
                  ThemeMode.dark,
                  effectivePrimaryColor,
                ),
                if (showSystemOption) ...[
                  const SizedBox(height: 8),
                  _buildThemeOption(
                    context,
                    themeProvider,
                    'System Default',
                    'Follow device settings',
                    Icons.brightness_auto,
                    ThemeMode.system,
                    effectivePrimaryColor,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeProvider themeProvider,
    String title,
    String subtitle,
    IconData icon,
    ThemeMode mode,
    Color primaryColor,
  ) {
    final isSelected = themeProvider.themeMode == mode;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => themeProvider.setThemeMode(mode),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected 
              ? primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
              ? Border.all(color: primaryColor.withValues(alpha: 0.3))
              : null,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? primaryColor.withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? primaryColor : Colors.grey[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? primaryColor : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: primaryColor,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}