import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haditv/features/settings/domain/repositories/settings_repository.dart';
import 'package:haditv/features/settings/domain/usecases/get_languages_usecase.dart';
import 'package:haditv/features/settings/domain/usecases/get_settings_usecase.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final GetLanguagesUseCase getLanguagesUseCase;
  final SettingsRepository settingsRepository;

  SettingsCubit({
    required this.getSettingsUseCase,
    required this.getLanguagesUseCase,
    required this.settingsRepository,
  }) : super(const SettingsInitial());

  Future<void> loadSettings() async {
    emit(const SettingsLoading());

    final settingsResult = await getSettingsUseCase();
    final langResult = await getLanguagesUseCase();

    // Both calls must succeed
    settingsResult.fold((failure) => emit(SettingsError(failure.message)), (
      settings,
    ) {
      langResult.fold((failure) => emit(SettingsError(failure.message)), (
        languages,
      ) {
        if (languages.isEmpty) {
          emit(const SettingsError('No languages returned from server.'));
          return;
        }

        final savedCode = settingsRepository.getLanguageCode();
        final themeMode = settingsRepository.getThemeMode();

        // Validate saved code exists in server list; fall back to server default
        final validCode =
            languages.any(
              (l) => l.abbr.toUpperCase() == savedCode.toUpperCase(),
            )
            ? savedCode
            : settings.lang;

        emit(
          SettingsLoaded(
            settings: settings,
            languages: languages,
            selectedLanguageCode: validCode,
            themeMode: themeMode,
          ),
        );
      });
    });
  }

  /// Persists the language choice and emits updated state.
  /// The Dio interceptor in [ApiClient] will pick it up on the next request.
  Future<void> changeLanguage(String abbr) async {
    if (state is! SettingsLoaded) return;

    final current = state as SettingsLoaded;

    await settingsRepository.saveLanguageCode(abbr);

    final settingsResult = await getSettingsUseCase();

    settingsResult.fold(
      (failure) {
        emit(SettingsError(failure.message));
      },
      (settings) {
        emit(current.copyWith(selectedLanguageCode: abbr, settings: settings));
      },
    );
  }

  Future<void> changeTheme(String mode) async {
    if (state is SettingsLoaded) {
      final current = state as SettingsLoaded;
      await settingsRepository.saveThemeMode(mode);
      emit(current.copyWith(themeMode: mode));
    }
  }

  Future<void> clearAllCache() async {
    if (state is SettingsLoaded) {
      emit(const SettingsLoading());
      await settingsRepository.clearCache();
      await loadSettings();
    }
  }
}
