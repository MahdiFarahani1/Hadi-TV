import 'package:flutter/material.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/widgets/skeleton.dart';

/// A chic, professional skeleton loader tailored specifically for ArticleDetailScreen.
class ArticleDetailSkeleton extends StatelessWidget {
  const ArticleDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Hero Image / App Bar Header Skeleton ─────────────────────
          const Stack(
            children: [
              Skeleton(
                width: double.infinity,
                height: 320,
                borderRadius: 0,
              ),
              // Top Action Buttons Glass Shimmer
              Positioned(
                top: 48,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SkeletonCircle(size: 40),
                    Row(
                      children: [
                        SkeletonCircle(size: 40),
                        SizedBox(width: 8),
                        SkeletonCircle(size: 40),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 2. Category Tag Skeleton ──────────────────────────────
                const Skeleton(width: 90, height: 24, borderRadius: 8),
                const SizedBox(height: 14),

                // ── 3. Article Title Skeleton (3 lines) ────────────────────
                const Skeleton(width: double.infinity, height: 22, borderRadius: 6),
                const SizedBox(height: 10),
                const Skeleton(width: double.infinity, height: 22, borderRadius: 6),
                const SizedBox(height: 10),
                const Skeleton(width: 200, height: 22, borderRadius: 6),
                const SizedBox(height: 18),

                // ── 4. Metadata Badge Row Skeleton (Read Time & Created At) ──
                const Row(
                  children: [
                    Skeleton(width: 85, height: 26, borderRadius: 8),
                    SizedBox(width: 12),
                    Skeleton(width: 110, height: 26, borderRadius: 8),
                  ],
                ),
                const SizedBox(height: 24),

                const Divider(height: 1),
                const SizedBox(height: 24),

                // ── 5. Article Body Paragraph 1 Skeleton ──────────────────
                const Skeleton(width: double.infinity, height: 12, borderRadius: 6),
                const SizedBox(height: 8),
                const Skeleton(width: double.infinity, height: 12, borderRadius: 6),
                const SizedBox(height: 8),
                const Skeleton(width: double.infinity, height: 12, borderRadius: 6),
                const SizedBox(height: 8),
                const Skeleton(width: 260, height: 12, borderRadius: 6),
                const SizedBox(height: 24),

                // ── 6. Article Body Paragraph 2 Skeleton ──────────────────
                const Skeleton(width: double.infinity, height: 12, borderRadius: 6),
                const SizedBox(height: 8),
                const Skeleton(width: double.infinity, height: 12, borderRadius: 6),
                const SizedBox(height: 8),
                const Skeleton(width: 300, height: 12, borderRadius: 6),
                const SizedBox(height: 28),

                // ── 7. Source Button Skeleton ─────────────────────────────
                Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Skeleton(width: 130, height: 12, borderRadius: 6),
                      SkeletonCircle(size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ── 8. Related Articles Section Skeleton ──────────────────
                const Row(
                  children: [
                    Skeleton(width: 4, height: 16, borderRadius: 2),
                    SizedBox(width: 8),
                    Skeleton(width: 130, height: 14, borderRadius: 6),
                  ],
                ),
                const SizedBox(height: 16),
                const ArticleCardSkeleton(),
                const SizedBox(height: 12),
                const ArticleCardSkeleton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
