import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/utils/extension.dart';
import 'package:haditv/core/utils/share.dart';
import 'package:haditv/core/utils/url_launcher.dart';
import 'package:haditv/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:haditv/features/settings/presentation/cubit/settings_state.dart';
import 'package:haditv/gen/assets.gen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final String currentRoute = GoRouterState.of(context).uri.toString();
    final width = MediaQuery.sizeOf(context).width * 0.82;

    return Drawer(
      width: width.clamp(280.0, 340.0),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          // ── Glassmorphic Backdrop ──────────────────────────────────
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: isDark
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF0F172A),
                          Color(0xFF1E293B),
                          Color(0xFF0F172A),
                        ],
                      )
                    : const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFFFFFF),
                          Color(0xFFF8FAFC),
                          Color(0xFFF1F5F9),
                        ],
                      ),
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(32),
                ),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.06),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.5 : 0.15),
                    blurRadius: 30,
                    offset: const Offset(10, 0),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // ── Header Section ─────────────────────────────────────
                    _DrawerHeader(isDark: isDark),

                    const SizedBox(height: 12),

                    // ── Scrollable Menu ────────────────────────────────────
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          // Section: NAVIGATION
                          _SectionHeader(
                            title: context.tr('main_navigation'),
                            icon: Icons.explore_outlined,
                          ).animate().fadeIn(duration: 200.ms),

                          const SizedBox(height: 6),

                          _DrawerMenuItem(
                                icon: Icons.home_outlined,
                                activeIcon: Icons.home_rounded,
                                label: 'home',
                                route: '/home',
                                isSelected:
                                    currentRoute == '/home' ||
                                    currentRoute == '/',
                              )
                              .animate()
                              .fadeIn(delay: 40.ms)
                              .slideX(begin: -0.15, end: 0),

                          _DrawerMenuItem(
                                icon: Icons.live_tv_outlined,
                                activeIcon: Icons.live_tv_rounded,
                                label: 'live_tv',
                                badgeText: context.tr('live_badge'),
                                badgeColor: const Color(0xFFEF4444),
                                route: '/live',
                                isSelected: currentRoute.startsWith('/live'),
                              )
                              .animate()
                              .fadeIn(delay: 80.ms)
                              .slideX(begin: -0.15, end: 0),

                          _DrawerMenuItem(
                                icon: Icons.play_circle_outline_rounded,
                                activeIcon: Icons.play_circle_fill_rounded,
                                label: 'videos',
                                route: '/videos',
                                isSelected: currentRoute.startsWith('/videos'),
                              )
                              .animate()
                              .fadeIn(delay: 120.ms)
                              .slideX(begin: -0.15, end: 0),

                          _DrawerMenuItem(
                                icon: Icons.article_outlined,
                                activeIcon: Icons.article_rounded,
                                label: 'articles',
                                route: '/articles',
                                isSelected: currentRoute.startsWith(
                                  '/articles',
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 160.ms)
                              .slideX(begin: -0.15, end: 0),

                          _DrawerMenuItem(
                                icon: Icons.search_rounded,
                                activeIcon: Icons.search_rounded,
                                label: 'search',
                                route: '/search',
                                isSelected: currentRoute.startsWith('/search'),
                              )
                              .animate()
                              .fadeIn(delay: 200.ms)
                              .slideX(begin: -0.15, end: 0),

                          const SizedBox(height: 20),

                          // Section: MY CONTENT
                          _SectionHeader(
                            title: context.tr('my_content'),
                            icon: Icons.bookmark_border_rounded,
                          ).animate().fadeIn(delay: 220.ms),

                          const SizedBox(height: 6),

                          _DrawerMenuItem(
                                icon: Icons.bookmarks_outlined,
                                activeIcon: Icons.bookmarks_rounded,
                                label: 'bookmarks',
                                route: '/bookmarks',
                                isSelected: currentRoute.startsWith(
                                  '/bookmarks',
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 240.ms)
                              .slideX(begin: -0.15, end: 0),

                          const SizedBox(height: 20),

                          // Section: PREFERENCES
                          _SectionHeader(
                            title: context.tr('preferences'),
                            icon: Icons.tune_rounded,
                          ).animate().fadeIn(delay: 260.ms),

                          const SizedBox(height: 6),

                          _DrawerMenuItem(
                                icon: Icons.settings_outlined,
                                activeIcon: Icons.settings_rounded,
                                label: 'settings',
                                route: '/settings',
                                isSelected: currentRoute.startsWith(
                                  '/settings',
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 280.ms)
                              .slideX(begin: -0.15, end: 0),

                          // Theme Toggle Tile
                          const _ThemeToggleTile()
                              .animate()
                              .fadeIn(delay: 320.ms)
                              .slideX(begin: -0.15, end: 0),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),

                    // ── Footer Section ─────────────────────────────────────
                    _DrawerFooter(isDark: isDark)
                        .animate()
                        .fadeIn(delay: 360.ms)
                        .slideY(begin: 0.2, end: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _DrawerHeader extends StatelessWidget {
  final bool isDark;

  const _DrawerHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 14, 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.03)
            : Colors.black.withOpacity(0.02),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.06),
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo & Glowing ring
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withOpacity(0.4),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Container(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                padding: const EdgeInsets.all(6),
                child: Assets.images.coHaditv512.image(width: 32, height: 32),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Title & Live Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hadi TV',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: context.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      context.tr('official_network'),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: context.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Close Button with ZoomTapAnimation
          ZoomTapAnimation(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.05),
              ),
              child: Icon(
                Icons.close_rounded,
                size: 18,
                color: context.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
      child: Row(
        children: [
          Icon(icon, size: 13, color: AppTheme.primaryColor),
          const SizedBox(width: 6),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryColor,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  final bool isSelected;
  final String? badgeText;
  final Color? badgeColor;

  const _DrawerMenuItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
    required this.isSelected,
    this.badgeText,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ZoomTapAnimation(
        onTap: () {
          Navigator.of(context).pop(); // Close drawer
          if (!isSelected) {
            context.go(route);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.2),
                      AppTheme.primaryColor.withOpacity(0.08),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryColor.withOpacity(0.5)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Active Dot & Icon
              Icon(
                isSelected ? activeIcon : icon,
                size: 20,
                color: isSelected
                    ? AppTheme.primaryColor
                    : context.textSecondary,
              ),
              const SizedBox(width: 12),

              // Label
              Expanded(
                child: Text(
                  context.tr(label),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? context.textPrimary
                        : context.textSecondary,
                  ),
                ),
              ),

              // Optional Badge
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor ?? AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText!,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

              // Arrow indicator for selected item
              if (isSelected)
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
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

class _ThemeToggleTile extends StatelessWidget {
  const _ThemeToggleTile();

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.04)
                : Colors.black.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.black.withOpacity(0.05),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                size: 20,
                color: isDark
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFF6366F1),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isDark ? context.tr('dark_mode') : context.tr('light_mode'),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
              ),
              Switch.adaptive(
                value: isDark,
                activeThumbColor: Colors.white,
                activeTrackColor: AppTheme.primaryColor,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: isDark
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.15),
                onChanged: (val) {
                  final cubit = context.read<SettingsCubit>();
                  cubit.changeTheme(val ? 'dark' : 'light');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _DrawerFooter extends StatelessWidget {
  final bool isDark;

  const _DrawerFooter({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.02)
            : Colors.black.withOpacity(0.02),
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.06),
          ),
        ),
      ),
      child: Column(
        children: [
          // Social links row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialIconButton(
                icon: Icons.language_rounded,
                onTap: () {
                  LaunchUrlService.urlOpener(context, 'https://haditv.co.uk/');
                },
              ),

              const SizedBox(width: 12),
              _SocialIconButton(
                icon: Icons.share_rounded,
                onTap: () {
                  ShareHelper.shareApp(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Version tag
          TextButton(
            onPressed: () =>
                LaunchUrlService.urlOpener(context, 'http://dijlah.org/'),
            child: Text(
              'Dijlah - IT',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                decoration: TextDecoration.underline,
                color: context.accentBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return ZoomTapAnimation(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.05),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.06),
          ),
        ),
        child: Icon(icon, size: 16, color: context.textPrimary),
      ),
    );
  }
}
