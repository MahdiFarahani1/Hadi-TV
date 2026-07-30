import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:haditv/features/bookmark/data/datasources/bookmark_local_data_source.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkLocalDataSource localDataSource;

  BookmarkRepositoryImpl(this.localDataSource);

  @override
  List<Video> getBookmarkedVideos() => localDataSource.getBookmarkedVideos();

  @override
  Future<void> bookmarkVideo(Video video) =>
      localDataSource.saveBookmarkedVideo(video);

  @override
  Future<void> removeVideoBookmark(int videoId) =>
      localDataSource.removeBookmarkedVideo(videoId);

  @override
  bool isVideoBookmarked(int videoId) =>
      localDataSource.isVideoBookmarked(videoId);

  @override
  List<Article> getBookmarkedArticles() =>
      localDataSource.getBookmarkedArticles();

  @override
  Future<void> bookmarkArticle(Article article) =>
      localDataSource.saveBookmarkedArticle(article);

  @override
  Future<void> removeArticleBookmark(int articleId) =>
      localDataSource.removeBookmarkedArticle(articleId);

  @override
  bool isArticleBookmarked(int articleId) =>
      localDataSource.isArticleBookmarked(articleId);

  @override
  Future<void> clearAllBookmarks() => localDataSource.clearAllBookmarks();
}
