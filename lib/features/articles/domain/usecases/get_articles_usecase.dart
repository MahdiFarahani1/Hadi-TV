import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/articles/domain/repositories/article_repository.dart';

class GetArticlesUseCase {
  final ArticleRepository repository;

  GetArticlesUseCase(this.repository);

  Future<Either<Failure, List<Article>>> call() {
    return repository.getArticles();
  }
}

