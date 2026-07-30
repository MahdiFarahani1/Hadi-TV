import 'package:flutter/material.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/widgets/skeleton.dart';

class ArticlesSkeleton extends StatelessWidget {
  const ArticlesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        // Category Chips Skeleton
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          child: Row(
            children: [
              Skeleton(width: 80, height: 36, borderRadius: 18),
              SizedBox(width: 8),
              Skeleton(width: 95, height: 36, borderRadius: 18),
              SizedBox(width: 8),
              Skeleton(width: 110, height: 36, borderRadius: 18),
              SizedBox(width: 8),
              Skeleton(width: 90, height: 36, borderRadius: 18),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Featured Article Skeleton Card
        Container(
          height: 170,
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeleton(width: double.infinity, height: 100, borderRadius: 24),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton(width: 220, height: 12, borderRadius: 6),
                    SizedBox(height: 8),
                    Skeleton(width: 140, height: 10, borderRadius: 6),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Article List Items Skeleton
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: const ArticleCardSkeleton(),
          ),
        ),
      ],
    );
  }
}
