import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/videos/domain/entities/video_category.dart';
import 'package:haditv/features/videos/domain/repositories/video_repository.dart';

class GetVideoCategoriesUseCase {
  final VideoRepository repository;

  GetVideoCategoriesUseCase(this.repository);

  Future<Either<Failure, List<VideoCategory>>> call() {
    return repository.getCategories();
  }
}
