import 'package:equatable/equatable.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/articles/domain/entities/article_category.dart';

abstract class ArticleListState extends Equatable {
  const ArticleListState();

  @override
  List<Object?> get props => [];
}

class ArticleListInitial extends ArticleListState {
  const ArticleListInitial();
}

class ArticleListLoading extends ArticleListState {
  const ArticleListLoading();
}

class ArticleListError extends ArticleListState {
  final String message;

  const ArticleListError(this.message);

  @override
  List<Object?> get props => [message];
}

class ArticleListLoaded extends ArticleListState {
  final List<ArticleCategory> categories;
  final List<Article> allArticles;
  final List<Article> filteredArticles;
  final int selectedCategoryId; // 0 for "All"

  const ArticleListLoaded({
    required this.categories,
    required this.allArticles,
    required this.filteredArticles,
    required this.selectedCategoryId,
  });

  ArticleListLoaded copyWith({
    List<ArticleCategory>? categories,
    List<Article>? allArticles,
    List<Article>? filteredArticles,
    int? selectedCategoryId,
  }) {
    return ArticleListLoaded(
      categories: categories ?? this.categories,
      allArticles: allArticles ?? this.allArticles,
      filteredArticles: filteredArticles ?? this.filteredArticles,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }

  @override
  List<Object?> get props => [categories, allArticles, filteredArticles, selectedCategoryId];
}
