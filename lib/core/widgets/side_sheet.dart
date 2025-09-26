import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:niffer_store/core/constants/app_colors.dart';
import 'package:niffer_store/core/widgets/responsive_layout.dart';

class SideSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    Color? backgroundColor,
    double? width,
    bool barrierDismissible = true,
    bool enableBlur = true,
    double blurStrength = 10.0,
    AlignmentGeometry alignment = Alignment.centerRight,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final effectiveWidth = width ?? (screenWidth * 0.4).clamp(300.0, 500.0);

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, _) {
        return SafeArea(
          child: Align(
            alignment: alignment,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: effectiveWidth,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: backgroundColor ?? Theme.of(context).cardColor,
                  borderRadius: alignment == Alignment.centerRight 
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        bottomLeft: Radius.circular(24),
                      )
                    : const BorderRadius.only(
                        topRight: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: alignment == Alignment.centerRight 
                        ? const Offset(-5, 0)
                        : const Offset(5, 0),
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return Stack(
          children: [
            // Backdrop blur effect
            if (enableBlur)
              Positioned.fill(
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
            // Side sheet content
            SlideTransition(
              position: Tween<Offset>(
                begin: alignment == Alignment.centerRight 
                  ? const Offset(1, 0)
                  : const Offset(-1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          ],
        );
      },
    );
  }

  static Future<T?> showNavigation<T>({
    required BuildContext context,
    required List<SideSheetNavigationItem> items,
    int currentIndex = 0,
    String? title,
    Widget? header,
    Widget? footer,
    Color? backgroundColor,
    Color? selectedColor,
  }) {
    return show<T>(
      context: context,
      backgroundColor: backgroundColor,
      child: SideSheetNavigation(
        items: items,
        currentIndex: currentIndex,
        title: title,
        header: header,
        footer: footer,
        selectedColor: selectedColor,
      ),
    );
  }
}

class SideSheetNavigationItem {
  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final VoidCallback? onTap;
  final Widget? badge;
  final bool isHeader;
  final bool isDivider;

  const SideSheetNavigationItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.onTap,
    this.badge,
    this.isHeader = false,
    this.isDivider = false,
  });

  const SideSheetNavigationItem.header({
    required this.label,
    this.icon = Icons.category,
  }) : selectedIcon = null,
       onTap = null,
       badge = null,
       isHeader = true,
       isDivider = false;

  const SideSheetNavigationItem.divider()
      : label = '',
        icon = Icons.remove,
        selectedIcon = null,
        onTap = null,
        badge = null,
        isHeader = false,
        isDivider = true;
}

class SideSheetNavigation extends StatelessWidget {
  final List<SideSheetNavigationItem> items;
  final int currentIndex;
  final String? title;
  final Widget? header;
  final Widget? footer;
  final Color? selectedColor;

  const SideSheetNavigation({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.title,
    this.header,
    this.footer,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSelectedColor = selectedColor ?? AppColors.primary;

    return Column(
      children: [
        // Header
        if (title != null || header != null)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: effectiveSelectedColor.withValues(alpha: 0.05),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: effectiveSelectedColor,
                        ),
                      ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      color: Colors.grey[600],
                    ),
                  ],
                ),
                if (header != null) ...[
                  const SizedBox(height: 16),
                  header!,
                ],
              ],
            ),
          ),

        // Navigation Items
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              
              if (item.isDivider) {
                return const Divider(height: 1);
              }
              
              if (item.isHeader) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text(
                    item.label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                );
              }

              final isSelected = index == currentIndex;
              
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      item.onTap?.call();
                      Navigator.of(context).pop(index);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected 
                          ? effectiveSelectedColor.withValues(alpha: 0.1)
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                          ? Border.all(
                              color: effectiveSelectedColor.withValues(alpha: 0.3),
                              width: 1,
                            )
                          : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected && item.selectedIcon != null
                              ? item.selectedIcon
                              : item.icon,
                            color: isSelected 
                              ? effectiveSelectedColor
                              : Colors.grey[600],
                            size: 22,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              item.label,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: isSelected 
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                                color: isSelected 
                                  ? effectiveSelectedColor
                                  : Colors.grey[800],
                              ),
                            ),
                          ),
                          if (item.badge != null)
                            item.badge!,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Footer
        if (footer != null)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: footer!,
          ),
      ],
    );
  }
}

class ResponsiveNavigation extends StatelessWidget {
  final List<NavigationItem> items;
  final int currentIndex;
  final ValueChanged<int>? onItemSelected;
  final Color? selectedColor;
  final String? sideSheetTitle;
  final Widget? sideSheetHeader;
  final Widget? sideSheetFooter;

  const ResponsiveNavigation({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.onItemSelected,
    this.selectedColor,
    this.sideSheetTitle,
    this.sideSheetHeader,
    this.sideSheetFooter,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      // Desktop: Use floating action button to open side sheet
      return FloatingActionButton(
        onPressed: () => _showSideSheet(context),
        backgroundColor: selectedColor ?? AppColors.primary,
        child: const Icon(Icons.menu, color: Colors.white),
      );
    } else {
      // Mobile: Use bottom navigation bar
      return BottomNavigationBar(
        currentIndex: currentIndex.clamp(0, items.length - 1),
        onTap: onItemSelected,
        selectedItemColor: selectedColor ?? AppColors.primary,
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        items: items.map((item) => BottomNavigationBarItem(
          icon: Icon(item.icon),
          activeIcon: item.selectedIcon != null 
            ? Icon(item.selectedIcon)
            : Icon(item.icon),
          label: item.label,
        )).toList(),
      );
    }
  }

  void _showSideSheet(BuildContext context) {
    SideSheet.showNavigation(
      context: context,
      title: sideSheetTitle ?? 'Navigation',
      header: sideSheetHeader,
      footer: sideSheetFooter,
      selectedColor: selectedColor,
      currentIndex: currentIndex,
      items: items.map((item) => SideSheetNavigationItem(
        label: item.label,
        icon: item.icon,
        selectedIcon: item.selectedIcon,
        onTap: () {
          if (onItemSelected != null) {
            onItemSelected!(items.indexOf(item));
          }
        },
        badge: item.badge,
      )).toList(),
    );
  }
}

class NavigationItem {
  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final Widget? badge;

  const NavigationItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.badge,
  });
}