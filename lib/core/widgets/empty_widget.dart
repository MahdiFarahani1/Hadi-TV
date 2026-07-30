import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/utils/extension.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AppEmptyWidget extends StatelessWidget {
  final IconData? icon;
  final Widget? customIconWidget;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;
  final double iconSize;

  const AppEmptyWidget({
    super.key,
    this.icon,
    this.customIconWidget,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.iconSize = 40,
  });

  /// Static helper for empty search state
  static Widget search({
    Key? key,
    required BuildContext context,
    required String query,
    VoidCallback? onClear,
  }) {
    final hasQuery = query.trim().isNotEmpty;
    return AppEmptyWidget(
      key: key,
      icon: Icons.search_off_rounded,
      title: hasQuery
          ? context.tr('no_results_found')
          : context.tr('search_hadi_tv'),
      subtitle: hasQuery
          ? context.tr('no_results_sub')
          : context.tr('search_hadi_tv_sub'),
      actionLabel: hasQuery ? context.tr('clear_search') : null,
      onAction: hasQuery ? onClear : null,
      iconColor: AppTheme.accentBlue,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final primaryAccent = iconColor ?? AppTheme.primaryColor;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Glowing Animated Icon Badge ─────────────────────────────────
            Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background Ambient Glow Ring
                    Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryAccent.withValues(
                              alpha: isDark ? 0.12 : 0.08,
                            ),
                          ),
                        )
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .scale(
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1.1, 1.1),
                          duration: 2000.ms,
                          curve: Curves.easeInOut,
                        ),

                    // Inner Glassmorphic Container
                    ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          width: 82,
                          height: 82,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryAccent.withValues(
                                  alpha: isDark ? 0.22 : 0.14,
                                ),
                                context.accentBlue.withValues(
                                  alpha: isDark ? 0.12 : 0.06,
                                ),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: primaryAccent.withValues(
                                alpha: isDark ? 0.35 : 0.25,
                              ),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryAccent.withValues(
                                  alpha: isDark ? 0.2 : 0.08,
                                ),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child:
                                customIconWidget ??
                                Icon(
                                  icon ?? Icons.inbox_rounded,
                                  size: iconSize,
                                  color: primaryAccent,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                .animate()
                .scale(
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                  begin: const Offset(0.7, 0.7),
                )
                .fadeIn(duration: 300.ms),

            const SizedBox(height: 22),

            // ── Title Text ────────────────────────────────────────────────
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
                height: 1.35,
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 300.ms),

            // ── Subtitle / Description ────────────────────────────────────
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                  color: context.textSecondary,
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 150.ms, duration: 300.ms),
            ],

            // ── Action Button ─────────────────────────────────────────────
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ZoomTapAnimation(
                    onTap: onAction,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryAccent,
                            primaryAccent == AppTheme.primaryColor
                                ? AppTheme.primaryLight
                                : AppTheme.accentBlueLight,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: primaryAccent.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        actionLabel!,
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: primaryAccent == AppTheme.primaryColor
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 300.ms)
                  .slideY(begin: 0.2, end: 0, duration: 300.ms),
            ],
          ],
        ),
      ),
    );
  }
}

/// Backward compatibility class for search inputs
class EmptySearchWidget extends StatelessWidget {
  final TextEditingController controller;
  const EmptySearchWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppEmptyWidget.search(
      context: context,
      query: controller.text,
      onClear: () => controller.clear(),
    );
  }
}
