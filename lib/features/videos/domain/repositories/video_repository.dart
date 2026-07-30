import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/videos/domain/entities/speaker.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/videos/domain/entities/video_category.dart';

abstract class VideoRepository {
  Future<Either<Failure, List<VideoCategory>>> getCategories({
    String lang = 'en',
  });
  Future<Either<Failure, List<Speaker>>> getSpeakers({String lang = 'en'});

  Future<Either<Failure, List<Video>>> getVideos({
    String lang = 'en',
    int start = 0,
    int limit = 15,
    int? gid,
    int? speakerId,
    String? category,
    String? query,
  });
}
