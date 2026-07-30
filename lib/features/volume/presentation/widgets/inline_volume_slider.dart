import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/features/volume/presentation/cubit/volume_cubit.dart';
import 'package:haditv/features/volume/presentation/cubit/volume_state.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ModernInlineVolumeSlider extends StatelessWidget {
  final double height;
  final double sliderWidth;
  final bool showPercentage;

  const ModernInlineVolumeSlider({
    super.key,
    this.height = 38.0,
    this.sliderWidth = 75.0,
    this.showPercentage = true,
  });

  IconData _getVolumeIcon(double volume) {
    if (volume <= 0.01) return Icons.volume_off_rounded;
    if (volume < 0.5) return Icons.volume_down_rounded;
    return Icons.volume_up_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<VolumeCubit, VolumeState>(
      builder: (context, state) {
        final volume = state.volume;
        final percentage = state.percentage;
        final isMuted = state.isMuted;

        return Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDark
                ? Colors.white.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.85),
            border: Border.all(
              color: isMuted
                  ? AppTheme.errorColor.withValues(alpha: 0.5)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.18)
                      : Colors.white.withValues(alpha: 0.9)),
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mute / Unmute Toggle Icon
              ZoomTapAnimation(
                onTap: () => context.read<VolumeCubit>().toggleMute(),
                child: Icon(
                  _getVolumeIcon(volume),
                  color: isMuted
                      ? AppTheme.errorColor
                      : (isDark ? Colors.white : const Color(0xFF1E293B)),
                  size: 16,
                ),
              ),
              const SizedBox(width: 4),

              // Direct Inline Slider
              SizedBox(
                width: sliderWidth,
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    activeTrackColor: isMuted
                        ? AppTheme.errorColor
                        : AppTheme.accentBlue,
                    inactiveTrackColor: isDark
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.1),
                    thumbColor: Colors.white,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                      elevation: 2,
                    ),
                    overlayColor: AppTheme.accentBlue.withValues(alpha: 0.15),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                  ),
                  child: Slider(
                    value: volume,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (newVol) {
                      context.read<VolumeCubit>().setVolume(newVol);
                    },
                  ),
                ),
              ),

              // Percentage Text Badge
              if (showPercentage)
                SizedBox(
                  width: 26,
                  child: Text(
                    '$percentage٪',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white70 : const Color(0xFF1E293B),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
