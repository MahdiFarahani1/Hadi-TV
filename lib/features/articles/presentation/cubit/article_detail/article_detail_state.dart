import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/articles/domain/entities/article_detail.dart'
    show ArticleDetail;

abstract class ArticleDetailState {
  const ArticleDetailState();
}

class ArticleDetailInitial extends ArticleDetailState {
  const ArticleDetailInitial();
}

class ArticleDetailLoading extends ArticleDetailState {
  const ArticleDetailLoading();
}

class ArticleDetailLoaded extends ArticleDetailState {
  final ArticleDetail article;
  final List<Article> relatedArticles;

  const ArticleDetailLoaded({
    required this.article,
    required this.relatedArticles,
  });

  ArticleDetailLoaded copyWith({
    ArticleDetail? article,
    List<Article>? relatedArticles,
  }) {
    return ArticleDetailLoaded(
      article: article ?? this.article,
      relatedArticles: relatedArticles ?? this.relatedArticles,
    );
  }
}

class ArticleDetailError extends ArticleDetailState {
  final String message;
  const ArticleDetailError(this.message);
}
