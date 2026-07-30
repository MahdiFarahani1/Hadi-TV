import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/utils/data_formatter.dart';
import 'package:haditv/core/widgets/snackbar_common.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_state.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/core/utils/extension.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class VideoCard extends StatelessWidget {
  final Video video;
  final VoidCallback onTap;
  final VoidCallback? onBookmarkTap;
  final double width;

  const VideoCard({
    super.key,
    required this.video,
    required this.onTap,
    this.onBookmarkTap,
    this.width = 210,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return ZoomTapAnimation(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Thumbnail ────────────────────────────────────────
            _buildThumbnail(context, isDark),

            const SizedBox(height: 10),

            // ─── Title ────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: context.accentBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cairo(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: context.textPrimary,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            // ─── Meta row ─────────────────────────────────────────
            Row(
              children: [
                Icon(Icons.visibility, size: 10, color: context.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${video.showCounter} ${context.tr('views')}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 8,
                    color: context.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.calendar_today_rounded,
                  size: 10,
                  color: context.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormatter.formatUnixTimestamp(video.dateTime),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 8,
                    color: context.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context, bool isDark) {
    return Stack(
      children: [
        // ── Image ──────────────────────────────────────────────────
        video.photoUrl.toVideoImage(
          width: width,
          height: 120,
          borderRadius: BorderRadius.circular(16),
        ),

        // ── Bottom gradient ────────────────────────────────────────
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.65),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [0.0, 0.6],
                ),
              ),
            ),
          ),
        ),

        // ── Glassmorphic speaker label ──────────────────────────────
        Positioned(
          bottom: 8,
          left: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Colors.black.withValues(alpha: 0.35),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified_user,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      video.speakerName.isEmpty ? 'Hadi TV' : video.speakerName,
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ── Bookmark button ─────────────────────────────────────────
        Positioned(
          top: 6,
          right: 6,
          child: BlocBuilder<BookmarkCubit, BookmarkState>(
            builder: (context, state) {
              final bool isBookmarked = context
                  .read<BookmarkCubit>()
                  .isVideoBookmarked(video.id);
              return ZoomTapAnimation(
                onTap: () async {
                  final added = await context.read<BookmarkCubit>().toggleVideo(
                    video,
                  );

                  if (!context.mounted) return;

                  context.showInfoSnackBar(
                    added
                        ? context.tr('added_to_bookmarks')
                        : context.tr('removed_from_bookmarks'),
                  );
                },

                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded,
                    color: isBookmarked ? AppTheme.primaryColor : Colors.white,
                    size: 16,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
