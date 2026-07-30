import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/bookmark/domain/usecases/get_bookmarks_usecase.dart';
import 'package:haditv/features/bookmark/domain/usecases/toggle_bookmark_usecase.dart';
import 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  final GetBookmarksUseCase getBookmarksUseCase;
  final ToggleBookmarkUseCase toggleBookmarkUseCase;

  BookmarkCubit({
    required this.getBookmarksUseCase,
    required this.toggleBookmarkUseCase,
  }) : super(BookmarkInitial());

  void loadBookmarks() {
    emit(BookmarkLoading());
    try {
      final videos = getBookmarksUseCase.getVideos();
      final articles = getBookmarksUseCase.getArticles();
      emit(BookmarkLoaded(videos: videos, articles: articles));
    } catch (e) {
      emit(BookmarkError('Error loading bookmarks: ${e.toString()}'));
    }
  }

  void changeTab(BookmarkTab tab) {
    if (state is BookmarkLoaded) {
      final current = state as BookmarkLoaded;
      emit(current.copyWith(activeTab: tab));
    }
  }

  void updateSearch(String query) {
    if (state is BookmarkLoaded) {
      final current = state as BookmarkLoaded;
      emit(current.copyWith(searchQuery: query));
    }
  }

  Future<bool> toggleVideo(Video video) async {
    final isSaved = await toggleBookmarkUseCase.toggleVideo(video);
    if (state is BookmarkLoaded) {
      final videos = getBookmarksUseCase.getVideos();
      final articles = getBookmarksUseCase.getArticles();
      final current = state as BookmarkLoaded;
      emit(current.copyWith(videos: videos, articles: articles));
    } else {
      loadBookmarks();
    }
    return isSaved;
  }

  Future<bool> toggleArticle(Article article) async {
    final isSaved = await toggleBookmarkUseCase.toggleArticle(article);
    if (state is BookmarkLoaded) {
      final videos = getBookmarksUseCase.getVideos();
      final articles = getBookmarksUseCase.getArticles();
      final current = state as BookmarkLoaded;
      emit(current.copyWith(videos: videos, articles: articles));
    } else {
      loadBookmarks();
    }
    return isSaved;
  }

  bool isVideoBookmarked(int id) => toggleBookmarkUseCase.isVideoBookmarked(id);

  bool isArticleBookmarked(int id) =>
      toggleBookmarkUseCase.isArticleBookmarked(id);

  Future<void> clearAll() async {
    await toggleBookmarkUseCase.clearAll();
    loadBookmarks();
  }
}
