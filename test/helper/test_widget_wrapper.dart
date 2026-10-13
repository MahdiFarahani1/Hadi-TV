import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:haditv/config/localization/app_localizations_delegate.dart';
import 'package:haditv/config/theme/app_theme.dart';

Widget createTestWidget({
  required Widget child,
  Locale locale = const Locale('en'),
  ThemeData? theme,
  NavigatorObserver? navigatorObserver,
}) {
  return MaterialApp(
    theme: theme ?? AppTheme.lightTheme,
    locale: locale,
    localizationsDelegates: const [
      AppLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('fa'),
      Locale('en'),
      Locale('ar'),
      Locale('ur'),
    ],
    home: child,
    navigatorObservers: navigatorObserver != null ? [navigatorObserver] : [],
  );
}
