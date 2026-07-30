import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/di/injection.dart';
import 'package:haditv/core/widgets/empty_widget.dart';
import 'package:haditv/core/widgets/error_widget.dart';
import 'package:haditv/core/widgets/header.dart';
import 'package:haditv/core/widgets/skeleton.dart';
import 'package:haditv/features/videos/domain/usecases/get_speakers_usecase.dart';
import 'package:haditv/features/videos/domain/usecases/get_videos_usecase.dart';
import 'package:haditv/features/videos/domain/usecases/get_video_categories_usecase.dart';
import 'package:haditv/core/widgets/video_card.dart';
import 'package:haditv/core/utils/extension.dart';
import 'package:haditv/features/videos/presentation/widgets/videos_skeleton.dart';
import 'cubit/video_list_cubit.dart';
import 'cubit/video_list_state.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VideoListCubit(
        getVideosUseCase: getIt<GetVideosUseCase>(),
        getCategoriesUseCase: getIt<GetVideoCategoriesUseCase>(),
        getSpeakersUseCase: getIt<GetSpeakersUsecase>(),
      )..loadInit(),
      child: const Scaffold(body: VideosView()),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class VideosView extends StatefulWidget {
  const VideosView({super.key});

  @override
  State<VideosView> createState() => _VideosViewState();
}

class _VideosViewState extends State<VideosView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final cubitState = context.read<VideoListCubit>().state;
      if (cubitState is VideoListLoaded) {
        if (!cubitState.isLoadingMore &&
            !cubitState.isItemsLoading &&
            !cubitState.hasReachedMax) {
          context.read<VideoListCubit>().loadMore();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoListCubit, VideoListState>(
      builder: (context, state) {
        return CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            const MainHeader(pageName: 'Videos'),

            // ── States ──────────────────────────────────────────────
            if (state is VideoListLoading)
              const SliverToBoxAdapter(child: VideosSkeleton())
            else if (state is VideoListError)
              SliverFillRemaining(
                child: CustomErrorWidget(
                  message: state.message,
                  onRetry: () => context.read<VideoListCubit>().loadInit(),
                ),
              )
            else if (state is VideoListLoaded) ...[
              // ── Category Selector Header & Chips ───────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.category_rounded,
                        size: 15,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        context.tr('categories'),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: context.textPrimary,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.categories.length + 1,
                    itemBuilder: (context, index) {
                      final isAll = index == 0;
                      final cat = isAll ? null : state.categories[index - 1];
                      final catName = isAll
                          ? context.tr('all_categories')
                          : cat!.title;
                      final catGid = isAll ? null : cat!.id;
                      final isSelected = isAll
                          ? state.selectedGid == null
                          : state.selectedGid == catGid;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _FilterChip(
                          label: catName,
                          icon: isAll
                              ? Icons.grid_view_rounded
                              : Icons.video_collection_outlined,
                          isSelected: isSelected,
                          onTap: () {
                            context.read<VideoListCubit>().changeCategory(
                              catGid,
                              catName,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),

              // ── Speaker Selector Header & Chips ─────────────────────
              if (state.speakers.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.record_voice_over_rounded,
                          size: 15,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          context.tr('speakers_scholars'),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: context.textPrimary,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 44,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.speakers.length + 1,
                      itemBuilder: (context, index) {
                        final isAll = index == 0;
                        final speaker = isAll
                            ? null
                            : state.speakers[index - 1];
                        final speakerName = isAll
                            ? context.tr('all_speakers')
                            : speaker!.name;
                        final speakerId = isAll ? null : speaker!.id;
                        final isSelected = isAll
                            ? state.selectedSpeakerId == null
                            : state.selectedSpeakerId == speakerId;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _FilterChip(
                            label: speakerName,
                            icon: isAll
                                ? Icons.groups_rounded
                                : Icons.person_rounded,
                            isSelected: isSelected,
                            onTap: () {
                              context.read<VideoListCubit>().filterBySpeaker(
                                speakerId,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],

              const SliverPadding(padding: EdgeInsets.only(top: 16)),

              // ── Video Items Section ────────────────────────────────
              if (state.isItemsLoading)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.88,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const VideoCardSkeleton(
                        width: double.infinity,
                        height: 180,
                      ),
                      childCount: 6,
                    ),
                  ),
                )
              else if (state.videos.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyVideosView(
                    onReset: () {
                      final cubit = context.read<VideoListCubit>();
                      cubit.changeCategory(null, 'All Categories');
                      cubit.filterBySpeaker(null);
                    },
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.88,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final video = state.videos[index];
                      return VideoCard(
                            video: video,
                            width: double.infinity,
                            onTap: () => context.push(
                              '/videos/detail/${video.id}',
                              extra: video,
                            ),
                          )
                          .animate(delay: (index * 30).ms)
                          .fadeIn(duration: 250.ms)
                          .slideY(begin: 0.05, end: 0, duration: 250.ms);
                    }, childCount: state.videos.length),
                  ),
                ),

              // ── Load More Indicator ────────────────────────────────
              if (state.isLoadingMore)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                          strokeWidth: 2.5,
                        ),
                      ),
                    ),
                  ),
                ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected
              ? null
              : (isDark ? AppTheme.darkCard : AppTheme.lightCard),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : (isDark
                      ? AppTheme.darkBorder.withOpacity(0.6)
                      : AppTheme.lightBorder),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? Colors.black
                  : (isDark ? Colors.white70 : Colors.black87),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: isSelected ? Colors.black : context.textPrimary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _EmptyVideosView extends StatelessWidget {
  final VoidCallback onReset;

  const _EmptyVideosView({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return AppEmptyWidget(
      icon: Icons.video_library_outlined,
      title: context.tr('no_videos_found'),
      subtitle: context.tr('no_videos_subtitle'),
      actionLabel: context.tr('show_all_videos'),
      onAction: onReset,
      iconColor: AppTheme.accentBlue,
    );
  }
}
