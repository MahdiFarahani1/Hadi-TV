import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';

abstract class BookmarkRepository {
  List<Video> getBookmarkedVideos();
  Future<void> bookmarkVideo(Video video);
  Future<void> removeVideoBookmark(int videoId);
  bool isVideoBookmarked(int videoId);

  List<Article> getBookmarkedArticles();
  Future<void> bookmarkArticle(Article article);
  Future<void> removeArticleBookmark(int articleId);
  bool isArticleBookmarked(int articleId);

  Future<void> clearAllBookmarks();
}
