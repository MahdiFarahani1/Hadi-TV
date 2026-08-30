import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/core/network/api_endpoints.dart';
import 'package:haditv/features/articles/data/datasources/article_remote_data_source.dart';
import 'package:haditv/features/articles/data/models/article/article_model.dart';
import 'package:haditv/features/articles/data/models/article_category/article_category_model.dart';
import 'package:haditv/features/articles/data/models/article_detail/article_detail_model.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helper/mock_apiclient.dart';
import '../../../helper/mock_dio.dart';

void main() {
  group('ArticleRemoteDataSource', () {
    late MockApiClient mockApiClient;
    late MockDio mockDio;
    late ArticleRemoteDataSource dataSource;

    setUp(() {
      mockApiClient = MockApiClient();
      mockDio = MockDio();

      when(() => mockApiClient.dio).thenReturn(mockDio);

      dataSource = ArticleRemoteDataSource(mockApiClient);
    });
    group('getCategories', () {
      test(
        'should return list of categories when getCategories succeeds',
        () async {
          // Arrange
          when(() => mockDio.get(ApiEndpoints.articleGroup)).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: ApiEndpoints.articleGroup),
              statusCode: 200,
              data: {
                'articlegroup': [
                  {
                    'id': 4,
                    'parent_id': 0,
                    'title': 'تاریخ و سیره معصومین (علیهم السلام)',
                  },
                  {'id': 5, 'parent_id': 0, 'title': 'نهج البلاغه'},
                  {'id': 6, 'parent_id': 0, 'title': 'مهدویت'},
                  {'id': 49, 'parent_id': 0, 'title': 'سوشال مدیا'},
                  {'id': 51, 'parent_id': 0, 'title': 'نکته ها و حکایت ها'},
                ],
              },
            ),
          );

          // Act
          final result = await dataSource.getCategories();

          // Assert
          expect(result, isA<List<ArticleCategoryModel>>());
          expect(result.length, 5);

          expect(result[0].id, 4);
          expect(result[0].title, 'تاریخ و سیره معصومین (علیهم السلام)');

          expect(result[1].id, 5);
          expect(result[1].title, 'نهج البلاغه');

          verify(() => mockDio.get(ApiEndpoints.articleGroup)).called(1);
        },
      );
      test("should throw exception when getCategories fails (500)", () async {
        // Arrange
        when(() => mockDio.get(ApiEndpoints.articleGroup)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiEndpoints.articleGroup),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: ApiEndpoints.articleGroup),
              statusCode: 500,
            ),
          ),
        );

        // Act
        final result = dataSource.getCategories();

        // Assert
        await expectLater(result, throwsA(isA<ServerFailure>()));

        verify(() => mockDio.get(ApiEndpoints.articleGroup)).called(1);
      });
    });

    group('getArticles', () {
      test('should return list of articles when getArticles succeeds', () async {
        // Arrange
        when(() => mockDio.get(ApiEndpoints.article)).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ApiEndpoints.article),
            statusCode: 200,
            data: {
              "articles": [
                {
                  "id": 12,
                  "category_id": 4,
                  "title": "فدک عطیه الهی",
                  "photo_url":
                      "https://haditv.co.uk/upload_list/source/Articles/FA/Fadak.png",
                  "article_date": "2020-01-17",
                  "article_url": "https://fa.haditv.com/article/فدک-عطیه-الهی",
                },
                {
                  "id": 11,
                  "category_id": 4,
                  "title":
                      "گوشه هاى از اخلاق عظيم پيامبر (صلی الله علیه و آله) ",
                  "photo_url":
                      "https://haditv.co.uk/upload_list/source/Articles/FA/Untitled-1.png",
                  "article_date": "2017-12-07",
                  "article_url":
                      "https://fa.haditv.com/article/گوشه-هاى-از-اخلاق-عظيم-پيامبر-صلی-الله-علیه-و-آله",
                },
              ],
            },
          ),
        );

        // Act
        final result = await dataSource.getArticles();

        // Assert
        expect(result, isA<List<ArticleModel>>());
        expect(result.length, 2);

        expect(result[0].id, 12);
        expect(result[0].title, "فدک عطیه الهی");

        verify(() => mockDio.get(ApiEndpoints.article)).called(1);
      });
      test("should throw exception when getCategories fails (500)", () async {
        // Arrange
        when(() => mockDio.get(ApiEndpoints.article)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ApiEndpoints.article),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: ApiEndpoints.article),
              statusCode: 500,
            ),
          ),
        );

        // Act
        final result = dataSource.getArticles();

        // Assert
        await expectLater(result, throwsA(isA<ServerFailure>()));

        verify(() => mockDio.get(ApiEndpoints.article)).called(1);
      });
    });
    group('getArticleContent', () {
      test(
        'should return ArticleDetailModel when getArticleContent succeeds',
        () async {
          // Arrange
          when(
            () => mockDio.post(
              ApiEndpoints.articleContent,
              queryParameters: {'id': 2},
            ),
          ).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: ApiEndpoints.articleContent),
              statusCode: 200,
              data: {
                'post': [
                  {
                    'id': 2,
                    'category_id': 4,
                    'title': 'امام هادی (علیه السلام)',
                    'content': 'محتوای مقاله...',
                    'photo_url': 'https://example.com/image.jpg',
                    'article_date': '2016-01-09',
                    'article_url': 'https://example.com/article',
                  },
                ],
              },
            ),
          );

          // Act
          final result = await dataSource.getArticleContent(2);

          // Assert
          expect(result, isA<ArticleDetailModel>());
          expect(result.id, 2);
          expect(result.title, 'امام هادی (علیه السلام)');

          verify(
            () => mockDio.post(
              ApiEndpoints.articleContent,
              queryParameters: {'id': 2},
            ),
          ).called(1);
        },
      );

      test(
        'should throw ServerFailure when getArticleContent fails with 500',
        () async {
          // Arrange
          when(
            () => mockDio.post(
              ApiEndpoints.articleContent,
              queryParameters: {'id': 2},
            ),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: ApiEndpoints.articleContent),
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: RequestOptions(
                  path: ApiEndpoints.articleContent,
                ),
                statusCode: 500,
              ),
            ),
          );

          // Act
          final result = dataSource.getArticleContent(2);

          // Assert
          await expectLater(result, throwsA(isA<ServerFailure>()));

          verify(
            () => mockDio.post(
              ApiEndpoints.articleContent,
              queryParameters: {'id': 2},
            ),
          ).called(1);
        },
      );
    });
  });
}
