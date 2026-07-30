import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/settings/domain/entities/language.dart';
import 'package:haditv/features/settings/domain/entities/app_settings.dart';
import 'package:haditv/features/settings/domain/repositories/settings_repository.dart';
import 'package:haditv/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:haditv/features/settings/data/datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      final model = await remoteDataSource.getSettings();

      return Right(model.toEntity());
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Language>>> getLanguages() async {
    try {
      final models = await remoteDataSource.getLanguages();
      return Right(models.map((m) => m.toEntity()).toList());
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  String getLanguageCode() => localDataSource.getLanguageCode();

  @override
  Future<void> saveLanguageCode(String code) =>
      localDataSource.saveLanguageCode(code);

  @override
  String getThemeMode() => localDataSource.getThemeMode();

  @override
  Future<void> saveThemeMode(String mode) =>
      localDataSource.saveThemeMode(mode);

  @override
  Future<void> clearCache() => localDataSource.clearCache();
}
