import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';

import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/articles/data/datasources/article_remote_data_source.dart';
import 'package:haditv/features/articles/data/models/article/article_model.dart';
import 'package:haditv/features/articles/data/models/article_category/article_category_model.dart';
import 'package:haditv/features/articles/data/models/article_detail/article_detail_model.dart';
import 'package:haditv/features/articles/data/repositories/article_repository_impl.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/articles/domain/entities/article_category.dart';
import 'package:haditv/features/articles/domain/entities/article_detail.dart';

class MockArticleRemoteDataSource extends Mock
    implements ArticleRemoteDataSource {}

void main() {
  group('ArticleRepositoryImpl', () {
    late MockArticleRemoteDataSource mockRemoteDataSource;
    late ArticleRepositoryImpl repository;

    setUp(() {
      mockRemoteDataSource = MockArticleRemoteDataSource();
      repository = ArticleRepositoryImpl(mockRemoteDataSource);
    });

    // =========================================================
    // getArticleCategories
    // =========================================================

    group('getArticleCategories', () {
      test(
        'should return Right with list of ArticleCategory when data source succeeds',
        () async {
          // Arrange
          final models = [
            const ArticleCategoryModel(
              id: 4,
              parentId: 0,
              title: 'تاریخ و سیره معصومین',
            ),
            const ArticleCategoryModel(
              id: 5,
              parentId: 0,
              title: 'نهج البلاغه',
            ),
          ];

          when(
            () => mockRemoteDataSource.getCategories(),
          ).thenAnswer((_) async => models);

          // Act
          final result = await repository.getArticleCategories();

          // Assert
          expect(result.isRight(), isTrue);

          final categories = result.getOrElse(() => []);

          expect(categories, isA<List<ArticleCategory>>());
          expect(categories.length, 2);

          expect(categories[0].id, 4);
          expect(categories[0].title, 'تاریخ و سیره معصومین');

          expect(categories[1].id, 5);
          expect(categories[1].title, 'نهج البلاغه');

          verify(() => mockRemoteDataSource.getCategories()).called(1);
        },
      );

      test(
        'should return Left with Failure when data source throws Failure',
        () async {
          // Arrange
          const failure = ServerFailure(statusCode: 500, message: 'error');

          when(() => mockRemoteDataSource.getCategories()).thenThrow(failure);

          // Act
          final result = await repository.getArticleCategories();

          // Assert
          expect(result, const Left(failure));

          verify(() => mockRemoteDataSource.getCategories()).called(1);
        },
      );
    });

    // =========================================================
    // getArticles
    // =========================================================

    group('getArticles', () {
      test(
        'should return Right with list of Article when data source succeeds',
        () async {
          // Arrange
          final models = [
            const ArticleModel(
              id: 12,
              categoryId: 4,
              title: 'فدک عطیه الهی',
              photoUrl: 'https://example.com/image.jpg',
              readTime: '5 min',
              articleDate: '2020-01-17',
              articleUrl: 'https://example.com/article',
            ),
          ];

          when(
            () => mockRemoteDataSource.getArticles(),
          ).thenAnswer((_) async => models);

          // Act
          final result = await repository.getArticles();

          // Assert
          expect(result.isRight(), true);

          final articles = result.getOrElse(() => []);

          expect(articles, isA<List<Article>>());
          expect(articles.length, 1);

          expect(articles[0].id, 12);
          expect(articles[0].categoryId, 4);
          expect(articles[0].title, 'فدک عطیه الهی');
          expect(articles[0].photoUrl, 'https://example.com/image.jpg');

          verify(() => mockRemoteDataSource.getArticles()).called(1);
        },
      );
    });

    // =========================================================
    // getArticleContent
    // =========================================================

    group('getArticleContent', () {
      test(
        'should return Right with ArticleDetail when data source succeeds',
        () async {
          // Arrange
          const model = ArticleDetailModel(
            id: 2,
            categoryId: 4,
            title: 'امام هادی (علیه السلام)',
            content: 'محتوای مقاله...',
            photoUrl: 'https://example.com/image.jpg',
            articleDate: '2016-01-09',
            articleUrl: 'https://example.com/article',
          );

          when(
            () => mockRemoteDataSource.getArticleContent(2),
          ).thenAnswer((_) async => model);

          // Act
          final result = await repository.getArticleContent(2);

          // Assert
          expect(result.isRight(), true);

          final article = result.getOrElse(
            () => throw StateError('Expected Right'),
          );

          expect(article, isA<ArticleDetail>());
          expect(article.id, 2);
          expect(article.categoryId, 4);
          expect(article.title, 'امام هادی (علیه السلام)');
          expect(article.content, 'محتوای مقاله...');

          verify(() => mockRemoteDataSource.getArticleContent(2)).called(1);
        },
      );
    });
  });
}
