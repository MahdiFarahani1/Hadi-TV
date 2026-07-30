import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/settings/domain/entities/language.dart';
import 'package:haditv/features/settings/domain/repositories/settings_repository.dart';

class GetLanguagesUseCase {
  final SettingsRepository repository;

  GetLanguagesUseCase(this.repository);

  Future<Either<Failure, List<Language>>> call() {
    return repository.getLanguages();
  }
}
