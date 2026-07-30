import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/home/domain/entities/home_content.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeContent>> getHomeContent();
}
