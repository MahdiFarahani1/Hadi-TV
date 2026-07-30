import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/di/injection.dart';
import 'package:haditv/core/widgets/error_widget.dart';
import 'package:haditv/core/widgets/header.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/live_tv/domain/entities/live_channel.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/home/domain/usecases/get_home_content_usecase.dart';
import 'package:haditv/core/widgets/article_card.dart';
import 'package:haditv/core/widgets/empty_widget.dart';
import 'package:haditv/core/widgets/skeleton.dart';
import 'package:haditv/core/widgets/video_card.dart';
import 'package:haditv/core/utils/extension.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HomeCubit(getHomeContentUseCase: getIt<GetHomeContentUseCase>())
            ..loadHomeData(),
      child: const Scaffold(body: HomeView()),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HomeView
// ─────────────────────────────────────────────────────────────────────────────

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () => context.read<HomeCubit>().loadHomeData(),
          color: AppTheme.primaryColor,
          backgroundColor: context.cardBg,
          displacement: 60,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              const MainHeader(pageName: 'Home'),
              if (state is HomeLoading)
                const SliverToBoxAdapter(child: HomeSkeletonBody())
              else if (state is HomeError)
                SliverFillRemaining(
                  child: CustomErrorWidget(
                    message: state.message,
                    onRetry: () => context.read<HomeCubit>().loadHomeData(),
                  ),
                )
              else if (state is HomeLoaded)
                _buildLoadedBody(context, state),
            ],
          ),
        );
      },
    );
  }

  // ─── Loaded State ──────────────────────────────────────────────────────────

  Widget _buildLoadedBody(BuildContext context, HomeLoaded state) {
    final hasLive = state.liveChannels.any((c) => c.isLive);
    final hasFeaturedVideos = state.featuredVideos.isNotEmpty;
    final hasFeaturedArticles = state.featuredArticles.isNotEmpty;
    final hasTrending = state.trending.isNotEmpty;
    final hasRecommended = state.recommended.isNotEmpty;
    final hasLatestArticles = state.latestArticles.isNotEmpty;

    final hasAnyContent =
        hasLive ||
        hasFeaturedVideos ||
        hasFeaturedArticles ||
        hasTrending ||
        hasRecommended ||
        hasLatestArticles;

    if (!hasAnyContent) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: AppEmptyWidget(
          icon: Icons.grid_off_rounded,
          title: context.tr('no_content_found'),
          subtitle: context.tr('no_content_subtitle'),
          actionLabel: context.tr('retry'),
          onAction: () => context.read<HomeCubit>().loadHomeData(),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Live Channels
          if (hasLive) _buildLiveChannelsSection(context, state.liveChannels),

          const SizedBox(height: 8),

          // Featured Videos
          if (hasFeaturedVideos)
            _buildSection(
              context,
              title: context.tr('featured_videos'),
              onSeeAll: () => context.go('/videos'),
              child: _buildVideoRow(context, state.featuredVideos),
            ),

          // Featured Articles
          if (hasFeaturedArticles)
            _buildSection(
              context,
              title: context.tr('featured_articles'),
              onSeeAll: () => context.go('/articles'),
              child: _buildArticleRow(context, state.featuredArticles),
            ),

          // Trending
          if (hasTrending)
            _buildSection(
              context,
              title: context.tr('trending_now'),
              onSeeAll: () => context.go('/videos'),
              child: _buildVideoRow(context, state.trending),
            ),

          // Recommended
          if (hasRecommended)
            _buildSection(
              context,
              title: context.tr('recommended_for_you'),
              onSeeAll: () => context.go('/videos'),
              child: _buildVideoRow(context, state.recommended),
            ),

          // Latest Articles
          if (hasLatestArticles)
            _buildSection(
              context,
              title: context.tr('latest_articles'),
              onSeeAll: () => context.go('/articles'),
              child: _buildArticleRow(context, state.latestArticles),
            ),

          const SizedBox(height: 110),
        ],
      ),
    );
  }

  // ─── Live Channels ─────────────────────────────────────────────────────────

  Widget _buildLiveChannelsSection(
    BuildContext context,
    List<LiveChannel> channels,
  ) {
    final activeChannels = channels.where((c) => c.isLive).toList();
    if (activeChannels.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 16, 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.liveRedColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.liveRedColor.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.circle, color: Colors.white, size: 7),
                    const SizedBox(width: 5),
                    Text(
                      'LIVE',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                context.tr('live_channels'),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 96,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: activeChannels.length,
            itemBuilder: (context, index) {
              return _LiveChannelChip(channel: activeChannels[index]);
            },
          ),
        ),
        const SizedBox(height: 10),
        Divider(
          color: context.theme.dividerColor,
          height: 1,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }

  // ─── Section Builder ───────────────────────────────────────────────────────

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required VoidCallback onSeeAll,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 12, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 1.5,
                    height: 17.5,
                    decoration: BoxDecoration(
                      color: context.accentBlue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  context.gap(6),
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: context.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onSeeAll,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.tr('see_all'),
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.primaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppTheme.primaryColor,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        child,
        const SizedBox(height: 4),
      ],
    );
  }

  // ─── Video Row ─────────────────────────────────────────────────────────────

  Widget _buildVideoRow(BuildContext context, List<Video> videos) {
    return SizedBox(
      height: 198,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return VideoCard(
            video: video,
            onTap: () =>
                context.push('/videos/detail/${video.id}', extra: video),
          );
        },
      ),
    );
  }

  // ─── Article Row ───────────────────────────────────────────────────────────

  Widget _buildArticleRow(BuildContext context, List<Article> articles) {
    return SizedBox(
      height: 116,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return ArticleCard(
            article: article,
            onTap: () =>
                context.push('/articles/detail/${article.id}', extra: article),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Live Channel Chip
// ─────────────────────────────────────────────────────────────────────────────

class _LiveChannelChip extends StatelessWidget {
  final LiveChannel channel;

  const _LiveChannelChip({required this.channel});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) => GestureDetector(
        onTap: () => ctx.go('/live', extra: channel),
        child: Container(
          margin: const EdgeInsets.only(right: 16),
          child: Column(
            children: [
              Stack(
                children: [
                  // Avatar
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: channel.logoUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const SkeletonCircle(size: 62),
                        errorWidget: (_, __, ___) => Container(
                          color: AppTheme.darkSurface,
                          child: const Icon(
                            Icons.live_tv_rounded,
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Live badge
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.liveRedColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: context.theme.scaffoldBackgroundColor,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        '● LIVE',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 68,
                child: Text(
                  channel.channelName.split(' ').first,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: context.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Skeleton / Loading View
// ─────────────────────────────────────────────────────────────────────────────

class HomeSkeletonBody extends StatelessWidget {
  const HomeSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Banner Skeleton
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Skeleton(
            width: double.infinity,
            height: 224,
            borderRadius: 24,
          ),
        ),
        const SizedBox(height: 20),

        // Live channels skeleton
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Skeleton(width: 120, height: 14, borderRadius: 6),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 62,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 5,
            itemBuilder: (_, __) => Container(
              margin: const EdgeInsets.only(right: 16),
              child: const SkeletonCircle(size: 62),
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Section 1
        _skeletonSection(context),
        const SizedBox(height: 24),

        // Section 2
        _skeletonSection(context),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _skeletonSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Skeleton(width: 140, height: 14, borderRadius: 6),
              Skeleton(width: 60, height: 26, borderRadius: 10),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 195,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 3,
            itemBuilder: (_, __) => const VideoCardSkeleton(),
          ),
        ),
      ],
    );
  }
}
