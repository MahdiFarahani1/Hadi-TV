import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/articles/domain/usecases/get_articles_usecase.dart';
import 'package:haditv/features/articles/domain/usecases/get_article_content_usecase.dart';
import 'article_detail_state.dart';

class ArticleDetailCubit extends Cubit<ArticleDetailState> {
  final GetArticlesUseCase getArticlesUseCase;
  final GetArticleContentUseCase getArticleContentUseCase;

  ArticleDetailCubit({
    required this.getArticlesUseCase,
    required this.getArticleContentUseCase,
  }) : super(const ArticleDetailInitial());

  Future<void> loadArticle(Article article) async {
    emit(const ArticleDetailLoading());

    final contentResult = await getArticleContentUseCase(article.id);
    final relatedResult = await getArticlesUseCase();

    contentResult.fold((failure) => emit(ArticleDetailError(failure.message)), (
      fullContent,
    ) {
      relatedResult.fold(
        (failure) => emit(ArticleDetailError(failure.message)),
        (articles) {
          final related = articles.where((a) => a.id != article.id).toList();
          emit(
            ArticleDetailLoaded(article: fullContent, relatedArticles: related),
          );
        },
      );
    });
  }
}
