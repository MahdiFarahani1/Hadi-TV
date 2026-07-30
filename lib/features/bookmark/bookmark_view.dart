import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/di/injection.dart';
import 'package:haditv/core/widgets/article_card.dart';
import 'package:haditv/core/widgets/dialog_common.dart';
import 'package:haditv/core/widgets/empty_widget.dart';
import 'package:haditv/core/widgets/header.dart';
import 'package:haditv/core/widgets/snackbar_common.dart';
import 'package:haditv/core/widgets/video_card.dart';
import 'package:haditv/core/utils/extension.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_state.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class BookmarkView extends StatelessWidget {
  const BookmarkView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<BookmarkCubit>()..loadBookmarks(),
      child: const Scaffold(body: BookmarkBody()),
    );
  }
}

class BookmarkBody extends StatefulWidget {
  const BookmarkBody({super.key});

  @override
  State<BookmarkBody> createState() => _BookmarkBodyState();
}

class _BookmarkBodyState extends State<BookmarkBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return BlocBuilder<BookmarkCubit, BookmarkState>(
      builder: (context, state) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // ── Main Header ─────────────────────────────────────────
            const MainHeader(pageName: 'bookmarks'),

            if (state is BookmarkLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                ),
              )
            else if (state is BookmarkError)
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    state.message,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppTheme.errorColor,
                    ),
                  ),
                ),
              )
            else if (state is BookmarkLoaded) ...[
              // ── Header Bar with Search & Clear Action ─────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search & Clear Header Row
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 46,
                              decoration: BoxDecoration(
                                color: context.cardBg,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isDark
                                      ? AppTheme.darkBorder
                                      : AppTheme.lightBorder,
                                ),
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (q) => context
                                    .read<BookmarkCubit>()
                                    .updateSearch(q),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: context.textPrimary,
                                ),
                                decoration: InputDecoration(
                                  hintText: context.tr('search_bookmarks'),
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    color: context.textSecondary,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    size: 18,
                                    color: context.textSecondary,
                                  ),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? GestureDetector(
                                          onTap: () {
                                            _searchController.clear();
                                            context
                                                .read<BookmarkCubit>()
                                                .updateSearch('');
                                          },
                                          child: Icon(
                                            Icons.close_rounded,
                                            size: 16,
                                            color: context.textSecondary,
                                          ),
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (state.totalCount > 0) ...[
                            const SizedBox(width: 10),
                            ZoomTapAnimation(
                              onTap: () => _confirmClearAll(context),
                              child: Container(
                                height: 46,
                                width: 46,
                                decoration: BoxDecoration(
                                  color: AppTheme.errorColor.withValues(
                                    alpha: isDark ? 0.15 : 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppTheme.errorColor.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: AppTheme.errorColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Filter Segment Tabs Bar
                      Row(
                        children: [
                          _buildTabChip(
                            context,
                            label: '${context.tr('all')} (${state.totalCount})',
                            tab: BookmarkTab.all,
                            isSelected: state.activeTab == BookmarkTab.all,
                          ),
                          const SizedBox(width: 8),
                          _buildTabChip(
                            context,
                            label: '${context.tr('videos')} (${state.videos.length})',
                            tab: BookmarkTab.videos,
                            isSelected: state.activeTab == BookmarkTab.videos,
                          ),
                          const SizedBox(width: 8),
                          _buildTabChip(
                            context,
                            label: '${context.tr('articles')} (${state.articles.length})',
                            tab: BookmarkTab.articles,
                            isSelected: state.activeTab == BookmarkTab.articles,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Bookmarks Content ─────────────────────────────────
              if (state.totalCount == 0 || _isTabEmpty(state))
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(context),
                )
              else ...[
                // Videos Section
                if (state.activeTab == BookmarkTab.all ||
                    state.activeTab == BookmarkTab.videos) ...[
                  if (state.filteredVideos.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 14,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              context.tr('saved_videos'),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: context.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.86,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final video = state.filteredVideos[index];
                          return VideoCard(
                            video: video,
                            width: double.infinity,
                            onTap: () => context.push(
                              '/videos/detail/${video.id}',
                              extra: video,
                            ),
                            onBookmarkTap: () =>
                                context.read<BookmarkCubit>().loadBookmarks(),
                          ).animate().fadeIn(duration: 200.ms);
                        }, childCount: state.filteredVideos.length),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 18)),
                  ],
                ],

                // Articles Section
                if (state.activeTab == BookmarkTab.all ||
                    state.activeTab == BookmarkTab.articles) ...[
                  if (state.filteredArticles.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 14,
                              decoration: BoxDecoration(
                                color: context.accentBlue,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              context.tr('saved_articles'),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: context.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final article = state.filteredArticles[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ArticleCard(
                              article: article,
                              onTap: () => context.push(
                                '/articles/detail/${article.id}',
                                extra: article,
                              ),
                            ).animate().fadeIn(duration: 200.ms),
                          );
                        }, childCount: state.filteredArticles.length),
                      ),
                    ),
                  ],
                ],
              ],

              const SliverPadding(padding: EdgeInsets.only(bottom: 110)),
            ],
          ],
        );
      },
    );
  }

  bool _isTabEmpty(BookmarkLoaded state) {
    if (state.activeTab == BookmarkTab.videos) {
      return state.filteredVideos.isEmpty;
    }
    if (state.activeTab == BookmarkTab.articles) {
      return state.filteredArticles.isEmpty;
    }
    return state.filteredVideos.isEmpty && state.filteredArticles.isEmpty;
  }

  Widget _buildTabChip(
    BuildContext context, {
    required String label,
    required BookmarkTab tab,
    required bool isSelected,
  }) {
    final isDark = context.theme.brightness == Brightness.dark;

    return ZoomTapAnimation(
      onTap: () => context.read<BookmarkCubit>().changeTab(tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (tab == BookmarkTab.articles
                    ? context.accentBlue
                    : AppTheme.primaryColor)
              : (isDark ? AppTheme.darkCard : AppTheme.lightCard),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color:
                        (tab == BookmarkTab.articles
                                ? context.accentBlue
                                : AppTheme.primaryColor)
                            .withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? (tab == BookmarkTab.articles ? Colors.white : Colors.black)
                : context.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return AppEmptyWidget(
      icon: Icons.bookmark_border_rounded,
      title: context.tr('no_bookmarks_title'),
      subtitle: context.tr('no_bookmarks_subtitle'),
      actionLabel: context.tr('browse_content'),
      onAction: () => context.go('/videos'),
      iconColor: AppTheme.primaryColor,
    );
  }

  void _confirmClearAll(BuildContext context) {
    AppDialog.showConfirmDialog(
      context,
      title: context.tr('clear_bookmarks'),
      content: context.tr('clear_bookmarks_confirm'),
      confirmText: context.tr('confirm'),
      cancelText: context.tr('cancel'),
      confirmColor: AppTheme.errorColor,

      onConfirm: () async {
        context.read<BookmarkCubit>().clearAll();
        context.pop();
        if (context.mounted) {
          context.showInfoSnackBar(context.tr('clear_bookmarks'));
        }
      },
    );
  }
}
