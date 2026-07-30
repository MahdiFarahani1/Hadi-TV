import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haditv/features/articles/domain/usecases/get_articles_usecase.dart';
import 'package:haditv/features/articles/domain/usecases/get_article_categories_usecase.dart';
import 'article_list_state.dart';

class ArticleListCubit extends Cubit<ArticleListState> {
  final GetArticlesUseCase getArticlesUseCase;
  final GetArticleCategoriesUseCase getCategoriesUseCase;

  ArticleListCubit({
    required this.getArticlesUseCase,
    required this.getCategoriesUseCase,
  }) : super(const ArticleListInitial());

  Future<void> loadInit() async {
    emit(const ArticleListLoading());

    final categoriesResult = await getCategoriesUseCase();
    final articlesResult = await getArticlesUseCase();

    categoriesResult.fold(
      (failure) => emit(ArticleListError(failure.message)),
      (categories) {
        articlesResult.fold(
          (failure) => emit(ArticleListError(failure.message)),
          (allArticles) {
            emit(
              ArticleListLoaded(
                categories: categories,
                allArticles: allArticles,
                filteredArticles: allArticles,
                selectedCategoryId: 0, // 0 means "All"
              ),
            );
          },
        );
      },
    );
  }

  void changeCategory(int categoryId) {
    if (state is ArticleListLoaded) {
      final current = state as ArticleListLoaded;
      final filtered = categoryId == 0
          ? current.allArticles
          : current.allArticles
                .where((a) => a.categoryId == categoryId)
                .toList();

      emit(
        current.copyWith(
          filteredArticles: filtered,
          selectedCategoryId: categoryId,
        ),
      );
    }
  }
}
