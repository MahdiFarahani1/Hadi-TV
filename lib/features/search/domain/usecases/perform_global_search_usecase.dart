import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/search/domain/repositories/search_repository.dart';

class PerformGlobalSearchUseCase {
  final SearchRepository repository;

  PerformGlobalSearchUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(String query) {
    return repository.performSearch(query);
  }
}
