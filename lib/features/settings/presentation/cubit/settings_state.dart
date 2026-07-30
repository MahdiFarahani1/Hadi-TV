import 'package:haditv/features/settings/domain/entities/app_settings.dart';
import 'package:haditv/features/settings/domain/entities/language.dart';

abstract class SettingsState {
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  final AppSettings settings;
  final List<Language> languages;

  /// ISO abbreviation of the currently selected language, e.g. "FA"
  final String selectedLanguageCode;

  /// "dark" | "light"
  final String themeMode;

  const SettingsLoaded({
    required this.settings,
    required this.languages,
    required this.selectedLanguageCode,
    required this.themeMode,
  });

  /// Returns the currently selected [Language] entity, or the first in list.
  Language get selectedLanguage {
    return languages.firstWhere(
      (l) => l.abbr.toUpperCase() == selectedLanguageCode.toUpperCase(),
      orElse: () => languages.first,
    );
  }

  SettingsLoaded copyWith({
    AppSettings? settings,
    List<Language>? languages,
    String? selectedLanguageCode,
    String? themeMode,
  }) {
    return SettingsLoaded(
      settings: settings ?? this.settings,
      languages: languages ?? this.languages,
      selectedLanguageCode: selectedLanguageCode ?? this.selectedLanguageCode,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class SettingsError extends SettingsState {
  final String message;
  const SettingsError(this.message);
}
