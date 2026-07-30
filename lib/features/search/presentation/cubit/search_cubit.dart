import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haditv/features/search/domain/repositories/search_repository.dart';
import 'package:haditv/features/search/domain/usecases/perform_global_search_usecase.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final PerformGlobalSearchUseCase performGlobalSearchUseCase;
  final SearchRepository searchRepository;

  SearchCubit({
    required this.performGlobalSearchUseCase,
    required this.searchRepository,
  }) : super(SearchInitial(searchRepository.getRecentSearches()));

  void loadRecents() {
    emit(SearchInitial(searchRepository.getRecentSearches()));
  }

  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) {
      loadRecents();
      return;
    }

    emit(const SearchLoading());
    final result = await performGlobalSearchUseCase(query);

    result.fold((failure) => emit(SearchError(failure.message)), (
      results,
    ) async {
      final videos = List<Video>.from(results['videos'] as List);
      final articles = List<Article>.from(results['articles'] as List);

      final recents = searchRepository.getRecentSearches();
      if (!recents.contains(query)) {
        recents.insert(0, query);
        if (recents.length > 8) {
          recents.removeLast();
        }
        await searchRepository.saveRecentSearches(recents);
      }

      emit(
        SearchLoaded(
          query: query,
          videos: videos,
          articles: articles,
          recentSearches: recents,
        ),
      );
    });
  }

  Future<void> clearRecents() async {
    await searchRepository.clearRecentSearches();
    if (state is SearchInitial) {
      emit(const SearchInitial([]));
    } else if (state is SearchLoaded) {
      final current = state as SearchLoaded;
      emit(
        SearchLoaded(
          query: current.query,
          videos: current.videos,
          articles: current.articles,
          recentSearches: const [],
        ),
      );
    }
  }
}
