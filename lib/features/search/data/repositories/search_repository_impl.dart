import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/search/domain/repositories/search_repository.dart';
import 'package:haditv/features/search/data/datasources/search_local_data_source.dart';
import 'package:haditv/features/videos/domain/repositories/video_repository.dart';
import 'package:haditv/features/articles/domain/repositories/article_repository.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';

class SearchRepositoryImpl implements SearchRepository {
  final VideoRepository videoRepository;
  final ArticleRepository articleRepository;
  final SearchLocalDataSource searchLocalDataSource;

  SearchRepositoryImpl({
    required this.videoRepository,
    required this.articleRepository,
    required this.searchLocalDataSource,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> performSearch(
    String query,
  ) async {
    final videosResult = await videoRepository.getVideos(
      query: query,
      start: 0,
      limit: 15,
    );
    final articlesResult = await articleRepository.getArticles();

    if (videosResult.isLeft()) {
      return Left(videosResult.fold((l) => l, (r) => throw Exception()));
    }
    if (articlesResult.isLeft()) {
      return Left(articlesResult.fold((l) => l, (r) => throw Exception()));
    }

    final videos = videosResult.getOrElse(() => <Video>[]);
    final articlesList = articlesResult.getOrElse(() => <Article>[]);
    final articles = articlesList
        .where((a) => a.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Right({'videos': videos, 'articles': articles});
  }

  @override
  List<String> getRecentSearches() => searchLocalDataSource.getRecentSearches();

  @override
  Future<void> saveRecentSearches(List<String> searches) =>
      searchLocalDataSource.saveRecentSearches(searches);

  @override
  Future<void> clearRecentSearches() =>
      searchLocalDataSource.clearRecentSearches();
}
