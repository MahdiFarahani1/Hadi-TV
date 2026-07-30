import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/utils/extension.dart';

class CustomErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String message;
  final String title;

  const CustomErrorWidget({
    super.key,
    required this.onRetry,
    required this.message,
    this.title = 'error_occurred',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Center(
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: context.screenWidth * 0.32,
                      height: context.screenWidth * 0.32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.primaryColor.withOpacity(0.16),
                            AppTheme.primaryColor.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: context.screenWidth * 0.22,
                      height: context.screenWidth * 0.22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.primaryColor.withOpacity(0.18),
                            AppTheme.primaryColor.withOpacity(0.08),
                          ],
                        ),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.wifi_off_rounded,
                        size: 34,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.06, 1.06),
                  duration: 1600.ms,
                  curve: Curves.easeInOut,
                ),

            context.gap(28),

            Text(
                  context.tr(title),
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(duration: 400.ms, delay: 150.ms)
                .slideY(begin: 0.25, end: 0, curve: Curves.easeOutQuad),

            context.gap(10),

            Text(
                  context.tr(message),
                  style: TextStyle(
                    fontSize: 14.5,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(duration: 400.ms, delay: 250.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

            context.gap(36),

            _RetryButton(onTap: onRetry)
                .animate()
                .fadeIn(duration: 450.ms, delay: 350.ms)
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1, 1),
                  curve: Curves.easeOutBack,
                ),
          ],
        ),
      ),
    );
  }
}

class _RetryButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RetryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.82),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.refresh_rounded, color: Colors.white, size: 19)
                    .animate(
                      onPlay: (controller) =>
                          controller.repeat(period: 2.seconds),
                    )
                    .rotate(
                      begin: 0,
                      end: 1,
                      duration: 900.ms,
                      curve: Curves.easeInOut,
                    ),
                const SizedBox(width: 10),
                Text(
                  context.tr('retry'),
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.2,
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
