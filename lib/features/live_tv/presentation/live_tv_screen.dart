import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/di/injection.dart';
import 'package:haditv/core/widgets/error_widget.dart';
import 'package:haditv/core/widgets/header.dart';
import 'package:haditv/features/live_tv/domain/entities/live_channel.dart';
import 'package:haditv/features/live_tv/domain/usecases/get_live_channels_usecase.dart';
import 'package:haditv/features/live_tv/presentation/widgets/live_tv_skeleton.dart';
import 'package:haditv/features/videos/presentation/widgets/video_player_widget.dart';
import 'package:haditv/core/utils/extension.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'cubit/live_tv_cubit.dart';
import 'cubit/live_tv_state.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Screen entry point
// ─────────────────────────────────────────────────────────────────────────────

class LiveTvScreen extends StatelessWidget {
  final LiveChannel? initialChannel;

  const LiveTvScreen({super.key, this.initialChannel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          LiveTvCubit(getIt<GetLiveChannelsUseCase>())
            ..loadChannels(initialChannel: initialChannel),
      child: const Scaffold(body: LiveTvView()),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Root view – handles loading / error / loaded states
// ─────────────────────────────────────────────────────────────────────────────

class LiveTvView extends StatelessWidget {
  const LiveTvView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveTvCubit, LiveTvState>(
      builder: (context, state) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const MainHeader(pageName: 'Live TV', showVolumeSlider: true),
            if (state is LiveTvLoading)
              const SliverToBoxAdapter(child: LiveTvSkeleton())
            else if (state is LiveTvError)
              SliverFillRemaining(
                child: CustomErrorWidget(
                  message: state.message,
                  onRetry: () => context.read<LiveTvCubit>().loadChannels(),
                ),
              )
            else if (state is LiveTvLoaded)
              _LiveTvContent(state: state),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main content – player + info card + channel list
// ─────────────────────────────────────────────────────────────────────────────

class _LiveTvContent extends StatelessWidget {
  final LiveTvLoaded state;
  const _LiveTvContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final selected = state.selectedChannel;
    final liveChannels = state.channels.where((c) => c.isLive).toList();

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Video Player ────────────────────────────────────────────
              if (selected.isLive)
                VideoPlayerWidget(
                  key: ValueKey(state.activeStreamUrl),
                  videoUrl: state.activeStreamUrl,
                )
              else
                _OfflinePlayerPlaceholder(channelName: selected.channelName),

              const SizedBox(height: 16),

              // ── Currently Live Channels Banner ─────────────────────────
              if (liveChannels.isNotEmpty) ...[
                _LiveChannelsBanner(
                  liveChannels: liveChannels,
                  selectedChannel: selected,
                  isDark: isDark,
                  onSelectChannel: (ch) => _onChannelTap(context, ch),
                ),
                const SizedBox(height: 20),
              ],

              // ── Section Title ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.tv_rounded,
                      color: AppTheme.primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.tr('all_tv_channels'),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: context.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${state.channels.length} ${context.tr('available')}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),

        // ── Channels list ───────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final ch = state.channels[index];
              final isSelected = ch.id == selected.id;
              return _ChannelListTile(
                    channel: ch,
                    isSelected: isSelected,
                    isDark: isDark,
                    onTap: ch.isLive ? () => _onChannelTap(context, ch) : null,
                  )
                  .animate(delay: (index * 30).ms)
                  .fadeIn(duration: 250.ms)
                  .slideX(
                    begin: 0.05,
                    end: 0,
                    duration: 250.ms,
                    curve: Curves.easeOutCubic,
                  );
            }, childCount: state.channels.length),
          ),
        ),
      ],
    );
  }

  /// Tapping a channel: if already selected show URL picker, otherwise switch.
  void _onChannelTap(BuildContext context, LiveChannel ch) {
    final cubit = context.read<LiveTvCubit>();
    final current = state;

    if (ch.id == current.selectedChannel.id) {
      // Same channel – show URL picker
      if (ch.streamUrls.length > 1) {
        _showUrlPickerSheet(context, current);
      }
    } else {
      cubit.selectChannel(ch);
      // Auto-show picker if there are multiple URLs
      if (ch.streamUrls.length > 1) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (context.mounted) {
            final newState = context.read<LiveTvCubit>().state;
            if (newState is LiveTvLoaded) {
              _showUrlPickerSheet(context, newState);
            }
          }
        });
      }
    }
  }

  void _showUrlPickerSheet(BuildContext context, LiveTvLoaded loaded) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<LiveTvCubit>(),
        child: _UrlPickerSheet(state: loaded),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Offline placeholder shown instead of the video player
// ─────────────────────────────────────────────────────────────────────────────

class _OfflinePlayerPlaceholder extends StatelessWidget {
  final String channelName;
  const _OfflinePlayerPlaceholder({required this.channelName});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      height: 210,
      color: isDark ? AppTheme.darkCard : AppTheme.lightBg,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: (isDark ? AppTheme.darkSurface : AppTheme.lightSurface),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.tv_off_rounded,
                size: 40,
                color: isDark ? AppTheme.textMuted : AppTheme.textDarkMuted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              channelName,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark ? AppTheme.textMuted : AppTheme.textDarkMuted,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.tr('off_air_subtitle'),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: isDark
                    ? AppTheme.textMuted.withOpacity(0.6)
                    : AppTheme.textDarkMuted.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Now-playing info card
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// URL Picker Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _UrlPickerSheet extends StatelessWidget {
  final LiveTvLoaded state;
  const _UrlPickerSheet({required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final channel = state.selectedChannel;
    final urls = channel.streamUrls;

    return BlocBuilder<LiveTvCubit, LiveTvState>(
      builder: (context, cubitState) {
        final activeIndex = cubitState is LiveTvLoaded
            ? cubitState.selectedUrlIndex
            : state.selectedUrlIndex;

        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: (isDark ? AppTheme.darkCard : AppTheme.lightCard)
                    .withOpacity(0.95),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                border: Border(
                  top: BorderSide(
                    color: (isDark
                        ? AppTheme.darkBorder
                        : AppTheme.lightBorder),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 4),
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.darkBorder
                            : AppTheme.lightBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.stream_rounded,
                            color: AppTheme.primaryColor,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                channel.channelName,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: context.textPrimary,
                                ),
                              ),
                              Text(
                                context.tr('select_server_quality'),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: context.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _LiveBadge(),
                      ],
                    ),
                  ),

                  const Divider(height: 1),
                  const SizedBox(height: 8),

                  // URL list
                  ...urls.asMap().entries.map((entry) {
                    final index = entry.key;
                    final url = entry.value;
                    final isActive = index == activeIndex;

                    return _UrlOptionTile(
                          index: index,
                          url: url,
                          isActive: isActive,
                          isDark: isDark,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            context.read<LiveTvCubit>().selectUrl(index);
                            Navigator.of(context).pop();
                          },
                        )
                        .animate(delay: (index * 60).ms)
                        .fadeIn(duration: 200.ms)
                        .slideY(begin: 0.08, end: 0, duration: 200.ms);
                  }),

                  const SizedBox(height: 16),
                  const SafeArea(child: SizedBox(height: 8)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single URL option row inside the bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _UrlOptionTile extends StatefulWidget {
  final int index;
  final String url;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _UrlOptionTile({
    required this.index,
    required this.url,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_UrlOptionTile> createState() => _UrlOptionTileState();
}

class _UrlOptionTileState extends State<_UrlOptionTile> {
  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isActive
        ? AppTheme.primaryColor.withOpacity(0.08)
        : Colors.transparent;
    final borderColor = widget.isActive
        ? AppTheme.primaryColor.withOpacity(0.3)
        : (widget.isDark ? AppTheme.darkBorder : AppTheme.lightBorder);

    return ZoomTapAnimation(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            // Index number circle
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: widget.isActive
                    ? AppTheme.primaryColor
                    : (widget.isDark
                          ? AppTheme.darkSurface
                          : AppTheme.lightSurface),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${widget.index + 1}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: widget.isActive
                        ? Colors.black
                        : context.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // URL label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${context.tr('server')} ${widget.index + 1}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: widget.isActive
                          ? AppTheme.primaryColor
                          : context.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Active indicator
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: widget.isActive
                  ? Container(
                      key: const ValueKey('active'),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.black,
                        size: 14,
                      ),
                    )
                  : Icon(
                      key: const ValueKey('idle'),
                      Icons.play_circle_outline_rounded,
                      color: context.textSecondary.withOpacity(0.5),
                      size: 22,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Channel list tile
// ─────────────────────────────────────────────────────────────────────────────

class _ChannelListTile extends StatefulWidget {
  final LiveChannel channel;
  final bool isSelected;
  final bool isDark;
  final VoidCallback? onTap;

  const _ChannelListTile({
    required this.channel,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_ChannelListTile> createState() => _ChannelListTileState();
}

class _ChannelListTileState extends State<_ChannelListTile> {
  @override
  Widget build(BuildContext context) {
    final isOffline = !widget.channel.isLive;

    final bgColor = widget.isSelected
        ? AppTheme.primaryColor.withOpacity(0.08)
        : (widget.isDark ? AppTheme.darkCard : AppTheme.lightCard);

    final borderColor = widget.isSelected
        ? AppTheme.primaryColor.withOpacity(0.35)
        : (widget.isDark ? AppTheme.darkBorder : AppTheme.lightBorder);

    // Offline tiles are desaturated
    final contentOpacity = isOffline ? 0.45 : 1.0;

    return ZoomTapAnimation(
      onTap: isOffline ? null : widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Opacity(
          opacity: contentOpacity,
          child: Row(
            children: [
              // Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ColorFiltered(
                  colorFilter: isOffline
                      ? const ColorFilter.matrix([
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0,
                          0,
                          0,
                          1,
                          0,
                        ])
                      : const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        ),
                  child: CachedNetworkImage(
                    imageUrl: widget.channel.logoUrl,
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      width: 46,
                      height: 46,
                      color: widget.isDark
                          ? AppTheme.darkSurface
                          : AppTheme.lightSurface,
                      child: Icon(
                        isOffline
                            ? Icons.tv_off_rounded
                            : Icons.live_tv_rounded,
                        color: isOffline
                            ? AppTheme.textMuted
                            : AppTheme.primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.channel.channelName,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: widget.isSelected
                            ? AppTheme.primaryColor
                            : context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    if (isOffline)
                      Text(
                        context.tr('off_air_status'),
                        maxLines: 1,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: context.textSecondary,
                        ),
                      )
                    else ...[
                      Text(
                        widget.channel.currentProgram.isEmpty
                            ? context.tr('now_playing')
                            : '${context.tr('now')}: ${widget.channel.currentProgram}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: context.textSecondary,
                        ),
                      ),
                      if (widget.channel.upcomingProgram.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          '${context.tr('next_program')}: ${widget.channel.upcomingProgram}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: context.textSecondary.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Trailing
              if (isOffline)
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: (widget.isDark
                        ? AppTheme.darkSurface
                        : AppTheme.lightSurface),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.power_off_rounded,
                    size: 15,
                    color: context.textSecondary.withOpacity(0.5),
                  ),
                )
              else
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: widget.isSelected
                      ? Container(
                          key: const ValueKey('playing'),
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.volume_up_rounded,
                            color: AppTheme.primaryColor,
                            size: 16,
                          ),
                        )
                      : Icon(
                          key: const ValueKey('idle'),
                          Icons.chevron_right_rounded,
                          color: context.textSecondary,
                          size: 20,
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
// Small reusable widgets
// ─────────────────────────────────────────────────────────────────────────────

class _LiveBadge extends StatefulWidget {
  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: AppTheme.liveRedColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: 0.5 + _ctrl.value * 0.5,
              child: const Icon(Icons.circle, color: Colors.white, size: 6),
            ),
            const SizedBox(width: 4),
            Text(
              context.tr('on_air'),
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Banner displaying all currently live channels horizontally
// ─────────────────────────────────────────────────────────────────────────────

class _LiveChannelsBanner extends StatelessWidget {
  final List<LiveChannel> liveChannels;
  final LiveChannel selectedChannel;
  final bool isDark;
  final ValueChanged<LiveChannel> onSelectChannel;

  const _LiveChannelsBanner({
    required this.liveChannels,
    required this.selectedChannel,
    required this.isDark,
    required this.onSelectChannel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Glowing Live Indicator Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.liveRedColor,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.liveRedColor.withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      context.tr('live_now'),
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                context.tr('live_broadcasting'),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal List of Live Cards
        SizedBox(
          height: 114,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: liveChannels.length,
            itemBuilder: (context, index) {
              final ch = liveChannels[index];
              final isSelected = ch.id == selectedChannel.id;

              return _LiveChannelCard(
                channel: ch,
                isSelected: isSelected,
                isDark: isDark,
                onTap: () => onSelectChannel(ch),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LiveChannelCard extends StatelessWidget {
  final LiveChannel channel;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _LiveChannelCard({
    required this.channel,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isSelected
        ? AppTheme.primaryColor.withValues(alpha: 0.12)
        : (isDark ? AppTheme.darkCard : AppTheme.lightCard);

    final borderColor = isSelected
        ? AppTheme.primaryColor
        : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder);

    return ZoomTapAnimation(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 175,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: isSelected ? 1.8 : 1.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: Logo & Live Status Badge
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: channel.logoUrl,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      width: 36,
                      height: 36,
                      color: isDark
                          ? AppTheme.darkSurface
                          : AppTheme.lightSurface,
                      child: const Icon(
                        Icons.live_tv_rounded,
                        color: AppTheme.primaryColor,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.liveRedColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppTheme.liveRedColor.withValues(alpha: 0.4),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: AppTheme.liveRedColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        context.tr('live_badge'),
                        style: GoogleFonts.cairo(
                          color: AppTheme.liveRedColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Bottom: Title & Program Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channel.channelName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppTheme.primaryColor
                        : context.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  channel.currentProgram.isNotEmpty
                      ? channel.currentProgram
                      : context.tr('live_broadcasting_now'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 10.5,
                    color: context.textSecondary,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
