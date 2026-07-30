import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/videos/domain/entities/speaker.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/videos/domain/entities/video_category.dart';
import 'package:haditv/features/videos/domain/repositories/video_repository.dart';
import 'package:haditv/features/videos/data/datasources/video_remote_data_source.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDataSource remoteDataSource;

  VideoRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<VideoCategory>>> getCategories({
    String lang = 'en',
  }) async {
    try {
      final models = await remoteDataSource.getCategories(lang: lang);
      return Right(models.map((m) => m.toEntity()).toList());
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Speaker>>> getSpeakers({
    String lang = 'en',
  }) async {
    try {
      final models = await remoteDataSource.getSpeakers(lang: lang);
      return Right(models.map((m) => m.toEntity()).toList());
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Video>>> getVideos({
    String lang = 'en',
    int start = 0,
    int limit = 15,
    int? gid,
    int? speakerId,
    String? category,
    String? query,
  }) async {
    try {
      final models = await remoteDataSource.getVideos(
        lang: lang,
        start: start,
        limit: limit,
        gid: gid,
        speakerId: speakerId,
      );

      var entities = models.map((m) => m.toEntity()).toList();

      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        entities = entities
            .where(
              (v) =>
                  v.title.toLowerCase().contains(q) ||
                  (v.description?.toLowerCase().contains(q) ?? false),
            )
            .toList();
      }

      return Right(entities);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
