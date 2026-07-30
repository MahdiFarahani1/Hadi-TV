import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haditv/config/routes/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:haditv/config/localization/app_localizations_delegate.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/config/version/app_version.dart';
import 'package:haditv/core/di/injection.dart';
import 'package:haditv/core/service/firebase/firebase_service.dart';
import 'package:haditv/core/service/storage/hive_initializer.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:haditv/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:haditv/features/settings/presentation/cubit/settings_state.dart';
import 'package:media_kit/media_kit.dart';

import 'package:haditv/features/volume/presentation/cubit/volume_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize native media player engine
  MediaKit.ensureInitialized();

  // Initialize app version
  await AppVersion.instance.init();
  // Initialize Local database boxes
  await HiveInitializer.init();
  // Initialize Firebase Service
  await FirebaseService.instance.initialize();
  // Configure Dependency Injection Locator
  await configureDependencies();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SettingsCubit>()..loadSettings(),
        ),
        BlocProvider(
          create: (context) => getIt<BookmarkCubit>()..loadBookmarks(),
        ),
        BlocProvider(create: (context) => getIt<VolumeCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          ThemeMode mode = ThemeMode.light;
          String langCode = 'fa';
          if (state is SettingsLoaded) {
            mode = state.themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
            langCode = state.selectedLanguageCode.toLowerCase();
          }

          return MaterialApp.router(
            title: 'Hadi TV',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: mode,
            locale: Locale(langCode),
            supportedLocales: const [
              Locale('fa'),
              Locale('en'),
              Locale('ar'),
              Locale('ur'),
              Locale('az'),
              Locale('id'),
              Locale('ps'),
              Locale('fr'),
              Locale('th'),
              Locale('tr'),
              Locale('ha'),
              Locale('ku'),
              Locale('sw'),
              Locale('de'),
              Locale('es'),
              Locale('fd'),
              Locale('ru'),
              Locale('ff'),
              Locale('ma'),
            ],
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
