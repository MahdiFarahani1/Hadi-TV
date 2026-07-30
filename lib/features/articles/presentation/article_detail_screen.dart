// lib/features/articles/presentation/pages/article_detail/article_detail_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/di/injection.dart';
import 'package:haditv/core/utils/data_formatter.dart';
import 'package:haditv/core/utils/share.dart';
import 'package:haditv/core/widgets/article_card.dart';
import 'package:haditv/core/widgets/error_widget.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/articles/domain/entities/article_detail.dart';
import 'package:haditv/features/articles/domain/usecases/get_articles_usecase.dart';
import 'package:haditv/features/articles/domain/usecases/get_article_content_usecase.dart';
import 'package:haditv/core/utils/url_launcher.dart';
import 'package:haditv/core/widgets/snackbar_common.dart';
import 'package:haditv/features/articles/presentation/cubit/article_detail/article_detail_state.dart';
import 'package:html_unescape/html_unescape.dart';
import 'cubit/article_detail/article_detail_cubit.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haditv/core/utils/extension.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_state.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'widgets/article_detail_skeleton.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArticleDetailCubit(
        getArticlesUseCase: getIt<GetArticlesUseCase>(),
        getArticleContentUseCase: getIt<GetArticleContentUseCase>(),
      )..loadArticle(article),
      child: Scaffold(body: ArticleDetailView(article: article)),
    );
  }
}

class ArticleDetailView extends StatelessWidget {
  final Article article;
  const ArticleDetailView({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleDetailCubit, ArticleDetailState>(
      builder: (context, state) {
        if (state is ArticleDetailLoading) {
          return const Scaffold(body: ArticleDetailSkeleton());
        } else if (state is ArticleDetailError) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () {
              BlocProvider.of<ArticleDetailCubit>(context).loadArticle(article);
            },
          );
        } else if (state is ArticleDetailLoaded) {
          return _ArticleContent(
            article: state.article,
            relatedArticles: state.relatedArticles,
          );
        }
        return const SizedBox();
      },
    );
  }
}

// Main Article Content
class _ArticleContent extends StatefulWidget {
  final ArticleDetail article;
  final List<Article> relatedArticles;

  const _ArticleContent({required this.article, required this.relatedArticles});

  @override
  State<_ArticleContent> createState() => _ArticleContentState();
}

class _ArticleContentState extends State<_ArticleContent> {
  bool isBookmarked = false;
  String readTime = '';

  @override
  void initState() {
    super.initState();
    readTime = DateFormatter.calculateReadTime(widget.article.content);
    isBookmarked = getIt<BookmarkCubit>().isArticleBookmarked(
      widget.article.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(article, theme),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(article, theme),
                  const SizedBox(height: 16),
                  _buildMetadata(article, theme),
                  const SizedBox(height: 18),
                  _buildActionRow(article, context),
                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 24),
                  _buildArticleContent(article.content, theme),
                  const SizedBox(height: 32),
                  if (article.articleUrl.isNotEmpty) ...[
                    _buildSourceButton(article, context),
                    const SizedBox(height: 36),
                  ],
                  if (widget.relatedArticles.isNotEmpty) ...[
                    _buildRelatedArticlesSection(widget.relatedArticles),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(ArticleDetail article, ThemeData theme) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SliverAppBar(
        expandedHeight: 340,
        pinned: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: _buildGlassIconButton(
          icon: Icons.arrow_back_ios_new_rounded,

          onTap: () => Navigator.pop(context),
        ),
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: [
              article.photoUrl.toArticleImage(fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassIconButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 30,
            height: 30,
            color: Colors.black.withOpacity(0.25),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(icon, color: color, size: 20),
              onPressed: onTap,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(ArticleDetail article, ThemeData theme) {
    return Text(
      article.title,
      style: theme.textTheme.headlineMedium?.copyWith(
        height: 1.3,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildMetadata(ArticleDetail article, ThemeData theme) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 15,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
            const SizedBox(width: 6),
            Text(
              article.createdAt.toString().split(
                ' ',
              )[0], // Adjust with your formatter
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.schedule_rounded,
              size: 16,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              readTime.isEmpty ? '3 ${context.tr('min_read')}' : readTime,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.visibility_outlined,
              size: 16,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
            const SizedBox(width: 6),
            Text(
              '1.2k ${context.tr('views')}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArticleContent(String rawContent, ThemeData theme) {
    if (rawContent.isEmpty) {
      return Center(child: Text(context.tr('no_content_subtitle')));
    }

    final unescape = HtmlUnescape();
    String decodedHtml = unescape.convert(rawContent);

    decodedHtml = decodedHtml
        .replaceAll(RegExp(r'style="[^"]*"', caseSensitive: false), '')
        .replaceAll(RegExp(r"style='[^']*'", caseSensitive: false), '')
        .replaceAll('&rlm;', '')
        .replaceAll('&lrm;', '');

    return HtmlWidget(
      decodedHtml,
      textStyle: theme.textTheme.bodyLarge?.copyWith(
        fontSize: 16.5,
        height: 1.8,
      ),
      customStylesBuilder: (element) {
        if (element.localName == 'a') {
          return {
            'color': '#1E88E5',
            'text-decoration': 'none',
            'font-weight': 'bold',
          };
        }
        return null;
      },
      onTapUrl: (url) async {
        LaunchUrlService.urlOpener(context, url);
        return true;
      },
    );
  }

  Widget _buildActionRow(ArticleDetail article, BuildContext context) {
    final articleEntity = Article(
      id: article.id,
      categoryId: article.categoryId,
      title: article.title,
      photoUrl: article.photoUrl,
      readTime: readTime,
      articleDate: article.createdAt,
      articleUrl: article.articleUrl,
    );

    return BlocBuilder<BookmarkCubit, BookmarkState>(
      builder: (context, state) {
        final isBookmarked = context.read<BookmarkCubit>().isArticleBookmarked(
          article.id,
        );

        return Row(
          children: [
            _ActionButton(
              icon: isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              label: isBookmarked ? context.tr('saved') : context.tr('save'),
              isActive: isBookmarked,
              onTap: () async {
                final added = await context.read<BookmarkCubit>().toggleArticle(
                  articleEntity,
                );
                if (context.mounted) {
                  context.showInfoSnackBar(
                    added
                        ? context.tr('added_to_bookmarks')
                        : context.tr('removed_from_bookmarks'),
                  );
                }
              },
            ),
            const SizedBox(width: 12),
            _ActionButton(
              icon: Icons.share_rounded,
              label: context.tr('share'),
              onTap: () {
                ShareHelper.shareContent(
                  title: article.title,
                  content: article.articleUrl,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSourceButton(ArticleDetail article, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final softBlueBg = isDark
        ? AppTheme.accentBlue.withValues(alpha: 0.18)
        : AppTheme.accentBlue.withValues(alpha: 0.10);
    final softBlueBorder = AppTheme.accentBlue.withValues(alpha: 0.3);
    final textColor = isDark
        ? AppTheme.accentBlueLight
        : AppTheme.accentBlueDark;

    return ZoomTapAnimation(
      onTap: () => LaunchUrlService.urlOpener(context, article.articleUrl),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: softBlueBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: softBlueBorder, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.open_in_new_rounded, size: 18, color: textColor),
            const SizedBox(width: 8),
            Text(
              context.tr('read_original_source'),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedArticlesSection(List<Article> relatedArticles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('related_articles'),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: context.screenHeight * 0.18,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: relatedArticles.length,
            itemBuilder: (context, index) {
              final rel = relatedArticles[index];
              return ArticleCard(
                article: rel,
                onTap: () {
                  context.read<ArticleDetailCubit>().loadArticle(rel);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return ZoomTapAnimation(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primaryColor.withValues(alpha: 0.15)
              : (isDark ? AppTheme.darkCard : AppTheme.lightCard),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive
                ? AppTheme.primaryColor
                : (isDark
                      ? AppTheme.darkBorder.withValues(alpha: 0.6)
                      : AppTheme.lightBorder),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppTheme.primaryColor : context.textPrimary,
              size: 17,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: isActive ? AppTheme.primaryColor : context.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
