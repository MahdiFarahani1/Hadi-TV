import 'package:flutter/material.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/widgets/skeleton.dart';

class LiveTvSkeleton extends StatelessWidget {
  const LiveTvSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Video Player Skeleton (16:9)
          const AspectRatio(
            aspectRatio: 16 / 9,
            child: Skeleton(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 20,
            ),
          ),
          const SizedBox(height: 16),

          // Active Channel Header Skeleton Info Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
              borderRadius: BorderRadius.circular(20),
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
                      Skeleton(width: 140, height: 14, borderRadius: 6),
                      SizedBox(height: 8),
                      Skeleton(width: 200, height: 10, borderRadius: 6),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Channels List Header Skeleton
          const Skeleton(width: 120, height: 12, borderRadius: 6),
          const SizedBox(height: 14),

          // Channel Cards List Skeleton
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Skeleton(width: 60, height: 40, borderRadius: 10),
                  SizedBox(width: 12),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
