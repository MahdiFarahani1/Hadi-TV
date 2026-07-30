import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/features/home/presentation/navigation_shell.dart';
import 'package:haditv/gen/assets.gen.dart';
import 'package:haditv/core/utils/extension.dart';
import 'package:haditv/features/volume/presentation/widgets/inline_volume_slider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class MainHeader extends StatelessWidget {
  final String pageName;
  final bool showBackButton;
  final bool showVolumeSlider;
  final List<Widget>? actions;
  final Widget? extraWidget;

  const MainHeader({
    super.key,
    required this.pageName,
    this.showBackButton = false,
    this.showVolumeSlider = false,
    this.actions,
    this.extraWidget,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: false,
      expandedHeight: 135.0,
      toolbarHeight: 60.0,
      backgroundColor: isDark
          ? const Color(0xFF0F1624).withValues(alpha: 0.85)
          : Colors.white.withValues(alpha: 0.85),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: (showBackButton || Navigator.canPop(context))
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                size: 18,
              ),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  context.pop();
                }
              },
            )
          : null,
      actions:
          actions ??
          [
            if (showVolumeSlider) ...[
              const ModernInlineVolumeSlider(),
              const SizedBox(width: 8),
            ],
            _ModernCircleButton(
              icon: Icons.search_rounded,
              onTap: () => context.push('/search'),
            ),
            const SizedBox(width: 8),
            _ModernCircleButton(
              icon: Icons.notifications_none_rounded,
              hasBadge: true,
              onTap: () {
                AppSettings.openAppSettings(type: AppSettingsType.notification);
              },
            ),
            const SizedBox(width: 8),
            _ModernCircleButton(
              icon: Icons.menu_rounded,
              onTap: () {
                final isRtl = Directionality.of(context) == TextDirection.rtl;
                if (isRtl) {
                  scaffoldKey.currentState?.openEndDrawer();
                } else {
                  scaffoldKey.currentState?.openDrawer();
                }
              },
            ),
            const SizedBox(width: 16),
          ],
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 14,
            ),
            centerTitle: false,
            title: Text(
              context.tr(pageName.toLowerCase().replaceAll(' ', '_')),
              style: GoogleFonts.plusJakartaSans(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Header Gradient background
                Container(
                  decoration: BoxDecoration(gradient: context.headerGradient),
                ),

                // Ambient glow circle accent
                Positioned(
                  top: -30,
                  right: -20,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? const Color(0xFF38BDF8).withValues(alpha: 0.12)
                          : const Color(0xFF6366F1).withValues(alpha: 0.08),
                    ),
                  ),
                ),

                // Top bar content (Brand identity)
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (showBackButton || Navigator.canPop(context))
                          const SizedBox(width: 32)
                        else ...[
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primaryColor,
                                    AppTheme.primaryColor.withValues(
                                      alpha: 0.4,
                                    ),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  color: isDark
                                      ? const Color(0xFF0F172A)
                                      : Colors.white,
                                  padding: const EdgeInsets.all(4),
                                  child: Assets.images.coHaditv512.image(
                                    width: 26,
                                    height: 26,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Hadi TV",
                            style: GoogleFonts.plusJakartaSans(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (extraWidget != null)
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    bottom: 12,
                    end: 20,
                    child: extraWidget!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModernCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasBadge;

  const _ModernCircleButton({
    required this.icon,
    required this.onTap,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ZoomTapAnimation(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.85),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.18)
                    : Colors.white.withValues(alpha: 0.9),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.2)
                      : const Color(0xFF0F172A).withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
              size: 19,
            ),
          ),
          if (hasBadge)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 8.5,
                height: 8.5,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? Colors.black : Colors.white,
                    width: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
