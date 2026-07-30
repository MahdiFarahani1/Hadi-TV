import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/bookmark/domain/repositories/bookmark_repository.dart';

class GetBookmarksUseCase {
  final BookmarkRepository repository;

  GetBookmarksUseCase(this.repository);

  List<Video> getVideos() => repository.getBookmarkedVideos();

  List<Article> getArticles() => repository.getBookmarkedArticles();
}
