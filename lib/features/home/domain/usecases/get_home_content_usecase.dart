import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/home/domain/entities/home_content.dart';
import 'package:haditv/features/home/domain/repositories/home_repository.dart';

class GetHomeContentUseCase {
  final HomeRepository repository;

  GetHomeContentUseCase(this.repository);

  Future<Either<Failure, HomeContent>> call() {
    return repository.getHomeContent();
  }
}
