import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/home/domain/entities/home_content.dart';
import 'package:haditv/features/home/domain/repositories/home_repository.dart';
import 'package:haditv/features/videos/domain/repositories/video_repository.dart';
import 'package:haditv/features/articles/domain/repositories/article_repository.dart';
import 'package:haditv/features/live_tv/domain/repositories/live_tv_repository.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/live_tv/domain/entities/live_channel.dart';

class HomeRepositoryImpl implements HomeRepository {
  final VideoRepository videoRepository;
  final ArticleRepository articleRepository;
  final LiveTvRepository liveTvRepository;

  HomeRepositoryImpl({
    required this.videoRepository,
    required this.articleRepository,
    required this.liveTvRepository,
  });

  @override
  Future<Either<Failure, HomeContent>> getHomeContent() async {
    try {
      // Fetch videos from video repository
      final videosEither = await videoRepository.getVideos(start: 1, limit: 10);
      final List<Video> videos = [];
      Failure? failure;

      videosEither.fold((f) => failure = f, (res) {
        final list = res;
        videos.addAll(list);
      });

      if (failure != null) return Left(failure!);

      // Fetch articles from article repository
      final articlesEither = await articleRepository.getArticles();
      final List<Article> articles = [];

      articlesEither.fold((f) => failure = f, (res) => articles.addAll(res));

      if (failure != null) return Left(failure!);

      // Fetch live channels from live tv repository
      final liveChannelsEither = await liveTvRepository.getLiveChannels();
      final List<LiveChannel> liveChannels = [];

      liveChannelsEither.fold(
        (f) => failure = f,
        (res) => liveChannels.addAll(res.where((c) => c.isLive)),
      );

      if (failure != null) return Left(failure!);

      return Right(
        HomeContent(
          latestArticles: articles,
          featuredArticles: articles,
          featuredVideos: videos.take(3).toList(),
          latestVideos: videos.reversed.toList(),
          trending: videos.take(4).toList(),
          recommended: videos.reversed.take(4).toList(),
          liveChannels: liveChannels,
        ),
      );
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
