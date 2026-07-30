import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/articles/domain/entities/article_category.dart';
import 'package:haditv/features/articles/domain/repositories/article_repository.dart';

class GetArticleCategoriesUseCase {
  final ArticleRepository repository;

  GetArticleCategoriesUseCase(this.repository);

  Future<Either<Failure, List<ArticleCategory>>> call() async {
    return await repository.getArticleCategories();
  }
}
