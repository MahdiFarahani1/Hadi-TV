import 'package:flutter/material.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/widgets/skeleton.dart';

/// A chic, ultra-modern skeleton loader tailored specifically for VideoDetailScreen.
class VideoDetailSkeleton extends StatelessWidget {
  const VideoDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Video Player Area Skeleton ────────────────────────────────
          const Stack(
            alignment: Alignment.center,
            children: [
              Skeleton(
                width: double.infinity,
                height: 235,
                borderRadius: 0,
              ),
              // Play Icon Shimmer Center
              SkeletonCircle(size: 54),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 2. Category Badge Skeleton ─────────────────────────────
                const Skeleton(width: 80, height: 22, borderRadius: 8),
                const SizedBox(height: 12),

                // ── 3. Video Title Skeleton (2 lines) ───────────────────────
                const Skeleton(width: double.infinity, height: 18, borderRadius: 6),
                const SizedBox(height: 8),
                const Skeleton(width: 240, height: 18, borderRadius: 6),
                const SizedBox(height: 14),

                // ── 4. Meta Row Skeleton (Views, Date) ─────────────────────
                const Row(
                  children: [
                    Skeleton(width: 75, height: 12, borderRadius: 4),
                    SizedBox(width: 12),
                    SkeletonCircle(size: 5),
                    SizedBox(width: 12),
                    Skeleton(width: 90, height: 12, borderRadius: 4),
                  ],
                ),
                const SizedBox(height: 20),

                // ── 5. Speaker Profile Card Skeleton ────────────────────────
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                    ),
                  ),
                  child: const Row(
                    children: [
                      SkeletonCircle(size: 48),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Skeleton(width: 110, height: 14, borderRadius: 6),
                            SizedBox(height: 6),
                            Skeleton(width: 160, height: 10, borderRadius: 6),
                          ],
                        ),
                      ),
                      Skeleton(width: 32, height: 32, borderRadius: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // ── 6. Action Buttons Skeleton Row (Save & Share) ───────────
                const Row(
                  children: [
                    Expanded(
                      child: Skeleton(height: 44, borderRadius: 14),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Skeleton(height: 44, borderRadius: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── 7. Description Box Skeleton ────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeleton(width: 100, height: 14, borderRadius: 6),
                      SizedBox(height: 12),
                      Skeleton(width: double.infinity, height: 11, borderRadius: 5),
                      SizedBox(height: 8),
                      Skeleton(width: double.infinity, height: 11, borderRadius: 5),
                      SizedBox(height: 8),
                      Skeleton(width: 220, height: 11, borderRadius: 5),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── 8. Related Videos Title & Horizontal Cards Skeleton ─────
                const Row(
                  children: [
                    Skeleton(width: 4, height: 16, borderRadius: 2),
                    SizedBox(width: 8),
                    Skeleton(width: 120, height: 14, borderRadius: 6),
                  ],
                ),
                const SizedBox(height: 14),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  child: Row(
                    children: [
                      VideoCardSkeleton(width: 200, height: 180),
                      VideoCardSkeleton(width: 200, height: 180),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
