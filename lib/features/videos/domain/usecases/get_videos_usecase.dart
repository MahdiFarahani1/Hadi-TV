import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/videos/domain/repositories/video_repository.dart';

class GetVideosUseCase {
  final VideoRepository repository;

  GetVideosUseCase(this.repository);

  Future<Either<Failure, List<Video>>> call({
    String lang = 'en',
    int start = 0,
    int limit = 15,
    int? gid,
    int? speakerId,
    String? category,
    String? query,
  }) {
    return repository.getVideos(
      lang: lang,
      start: start,
      limit: limit,
      gid: gid,
      speakerId: speakerId,
      category: category,
      query: query,
    );
  }
}
