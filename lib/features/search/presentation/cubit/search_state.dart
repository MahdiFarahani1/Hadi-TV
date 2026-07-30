import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';

abstract class SearchState {
  const SearchState();
}

class SearchInitial extends SearchState {
  final List<String> recentSearches;
  const SearchInitial(this.recentSearches);
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final String query;
  final List<Video> videos;
  final List<Article> articles;
  final List<String> recentSearches;

  const SearchLoaded({
    required this.query,
    required this.videos,
    required this.articles,
    required this.recentSearches,
  });
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
}
