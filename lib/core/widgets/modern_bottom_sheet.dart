import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';

class ModernBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool showDragHandle = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isDismissible = true,
    bool useSafeArea = true,
    bool enableBlur = true,
    double blurStrength = 10.0,
  }) {
    if (enableBlur) {
      return showGeneralDialog<T>(
        context: context,
        barrierDismissible: isDismissible,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, _) {
          return SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  constraints: constraints,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        (backgroundColor ?? Theme.of(context).bottomSheetTheme.backgroundColor ?? Theme.of(context).cardColor),
                        (backgroundColor ?? Theme.of(context).bottomSheetTheme.backgroundColor ?? Theme.of(context).cardColor).withValues(alpha: 0.95),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 30,
                        offset: const Offset(0, -8),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Decorative background pattern
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                            gradient: RadialGradient(
                              center: const Alignment(0.8, -0.2),
                              radius: 1.5,
                              colors: [
                                Colors.white.withValues(alpha: 0.03),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Main content
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (showDragHandle)
                            Container(
                              margin: const EdgeInsets.only(top: 12, bottom: 8),
                              child: Column(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey[400]!,
                                          Colors.grey[300]!,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: 24,
                                    height: 2,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Flexible(child: child),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return Stack(
            children: [
              // Backdrop blur effect with gesture detector for dismissal
              Positioned.fill(
                child: GestureDetector(
                  onTap: isDismissible ? () => Navigator.of(context).pop() : null,
                  child: AnimatedBuilder(
                    animation: animation,
                    builder: (context, _) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: animation.value * blurStrength,
                          sigmaY: animation.value * blurStrength,
                        ),
                        child: Container(
                          color: Colors.black.withValues(alpha: animation.value * 0.3),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Bottom sheet content
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: GestureDetector(
                  onTap: () {}, // Prevent taps on content from closing
                  child: child,
                ),
              ),
            ],
          );
        },
      );
    }
    
    // Fallback to standard bottom sheet without blur
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      backgroundColor: backgroundColor ?? Theme.of(context).bottomSheetTheme.backgroundColor,
      elevation: elevation ?? 0,
      shape: shape ?? 
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      constraints: constraints,
      barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.5),
      isDismissible: isDismissible,
      useSafeArea: useSafeArea,
      builder: (context) => child,
    );
  }

  static Future<T?> showConfirmation<T>({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    Color? cancelColor,
    IconData? icon,
    bool isDangerous = false,
    bool enableBlur = true,
  }) {
    return show<T>(
      context: context,
      enableBlur: enableBlur,
      child: ConfirmationBottomSheet(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor ?? (isDangerous ? AppColors.error : AppColors.primary),
        cancelColor: cancelColor,
        icon: icon,
        isDangerous: isDangerous,
      ),
    );
  }

  static Future<T?> showOptions<T>({
    required BuildContext context,
    required String title,
    required List<BottomSheetOption<T>> options,
    String? subtitle,
    IconData? icon,
    bool enableBlur = true,
  }) {
    return show<T>(
      context: context,
      enableBlur: enableBlur,
      child: OptionsBottomSheet<T>(
        title: title,
        subtitle: subtitle,
        options: options,
        icon: icon,
      ),
    );
  }

  static Future<T?> showCustom<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    String? subtitle,
    IconData? icon,
    bool showCloseButton = true,
    bool enableBlur = true,
  }) {
    return show<T>(
      context: context,
      enableBlur: enableBlur,
      child: CustomBottomSheet(
        title: title,
        subtitle: subtitle,
        content: content,
        actions: actions,
        icon: icon,
        showCloseButton: showCloseButton,
      ),
    );
  }
}

class BottomSheetOption<T> {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final T value;
  final Color? color;
  final VoidCallback? onTap;
  final bool isDestructive;

  const BottomSheetOption({
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.color,
    this.onTap,
    this.isDestructive = false,
  });
}

class ConfirmationBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color confirmColor;
  final Color? cancelColor;
  final IconData? icon;
  final bool isDangerous;

  const ConfirmationBottomSheet({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.confirmColor,
    this.cancelColor,
    this.icon,
    this.isDangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDangerous 
                  ? AppColors.error.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 32,
                color: isDangerous ? AppColors.error : AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
          ],
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: cancelColor ?? AppColors.textSecondary,
                    side: BorderSide(
                      color: cancelColor ?? Colors.grey[300]!,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(cancelText),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(confirmText),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class OptionsBottomSheet<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<BottomSheetOption<T>> options;
  final IconData? icon;

  const OptionsBottomSheet({
    super.key,
    required this.title,
    required this.options,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          ...options.map((option) => Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  option.onTap?.call();
                  Navigator.of(context).pop(option.value);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: option.isDestructive 
                        ? AppColors.error.withValues(alpha: 0.2)
                        : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      if (option.icon != null) ...[
                        Icon(
                          option.icon,
                          color: option.isDestructive 
                            ? AppColors.error 
                            : option.color ?? AppColors.textPrimary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: option.isDestructive 
                                  ? AppColors.error 
                                  : option.color ?? AppColors.textPrimary,
                              ),
                            ),
                            if (option.subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                option.subtitle!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget content;
  final List<Widget>? actions;
  final IconData? icon;
  final bool showCloseButton;

  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.content,
    this.subtitle,
    this.actions,
    this.icon,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (showCloseButton)
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  color: AppColors.textSecondary,
                ),
            ],
          ),
          const SizedBox(height: 24),
          content,
          if (actions != null) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                for (int i = 0; i < actions!.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  Expanded(child: actions![i]),
                ],
              ],
            ),
          ],
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}