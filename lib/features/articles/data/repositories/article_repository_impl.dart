import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/articles/domain/entities/article_category.dart';
import 'package:haditv/features/articles/domain/entities/article_detail.dart';
import 'package:haditv/features/articles/domain/repositories/article_repository.dart';
import 'package:haditv/features/articles/data/datasources/article_remote_data_source.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDataSource remoteDataSource;

  ArticleRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ArticleCategory>>> getArticleCategories() async {
    try {
      final result = await remoteDataSource.getCategories();

      return Right(result.map((e) => e.toEntity()).toList());
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getArticles() async {
    final articleModel = await remoteDataSource.getArticles();
    return Right(articleModel.map((e) => e.toEntity()).toList());
  }

  @override
  Future<Either<Failure, ArticleDetail>> getArticleContent(int id) async {
    final content = await remoteDataSource.getArticleContent(id);
    return Right(content.toEntity());
  }
}
