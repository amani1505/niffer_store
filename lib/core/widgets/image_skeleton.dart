import 'package:flutter/material.dart';
import 'package:niffer_store/core/widgets/skeleton_shimmer.dart';

/// Skeleton shimmer component specifically for image loading
class ImageSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BoxFit fit;
  final Widget? child;

  const ImageSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
    this.padding,
    this.fit = BoxFit.cover,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: SkeletonShimmer(
          child: Container(
            width: width,
            height: height,
            color: Colors.white,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Circular image skeleton for avatars and profile pictures
class CircularImageSkeleton extends StatelessWidget {
  final double radius;
  final EdgeInsetsGeometry? margin;

  const CircularImageSkeleton({
    super.key,
    required this.radius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: SkeletonShimmer(
        child: Container(
          width: radius * 2,
          height: radius * 2,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

/// Image gallery skeleton for product detail pages
class ImageGallerySkeleton extends StatelessWidget {
  final double height;
  final int thumbnailCount;
  final EdgeInsets? margin;

  const ImageGallerySkeleton({
    super.key,
    this.height = 400,
    this.thumbnailCount = 4,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        children: [
          // Main image skeleton
          ImageSkeleton(
            width: double.infinity,
            height: height,
            borderRadius: BorderRadius.circular(16),
          ),
          const SizedBox(height: 16),
          
          // Thumbnail images skeleton
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: thumbnailCount,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: ImageSkeleton(
                    width: 80,
                    height: 80,
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Card with image skeleton commonly used in lists
class CardImageSkeleton extends StatelessWidget {
  final double? height;
  final double? width;
  final bool showContent;
  final int contentLines;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const CardImageSkeleton({
    super.key,
    this.height = 200,
    this.width,
    this.showContent = true,
    this.contentLines = 3,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image skeleton
            ImageSkeleton(
              width: double.infinity,
              height: height,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            
            if (showContent) ...[
              Padding(
                padding: padding ?? const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Content lines
                    for (int i = 0; i < contentLines; i++) ...[
                      SkeletonShimmer(
                        child: Container(
                          height: i == 0 ? 16 : 14,
                          width: i == contentLines - 1 
                              ? MediaQuery.of(context).size.width * 0.6 
                              : double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      if (i < contentLines - 1) const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Banner/carousel image skeleton
class BannerImageSkeleton extends StatelessWidget {
  final double height;
  final EdgeInsets? margin;
  final bool showIndicators;
  final int indicatorCount;

  const BannerImageSkeleton({
    super.key,
    this.height = 200,
    this.margin,
    this.showIndicators = true,
    this.indicatorCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        children: [
          ImageSkeleton(
            width: double.infinity,
            height: height,
            borderRadius: BorderRadius.circular(16),
          ),
          
          if (showIndicators) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                indicatorCount,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: SkeletonShimmer(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// List item with image skeleton
class ListItemImageSkeleton extends StatelessWidget {
  final double imageSize;
  final bool showSecondaryText;
  final bool showTrailing;
  final EdgeInsets? padding;

  const ListItemImageSkeleton({
    super.key,
    this.imageSize = 56,
    this.showSecondaryText = true,
    this.showTrailing = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Leading image skeleton
          ImageSkeleton(
            width: imageSize,
            height: imageSize,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SkeletonShimmer(
                  child: Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                if (showSecondaryText) ...[
                  const SizedBox(height: 8),
                  SkeletonShimmer(
                    child: Container(
                      height: 14,
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          if (showTrailing) ...[
            const SizedBox(width: 16),
            SkeletonShimmer(
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}