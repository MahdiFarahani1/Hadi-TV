import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/widgets/snackbar_common.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/core/utils/extension.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_state.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const ArticleCard({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return ZoomTapAnimation(
      onTap: onTap,
      child: Container(
        width: 320,
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: isRtl
              ? context.headerGradient
              : context.bottomNavBarGradient,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ─── Thumbnail ─────────────────────────────────────────
            _buildThumbnail(context, isDark),
            const SizedBox(width: 12),

            // ─── Content Area ──────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Row: Category tag + Bookmark
                  Row(
                    children: [
                      // Category Pill Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accentBlue.withValues(
                            alpha: isDark ? 0.18 : 0.10,
                          ),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppTheme.accentBlue.withValues(alpha: 0.3),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          context.tr('article_tag'),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppTheme.accentBlueLight
                                : AppTheme.accentBlueDark,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),

                      const Spacer(),
                      // Bookmark action button
                      BlocBuilder<BookmarkCubit, BookmarkState>(
                        builder: (context, state) {
                          final bool isBookmarked = context
                              .read<BookmarkCubit>()
                              .isArticleBookmarked(article.id);
                          return ZoomTapAnimation(
                            onTap: () async {
                              final added = await context
                                  .read<BookmarkCubit>()
                                  .toggleArticle(article);

                              if (!context.mounted) return;

                              context.showInfoSnackBar(
                                added
                                    ? context.tr('added_to_bookmarks')
                                    : context.tr('removed_from_bookmarks'),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: context.textSecondary.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                isBookmarked
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_border_rounded,
                                color: isBookmarked
                                    ? AppTheme.primaryColor
                                    : context.textSecondary,
                                size: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Title with adaptive Cairo font
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cairo(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: context.textPrimary,
                      height: 1.35,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Footer Row (Date & External Link indicator)
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 11,
                        color: AppTheme.accentBlue,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          article.articleDate,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: context.textSecondary,
                          ),
                        ),
                      ),
                      if (article.articleUrl.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,

                          size: 12,
                          color: AppTheme.accentBlue,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context, bool isDark) {
    return Stack(
      children: [
        article.photoUrl.toArticleImage(
          width: 88,
          height: 88,
          borderRadius: BorderRadius.circular(14),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
