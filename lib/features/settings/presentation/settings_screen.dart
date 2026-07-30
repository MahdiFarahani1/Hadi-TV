import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haditv/config/version/app_version.dart';
import 'package:haditv/core/utils/url_launcher.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/utils/extension.dart';
import 'package:haditv/core/widgets/dialog_common.dart';
import 'package:haditv/core/widgets/error_widget.dart';
import 'package:haditv/core/widgets/header.dart';
import 'package:haditv/core/widgets/skeleton.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:haditv/features/settings/domain/entities/language.dart';
import 'package:haditv/core/widgets/snackbar_common.dart';
import 'cubit/settings_cubit.dart';
import 'cubit/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _SettingsView());
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return switch (state) {
          SettingsLoading() => const SettingsScreenSkeleton(),
          SettingsError(:final message) => CustomErrorWidget(
            message: message,
            onRetry: () => context.read<SettingsCubit>().loadSettings(),
          ),
          SettingsLoaded(
            :final settings,
            :final languages,
            :final selectedLanguageCode,
            :final themeMode,
          ) =>
            _buildContent(
              context,
              SettingsLoaded(
                settings: settings,
                languages: languages,
                selectedLanguageCode: selectedLanguageCode,
                themeMode: themeMode,
              ),
            ),
          _ => const SettingsScreenSkeleton(),
        };
      },
    );
  }

  // ── Loaded content ────────────────────────────────────────────────────────

  Widget _buildContent(BuildContext context, SettingsLoaded state) {
    final socialLinks = state.settings.activeSocialLinks;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        MainHeader(
          pageName: 'Settings',
          extraWidget: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              state.selectedLanguage.abbr.toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                color: AppTheme.primaryColor,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 24),

              // ── PREFERENCES ─────────────────────────────────────────────
              _GroupLabel(label: context.tr('preferences')),

              _SettingTile(
                    icon: Icons.language_rounded,
                    iconColor: AppTheme.primaryColor,
                    title: context.tr('app_language'),
                    subtitle: context.tr('select_language'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        state.selectedLanguage.displayName,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    onTap: () => _showLanguageBottomSheet(context, state),
                  )
                  .animate(delay: 50.ms)
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.08, end: 0),

              _SwitchTile(
                    icon: Icons.dark_mode_rounded,
                    iconColor: AppTheme.primaryColor,
                    title: context.tr('dark_mode'),
                    subtitle: context.tr('appearance'),
                    value: state.themeMode == 'dark',
                    onChanged: (val) => context
                        .read<SettingsCubit>()
                        .changeTheme(val ? 'dark' : 'light'),
                  )
                  .animate(delay: 80.ms)
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.08, end: 0),

              const SizedBox(height: 8),

              // ── STORAGE ──────────────────────────────────────────────────
              _GroupLabel(label: context.tr('storage')),

              _SettingTile(
                    icon: Icons.cleaning_services_rounded,
                    iconColor: AppTheme.primaryColor,
                    title: context.tr('clear_cache'),
                    subtitle: context.tr('clear_cache_success'),
                    trailing: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppTheme.primaryColor,
                      size: 18,
                    ),
                    onTap: () => _showClearCacheDialog(context),
                  )
                  .animate(delay: 110.ms)
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.08, end: 0),

              // ── SOCIAL ──────────────────────────────────────────────────
              if (socialLinks.isNotEmpty) ...[
                const SizedBox(height: 8),
                _GroupLabel(label: context.tr('social_links')),
                ...socialLinks.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final link = entry.value;
                  return _SettingTile(
                        icon: _socialIcon(link.icon),
                        iconColor: _socialColor(link.icon),
                        title: link.label,
                        subtitle: link.url,
                        trailing: const Icon(
                          Icons.open_in_new_rounded,
                          size: 16,
                        ),
                        onTap: () =>
                            LaunchUrlService.urlOpener(context, link.url),
                      )
                      .animate(delay: Duration(milliseconds: 140 + idx * 30))
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: 0.08, end: 0);
                }),
              ],

              const SizedBox(height: 28),

              // ── App version ───────────────────────────────────────────
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: context.cardBorder),
                  ),
                  child: Text(
                    'Hadi TV  ·  ${AppVersion.instance.fullVersion}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: context.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ).animate(delay: 280.ms).fadeIn(duration: 300.ms),
            ]),
          ),
        ),
      ],
    );
  }

  // ── Language bottom sheet ─────────────────────────────────────────────────

  void _showLanguageBottomSheet(BuildContext context, SettingsLoaded state) {
    showModalBottomSheet(
      useRootNavigator: true,

      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LanguageBottomSheet(state: state),
    );
  }

  // ── Clear cache dialog ────────────────────────────────────────────────────

  void _showClearCacheDialog(BuildContext context) {
    AppDialog.showWarningDialog(
      context,
      title: context.tr('clear_cache_title'),
      message: context.tr('clear_cache_confirm'),
      confirmText: context.tr('clear_cache_button'),
      cancelText: context.tr('cancel'),
      onConfirm: () async {
        context.read<SettingsCubit>().clearAllCache();
        context.read<BookmarkCubit>().clearAll();
        context.pop();

        if (context.mounted) {
          context.showSuccessSnackBar(context.tr('clear_cache_success'));
        }
      },
    );
  }

  // ── Social helpers ────────────────────────────────────────────────────────

  IconData _socialIcon(String icon) => switch (icon) {
    'youtube' => Icons.play_circle_filled_rounded,
    'instagram' => Icons.camera_alt_rounded,
    'telegram' => Icons.send_rounded,
    'facebook' => Icons.facebook_rounded,
    'twitter' => Icons.alternate_email_rounded,
    'whatsapp' => Icons.chat_rounded,
    'aparat' => Icons.video_library_rounded,
    _ => Icons.link_rounded,
  };

  Color _socialColor(String icon) => switch (icon) {
    'youtube' => const Color(0xFFFF0000),
    'instagram' => const Color(0xFFE1306C),
    'telegram' => const Color(0xFF2AABEE),
    'facebook' => const Color(0xFF1877F2),
    'twitter' => const Color(0xFF1DA1F2),
    'whatsapp' => const Color(0xFF25D366),
    'aparat' => const Color(0xFFE1241C),
    _ => AppTheme.primaryColor,
  };
}

// ─────────────────────────────────────────────────────────────────────────────

class _GroupLabel extends StatelessWidget {
  final String label;
  const _GroupLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: AppTheme.primaryColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            color: context.textSecondary,
          ),
        ),
        trailing:
            trailing ??
            Icon(
              Icons.chevron_right_rounded,
              color: context.textSecondary,
              size: 20,
            ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final void Function(bool) onChanged;

  const _SwitchTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            color: context.textSecondary,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.black,
          activeTrackColor: AppTheme.primaryColor,
          inactiveTrackColor: isDark
              ? AppTheme.darkBorder
              : AppTheme.lightBorder,
          inactiveThumbColor: isDark
              ? AppTheme.textMuted
              : AppTheme.textDarkMuted,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Language bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _LanguageBottomSheet extends StatelessWidget {
  final SettingsLoaded state;
  const _LanguageBottomSheet({required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final filteredNotifier = ValueNotifier<List<Language>>(
      List.from(state.languages),
    );

    void filter(String q) {
      filteredNotifier.value = state.languages
          .where(
            (l) =>
                l.title.toLowerCase().contains(q.toLowerCase()) ||
                l.mainTitle.contains(q) ||
                l.abbr.toLowerCase().contains(q.toLowerCase()),
          )
          .toList();
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.darkCard.withValues(alpha: 0.97)
                  : AppTheme.lightCard.withValues(alpha: 0.98),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              border: Border.all(
                color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
              ),
            ),
            child: Column(
              children: [
                // Handle
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.language_rounded,
                        color: AppTheme.primaryColor,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        context.tr('select_language'),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: context.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${state.languages.length}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Search field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onChanged: filter,
                    style: GoogleFonts.plusJakartaSans(
                      color: context.textPrimary,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: context.tr('search_language'),
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: context.textSecondary,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: context.textSecondary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: isDark
                          ? AppTheme.darkBg.withValues(alpha: 0.6)
                          : AppTheme.lightBg.withValues(alpha: 0.6),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Language list
                Expanded(
                  child: ValueListenableBuilder<List<Language>>(
                    valueListenable: filteredNotifier,
                    builder: (context, filteredList, _) {
                      return ListView.builder(
                        controller: scrollCtrl,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        itemCount: filteredList.length,
                        itemBuilder: (_, i) {
                          final lang = filteredList[i];
                          final isSelected =
                              lang.abbr.toUpperCase() ==
                              state.selectedLanguageCode.toUpperCase();

                          return _LanguageTile(
                                lang: lang,
                                isSelected: isSelected,
                                onTap: () {
                                  context.read<SettingsCubit>().changeLanguage(
                                    lang.abbr,
                                  );
                                  context.pop();
                                },
                              )
                              .animate(delay: Duration(milliseconds: i * 18))
                              .fadeIn(duration: 200.ms)
                              .slideX(begin: 0.04, end: 0);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final Language lang;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.lang,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.12)
              : (isDark
                    ? AppTheme.darkBg.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.7)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor.withValues(alpha: 0.4)
                : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // RTL/LTR indicator chip
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryColor.withValues(alpha: 0.2)
                    : (isDark
                          ? AppTheme.darkCard
                          : AppTheme.lightBorder.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  lang.abbr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isSelected
                        ? AppTheme.primaryColor
                        : context.textSecondary,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.displayName,
                    style: GoogleFonts.plusJakartaSans(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : context.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  if (lang.mainTitle.trim().isNotEmpty &&
                      lang.mainTitle != lang.title)
                    Text(
                      lang.title,
                      style: GoogleFonts.plusJakartaSans(
                        color: context.textSecondary,
                        fontSize: 11.5,
                      ),
                    ),
                ],
              ),
            ),

            // Direction badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                lang.isRtl ? 'RTL' : 'LTR',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Check
            AnimatedOpacity(
              opacity: isSelected ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
