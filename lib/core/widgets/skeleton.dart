import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:haditv/config/theme/app_theme.dart';

/// A professional shimmer-based skeleton loader.
class Skeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const Skeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark
        ? const Color(0xFF1A2540)
        : const Color(0xFFE8EDF5);
    final highlightColor = isDark
        ? const Color(0xFF243054)
        : const Color(0xFFF8FAFF);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: const Duration(milliseconds: 1400),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// A circular shimmer skeleton (for avatars/channel logos).
class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      width: size,
      height: size,
      borderRadius: size / 2,
    );
  }
}

/// Skeleton for a video card.
class VideoCardSkeleton extends StatelessWidget {
  final double width;
  final double height;

  const VideoCardSkeleton({
    super.key,
    this.width = 200,
    this.height = 195,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(width: width, height: 118, borderRadius: 16),
          const SizedBox(height: 10),
          Skeleton(width: width * 0.9, height: 12, borderRadius: 6),
          const SizedBox(height: 6),
          Skeleton(width: width * 0.6, height: 10, borderRadius: 6),
        ],
      ),
    );
  }
}

/// Skeleton for an article card.
class ArticleCardSkeleton extends StatelessWidget {
  const ArticleCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 100,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.darkCard
            : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Skeleton(width: 76, height: 76, borderRadius: 14),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Skeleton(width: double.infinity, height: 10, borderRadius: 6),
                SizedBox(height: 8),
                Skeleton(width: double.infinity, height: 10, borderRadius: 6),
                SizedBox(height: 8),
                Skeleton(width: 80, height: 8, borderRadius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Single skeleton row that mimics a settings list tile.
class SettingsTileSkeleton extends StatelessWidget {
  const SettingsTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
        ),
      ),
      child: const Row(
        children: [
          Skeleton(width: 40, height: 40, borderRadius: 11),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(width: 120, height: 11, borderRadius: 6),
                SizedBox(height: 6),
                Skeleton(width: 80, height: 9, borderRadius: 6),
              ],
            ),
          ),
          Skeleton(width: 18, height: 18, borderRadius: 9),
        ],
      ),
    );
  }
}

/// Full skeleton screen for the Settings page.
class SettingsScreenSkeleton extends StatelessWidget {
  const SettingsScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      physics: const BouncingScrollPhysics(),
      children: [
        // Profile header skeleton
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
            ),
          ),
          child: const Row(
            children: [
              SkeletonCircle(size: 56),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton(width: 100, height: 14, borderRadius: 7),
                    SizedBox(height: 8),
                    Skeleton(width: 160, height: 10, borderRadius: 6),
                  ],
                ),
              ),
              Skeleton(width: 36, height: 26, borderRadius: 8),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Group: LANGUAGE & APPEARANCE
        const Skeleton(width: 120, height: 9, borderRadius: 5),
        const SizedBox(height: 10),
        const SettingsTileSkeleton(),
        const SettingsTileSkeleton(),

        const SizedBox(height: 16),

        // Group: SOCIAL
        const Skeleton(width: 80, height: 9, borderRadius: 5),
        const SizedBox(height: 10),
        const SettingsTileSkeleton(),
        const SettingsTileSkeleton(),
        const SettingsTileSkeleton(),
      ],
    );
  }
}
