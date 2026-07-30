import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/bookmark/domain/repositories/bookmark_repository.dart';

class ToggleBookmarkUseCase {
  final BookmarkRepository repository;

  ToggleBookmarkUseCase(this.repository);

  Future<bool> toggleVideo(Video video) async {
    final isBookmarked = repository.isVideoBookmarked(video.id);
    if (isBookmarked) {
      await repository.removeVideoBookmark(video.id);
      return false;
    } else {
      await repository.bookmarkVideo(video);
      return true;
    }
  }

  Future<bool> toggleArticle(Article article) async {
    final isBookmarked = repository.isArticleBookmarked(article.id);
    if (isBookmarked) {
      await repository.removeArticleBookmark(article.id);
      return false;
    } else {
      await repository.bookmarkArticle(article);
      return true;
    }
  }

  bool isVideoBookmarked(int videoId) => repository.isVideoBookmarked(videoId);

  bool isArticleBookmarked(int articleId) =>
      repository.isArticleBookmarked(articleId);

  Future<void> clearAll() => repository.clearAllBookmarks();
}
