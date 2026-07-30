import 'package:flutter/material.dart';
import 'package:haditv/core/widgets/skeleton.dart';

class VideosSkeleton extends StatelessWidget {
  const VideosSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
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
              Skeleton(width: 90, height: 36, borderRadius: 18),
              SizedBox(width: 8),
              Skeleton(width: 100, height: 36, borderRadius: 18),
              SizedBox(width: 8),
              Skeleton(width: 85, height: 36, borderRadius: 18),
            ],
          ),
        ),
        const SizedBox(height: 16),

        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          child: Row(
            children: [
              Skeleton(width: 80, height: 36, borderRadius: 18),
              SizedBox(width: 8),
              Skeleton(width: 90, height: 36, borderRadius: 18),
              SizedBox(width: 8),
              Skeleton(width: 100, height: 36, borderRadius: 18),
              SizedBox(width: 8),
              Skeleton(width: 85, height: 36, borderRadius: 18),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Video Cards Grid Skeleton
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 18,
            crossAxisSpacing: 14,
            childAspectRatio: 0.88,
          ),
          itemCount: 6,
          itemBuilder: (context, index) =>
              const VideoCardSkeleton(width: double.infinity, height: 180),
        ),
      ],
    );
  }
}
