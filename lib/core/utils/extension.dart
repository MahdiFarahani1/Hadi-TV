import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/gen/assets.gen.dart';
import 'package:haditv/core/widgets/skeleton.dart';

import 'package:haditv/config/localization/app_localizations.dart';

extension ContextX on BuildContext {
  String tr(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }

  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Color get accentBlue => AppTheme.accentBlue;
  Color get textPrimary => colorScheme.onSurface;
  Color get textSecondary => theme.brightness == Brightness.dark
      ? const Color(0xFF94A3B8)
      : const Color(0xFF64748B);
  Color get cardBg => theme.cardColor;
  Color get cardBorder => theme.brightness == Brightness.dark
      ? Colors.white.withOpacity(0.04)
      : Colors.black.withOpacity(0.06);

  Gradient get headerGradient => theme.brightness == Brightness.dark
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F1624), Color(0xFF162035), Color(0xFF07090F)],
        )
      : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color(0xFFFAF5FF),
            Color.fromARGB(255, 255, 250, 230),
          ],
        );

  Gradient get bottomNavBarGradient => theme.brightness == Brightness.dark
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF07090F), Color(0xFF162035), Color(0xFF0F1624)],
        )
      : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 255, 250, 230),
            Color(0xFFFAF5FF),
            Color.fromARGB(255, 255, 255, 255),
          ],
        );

  EdgeInsets get padding => MediaQuery.paddingOf(this);

  Gap gap(double space) {
    return Gap(space);
  }

  MaxGap gapSafe(double space) {
    return MaxGap(space);
  }
}

extension ImageExtension on String? {
  Widget toArticleImage({
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    return _buildImage(
      placeholder: Assets.images.article.path,
      fit: fit,
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }

  Widget toVideoImage({
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    return _buildImage(
      placeholder: Assets.images.video.path,
      fit: fit,
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }

  Widget _buildImage({
    required String placeholder,
    required BoxFit fit,
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    final url = this?.trim();

    Widget image;

    if (url == null || url.isEmpty) {
      image = Image.asset(placeholder, fit: fit, width: width, height: height);
    } else {
      image = CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        width: width,
        height: height,
        placeholder: (_, __) =>
            Skeleton(width: width, height: height, borderRadius: 0),
        errorWidget: (_, __, ___) =>
            Image.asset(placeholder, fit: fit, width: width, height: height),
      );
    }

    if (borderRadius == null) return image;

    return ClipRRect(borderRadius: borderRadius, child: image);
  }
}
