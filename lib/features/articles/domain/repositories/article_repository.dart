import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/articles/domain/entities/article_category.dart';
import 'package:haditv/features/articles/domain/entities/article_detail.dart';

abstract class ArticleRepository {
  Future<Either<Failure, List<Article>>> getArticles();
  Future<Either<Failure, List<ArticleCategory>>> getArticleCategories();
  Future<Either<Failure, ArticleDetail>> getArticleContent(int id);
}
