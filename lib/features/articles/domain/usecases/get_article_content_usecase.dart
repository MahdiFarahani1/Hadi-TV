import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/articles/domain/entities/article_detail.dart';
import 'package:haditv/features/articles/domain/repositories/article_repository.dart';

class GetArticleContentUseCase {
  final ArticleRepository repository;

  GetArticleContentUseCase(this.repository);

  Future<Either<Failure, ArticleDetail>> call(int id) {
    return repository.getArticleContent(id);
  }
}
