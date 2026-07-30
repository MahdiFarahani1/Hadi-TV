import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/settings/domain/entities/language.dart';
import 'package:haditv/features/settings/domain/entities/app_settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, AppSettings>> getSettings();
  Future<Either<Failure, List<Language>>> getLanguages();
  String getLanguageCode();
  Future<void> saveLanguageCode(String code);
  String getThemeMode();
  Future<void> saveThemeMode(String mode);
  Future<void> clearCache();
}
