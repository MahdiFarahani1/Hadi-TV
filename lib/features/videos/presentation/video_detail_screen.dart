import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/di/injection.dart';
import 'package:haditv/core/utils/data_formatter.dart';
import 'package:haditv/core/utils/extension.dart';
import 'package:haditv/core/utils/share.dart';
import 'package:haditv/core/widgets/skeleton.dart';
import 'package:haditv/core/widgets/snackbar_common.dart';
import 'package:haditv/core/widgets/video_card.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_state.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/videos/domain/usecases/get_videos_usecase.dart';
import 'package:haditv/features/volume/presentation/widgets/inline_volume_slider.dart';
import 'cubit/video_detail_cubit.dart';
import 'cubit/video_detail_state.dart';
import 'widgets/video_detail_skeleton.dart';
import 'widgets/video_player_widget.dart';

class VideoDetailScreen extends StatelessWidget {
  final Video video;

  const VideoDetailScreen({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          VideoDetailCubit(getVideosUseCase: getIt<GetVideosUseCase>())
            ..loadVideo(video),
      child: const Scaffold(body: VideoDetailView()),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class VideoDetailView extends StatelessWidget {
  const VideoDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoDetailCubit, VideoDetailState>(
      builder: (context, state) {
        if (state is VideoDetailLoading) {
          return const Scaffold(body: VideoDetailSkeleton());
        } else if (state is VideoDetailError) {
          return Scaffold(
            body: Center(
              child: Text(
                state.message,
                style: GoogleFonts.plusJakartaSans(color: context.textPrimary),
              ),
            ),
          );
        } else if (state is VideoDetailLoaded) {
          return _DetailContent(state: state);
        }
        return const SizedBox();
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _DetailContent extends StatelessWidget {
  final VideoDetailLoaded state;
  const _DetailContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final video = state.video;

    // Check if description exists and is non-empty
    final rawDesc = video.description ?? '';
    final cleanDesc = rawDesc.replaceAll(RegExp(r'<[^>]*>'), '').trim();
    final hasDescription = cleanDesc.isNotEmpty;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Player with Glassmorphic Floating Back Button ────────
            Stack(
              children: [
                VideoPlayerWidget(videoUrl: video.videoUrl),
                Positioned(
                  top: 12,
                  left: 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isRtl
                                ? Icons.arrow_forward_ios_rounded
                                : Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              Navigator.maybePop(context);
                            }
                          },
                          tooltip: 'Back',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Main Content ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ModernInlineVolumeSlider(),

                  const SizedBox(height: 10),

                  Text(
                        video.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: context.textPrimary,
                          height: 1.35,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 250.ms)
                      .slideY(begin: 0.04, end: 0, duration: 250.ms),

                  const SizedBox(height: 12),

                  // ── Meta Stats Row ─────────────────────────────────
                  Row(
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        size: 14,
                        color: context.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${video.showCounter} ${context.tr('views')}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: context.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: context.textSecondary.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: context.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormatter.formatUnixTimestamp(video.dateTime),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: context.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ── Speaker Tile Card ──────────────────────────────
                  if (video.speakerName.isNotEmpty ||
                      video.speaker.name.isNotEmpty)
                    _SpeakerCard(
                      speakerName: video.speakerName.isNotEmpty
                          ? video.speakerName
                          : video.speaker.name,
                      photoUrl: video.photoUrl.isNotEmpty
                          ? video.photoUrl
                          : (video.speaker.photoUrl ?? ''),
                      isDark: isDark,
                    ).animate().fadeIn(duration: 300.ms),

                  const SizedBox(height: 16),

                  // ── Action Buttons Row ──────────────────────────────
                  Row(
                    children: [
                      _SaveVideoButton(video: video),
                      const SizedBox(width: 12),
                      _ActionButton(
                        icon: Icons.share_rounded,
                        label: context.tr('share'),
                        onTap: () {
                          ShareHelper.shareContent(
                            title: video.title,
                            content: video.videoUrl,
                          );
                        },
                      ),
                    ],
                  ),

                  // ── CONDITIONAL Description Card ───────────────────
                  if (hasDescription) ...[
                    const SizedBox(height: 20),
                    _DescriptionCard(
                      description: cleanDesc,
                      isDark: isDark,
                    ).animate().fadeIn(duration: 300.ms),
                  ],

                  const SizedBox(height: 28),

                  // ── Related Videos Section ─────────────────────────
                  if (state.relatedVideos.isNotEmpty) ...[
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 18,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppTheme.primaryColor,
                                Colors.amberAccent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          context.tr('related_videos'),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: context.textPrimary,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.relatedVideos.length,
                        itemBuilder: (context, index) {
                          final rel = state.relatedVideos[index];
                          return VideoCard(
                                video: rel,
                                onTap: () => context
                                    .read<VideoDetailCubit>()
                                    .loadVideo(rel),
                                onBookmarkTap: () {},
                              )
                              .animate(delay: (index * 40).ms)
                              .fadeIn(duration: 250.ms)
                              .slideX(begin: 0.06, end: 0, duration: 250.ms);
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SpeakerCard extends StatelessWidget {
  final String speakerName;
  final String photoUrl;
  final bool isDark;

  const _SpeakerCard({
    required this.speakerName,
    required this.photoUrl,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl.isNotEmpty && photoUrl.startsWith('http');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppTheme.darkBorder.withOpacity(0.6)
              : AppTheme.lightBorder,
        ),
      ),
      child: Row(
        children: [
          // Speaker Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: hasPhoto
                ? CachedNetworkImage(
                    imageUrl: photoUrl,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const Skeleton(width: 44, height: 44, borderRadius: 12),
                    errorWidget: (_, __, ___) => _buildAvatarFallback(),
                  )
                : _buildAvatarFallback(),
          ),
          const SizedBox(width: 12),

          // Speaker Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  speakerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.tr('speaker'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.person_rounded,
        color: AppTheme.primaryColor,
        size: 24,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primaryColor.withOpacity(0.15)
              : (isDark ? AppTheme.darkCard : AppTheme.lightCard),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive
                ? AppTheme.primaryColor
                : (isDark
                      ? AppTheme.darkBorder.withOpacity(0.6)
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

// ─────────────────────────────────────────────────────────────────────────────

class _DescriptionCard extends StatelessWidget {
  final String description;
  final bool isDark;

  const _DescriptionCard({required this.description, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isLongText = description.length > 120;
    final isExpandedNotifier = ValueNotifier<bool>(false);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? AppTheme.darkBorder.withOpacity(0.6)
              : AppTheme.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: AppTheme.primaryColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                context.tr('description'),
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: context.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder<bool>(
            valueListenable: isExpandedNotifier,
            builder: (context, isExpanded, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedCrossFade(
                    crossFadeState: (isExpanded || !isLongText)
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 250),
                    firstChild: Text(
                      description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: context.textSecondary,
                        height: 1.55,
                      ),
                    ),
                    secondChild: Text(
                      description,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: context.textSecondary,
                        height: 1.55,
                      ),
                    ),
                  ),
                  if (isLongText) ...[
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => isExpandedNotifier.value = !isExpanded,
                      child: Text(
                        isExpanded
                            ? context.tr('show_less')
                            : context.tr('show_more'),
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SaveVideoButton extends StatelessWidget {
  final Video video;
  const _SaveVideoButton({required this.video});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkCubit, BookmarkState>(
      builder: (context, state) {
        final isBookmarked = context.read<BookmarkCubit>().isVideoBookmarked(
          video.id,
        );

        return _ActionButton(
          icon: isBookmarked
              ? Icons.bookmark_rounded
              : Icons.bookmark_border_rounded,
          label: isBookmarked ? context.tr('saved') : context.tr('save'),
          isActive: isBookmarked,
          onTap: () async {
            final saved = await context.read<BookmarkCubit>().toggleVideo(
              video,
            );
            if (context.mounted) {
              context.showInfoSnackBar(
                saved
                    ? context.tr('added_to_bookmarks')
                    : context.tr('removed_from_bookmarks'),
              );
            }
          },
        );
      },
    );
  }
}
