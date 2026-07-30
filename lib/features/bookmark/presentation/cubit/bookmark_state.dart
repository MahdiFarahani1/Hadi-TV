import 'package:equatable/equatable.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';

enum BookmarkTab { all, videos, articles }

abstract class BookmarkState extends Equatable {
  const BookmarkState();

  @override
  List<Object?> get props => [];
}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoading extends BookmarkState {}

class BookmarkLoaded extends BookmarkState {
  final List<Video> videos;
  final List<Article> articles;
  final BookmarkTab activeTab;
  final String searchQuery;

  const BookmarkLoaded({
    required this.videos,
    required this.articles,
    this.activeTab = BookmarkTab.all,
    this.searchQuery = '',
  });

  int get totalCount => videos.length + articles.length;

  List<Video> get filteredVideos {
    if (searchQuery.isEmpty) return videos;
    return videos
        .where((v) => v.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  List<Article> get filteredArticles {
    if (searchQuery.isEmpty) return articles;
    return articles
        .where((a) => a.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  BookmarkLoaded copyWith({
    List<Video>? videos,
    List<Article>? articles,
    BookmarkTab? activeTab,
    String? searchQuery,
  }) {
    return BookmarkLoaded(
      videos: videos ?? this.videos,
      articles: articles ?? this.articles,
      activeTab: activeTab ?? this.activeTab,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [videos, articles, activeTab, searchQuery];
}

class BookmarkError extends BookmarkState {
  final String message;

  const BookmarkError(this.message);

  @override
  List<Object?> get props => [message];
}
