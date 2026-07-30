import 'package:hive_flutter/hive_flutter.dart';
import 'package:haditv/core/service/storage/hive_initializer.dart';

abstract class SettingsLocalDataSource {
  String getLanguageCode();
  Future<void> saveLanguageCode(String code);
  String getThemeMode();
  Future<void> saveThemeMode(String mode);
  Future<void> clearCache();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String _keyLanguageCode = 'language_code';
  static const String _keyThemeMode = 'theme_mode';

  Box get _settingsBox => Hive.box(HiveInitializer.settingsBoxName);

  @override
  String getLanguageCode() {
    return _settingsBox.get(_keyLanguageCode, defaultValue: 'fa') as String;
  }

  @override
  Future<void> saveLanguageCode(String code) async {
    await _settingsBox.put(_keyLanguageCode, code);
  }

  @override
  String getThemeMode() {
    return _settingsBox.get(_keyThemeMode, defaultValue: 'light') as String;
  }

  @override
  Future<void> saveThemeMode(String mode) async {
    await _settingsBox.put(_keyThemeMode, mode);
  }

  @override
  Future<void> clearCache() async {
    await _settingsBox.clear();
  }
}
