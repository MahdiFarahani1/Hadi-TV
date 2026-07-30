import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/di/injection.dart';
import 'package:haditv/core/widgets/article_card.dart';
import 'package:haditv/core/widgets/empty_widget.dart';
import 'package:haditv/core/widgets/video_card.dart';
import 'package:haditv/core/utils/extension.dart';
import 'cubit/search_cubit.dart';
import 'cubit/search_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchCubit>(),
      child: const Scaffold(body: SearchView()),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _queryController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isNotEmpty) {
      context.read<SearchCubit>().performSearch(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchHeader(context, isDark),

          // ── Body ─────────────────────────────────────────────────────
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  );
                } else if (state is SearchError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: GoogleFonts.plusJakartaSans(
                        color: context.textPrimary,
                      ),
                    ),
                  );
                } else if (state is SearchInitial) {
                  return _buildRecentSearches(context, state.recentSearches);
                } else if (state is SearchLoaded) {
                  if (state.videos.isEmpty && state.articles.isEmpty) {
                    return _buildEmptyResults(context);
                  }
                  return _buildResults(context, state);
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── Search Header ──────────────────────────────────────────────────────

  Widget _buildSearchHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.darkBg.withOpacity(0.95)
            : AppTheme.lightBg.withOpacity(0.98),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: context.textPrimary,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Search field
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkCard : AppTheme.lightSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                ),
              ),
              child: TextField(
                controller: _queryController,
                focusNode: _focusNode,
                textInputAction: TextInputAction.search,
                onSubmitted: _onSearch,
                style: GoogleFonts.plusJakartaSans(
                  color: context.textPrimary,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: context.tr('search_placeholder'),
                  hintStyle: GoogleFonts.plusJakartaSans(
                    color: context.textSecondary,
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: context.textSecondary,
                    size: 20,
                  ),
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _queryController,
                    builder: (_, val, __) => val.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _queryController.clear();
                              context.read<SearchCubit>().loadRecents();
                            },
                            child: Icon(
                              Icons.close_rounded,
                              color: context.textSecondary,
                              size: 18,
                            ),
                          )
                        : const SizedBox(),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms);
  }

  // ─── Recent Searches ─────────────────────────────────────────────────────

  Widget _buildRecentSearches(BuildContext context, List<String> recents) {
    if (recents.isEmpty) {
      return AppEmptyWidget.search(context: context, query: '');
    }

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('recent_searches'),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => context.read<SearchCubit>().clearRecents(),
                child: Text(
                  context.tr('clear_all'),
                  style: GoogleFonts.plusJakartaSans(
                    color: AppTheme.errorColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recents.asMap().entries.map((entry) {
              final query = entry.value;
              return GestureDetector(
                    onTap: () {
                      _queryController.text = query;
                      _onSearch(query);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: context.cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.cardBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.history_rounded,
                            size: 13,
                            color: context.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            query,
                            style: GoogleFonts.plusJakartaSans(
                              color: context.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate(delay: (entry.key * 50).ms)
                  .fadeIn(duration: 250.ms)
                  .slideY(begin: 0.1, end: 0);
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── Results ─────────────────────────────────────────────────────────────

  Widget _buildResults(BuildContext context, SearchLoaded state) {
    if (state.videos.isEmpty && state.articles.isEmpty) {
      return AppEmptyWidget.search(
        context: context,
        query: state.query,
        onClear: () {
          _queryController.clear();
          context.read<SearchCubit>().loadRecents();
        },
      );
    }
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          if (state.videos.isNotEmpty) ...[
            _buildResultsHeader(context, context.tr('videos'), state.videos.length),
            const SizedBox(height: 12),
            SizedBox(
              height: 195,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.videos.length,
                itemBuilder: (context, index) {
                  final video = state.videos[index];
                  return VideoCard(
                    video: video,
                    onTap: () => context.push(
                      '/videos/detail/${video.id}',
                      extra: video,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],

          if (state.articles.isNotEmpty) ...[
            _buildResultsHeader(context, context.tr('articles'), state.articles.length),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.articles.length,
              itemBuilder: (context, index) {
                final article = state.articles[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ArticleCard(
                    article: article,
                    onTap: () => context.push(
                      '/articles/detail/${article.id}',
                      extra: article,
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultsHeader(BuildContext context, String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: context.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$count',
            style: GoogleFonts.plusJakartaSans(
              color: AppTheme.primaryColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 60,
            color: context.textSecondary.withOpacity(0.35),
          ),
          const SizedBox(height: 16),
          Text(
            context.tr('no_results_found'),
            style: GoogleFonts.plusJakartaSans(
              color: context.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.tr('no_results_sub'),
            style: GoogleFonts.plusJakartaSans(
              color: context.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.9, 0.9)),
    );
  }
}
