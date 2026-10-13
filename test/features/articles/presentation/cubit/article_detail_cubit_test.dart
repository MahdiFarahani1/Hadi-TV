import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/articles/domain/entities/article_detail.dart';
import 'package:haditv/features/articles/domain/usecases/get_article_content_usecase.dart';
import 'package:haditv/features/articles/presentation/cubit/article_detail/article_detail_cubit.dart';
import 'package:haditv/features/articles/presentation/cubit/article_detail/article_detail_state.dart';

import '../../../../fixtures/article/article_fixtures.dart';
import '../../../../helper/mock_article_usecase.dart';

class MockGetArticleContentUseCase extends Mock
    implements GetArticleContentUseCase {}

void main() {
  late MockGetArticlesUseCase mockGetArticlesUseCase;
  late MockGetArticleContentUseCase mockGetArticleContentUseCase;
  late ArticleDetailCubit cubit;

  setUp(() {
    mockGetArticlesUseCase = MockGetArticlesUseCase();
    mockGetArticleContentUseCase = MockGetArticleContentUseCase();
    cubit = ArticleDetailCubit(
      getArticlesUseCase: mockGetArticlesUseCase,
      getArticleContentUseCase: mockGetArticleContentUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  final tCurrentArticle = ArticleFixtures.article;

  final tArticleDetail = ArticleDetail(
    id: 1,
    categoryId: 10,
    title: 'Current Article Full',
    content: '<p>Content</p>',
    photoUrl: 'https://example.com/1.jpg',
    readTime: '3 min',
    createdAt: '2026-01-01',
    articleUrl: 'https://example.com/1',
  );

  final tAllArticles = [
    tCurrentArticle,
    ArticleFixtures.article2,
    ArticleFixtures.article3,
  ];

  test('initial state should be ArticleDetailInitial', () {
    expect(cubit.state, isA<ArticleDetailInitial>());
  });

  group('loadArticle', () {
    blocTest<ArticleDetailCubit, ArticleDetailState>(
      'emits [ArticleDetailLoading, ArticleDetailLoaded] and filters out the current article from related list on success',
      build: () {
        when(
          () => mockGetArticleContentUseCase(tCurrentArticle.id),
        ).thenAnswer((_) async => Right(tArticleDetail));
        when(
          () => mockGetArticlesUseCase(),
        ).thenAnswer((_) async => Right(tAllArticles));
        return cubit;
      },
      act: (cubit) => cubit.loadArticle(tCurrentArticle),
      expect: () => [
        isA<ArticleDetailLoading>(),
        isA<ArticleDetailLoaded>()
            .having(
              (state) => state.article.id,
              'article.id',
              tArticleDetail.id,
            )
            .having(
              (state) => state.relatedArticles.map((a) => a.id).toList(),
              'related articles excluding current article',
              [2, 3],
            ),
      ],
      verify: (_) {
        verify(
          () => mockGetArticleContentUseCase(tCurrentArticle.id),
        ).called(1);
        verify(() => mockGetArticlesUseCase()).called(1);
      },
    );

    blocTest<ArticleDetailCubit, ArticleDetailState>(
      'emits [ArticleDetailLoading, ArticleDetailError] when getArticleContentUseCase fails',
      build: () {
        when(() => mockGetArticleContentUseCase(tCurrentArticle.id)).thenAnswer(
          (_) async =>
              const Left(ServerFailure(message: 'Failed to load content')),
        );
        when(
          () => mockGetArticlesUseCase(),
        ).thenAnswer((_) async => Right(tAllArticles));
        return cubit;
      },
      act: (cubit) => cubit.loadArticle(tCurrentArticle),
      expect: () => [
        isA<ArticleDetailLoading>(),
        isA<ArticleDetailError>().having(
          (state) => state.message,
          'failure message',
          'Failed to load content',
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetArticleContentUseCase(tCurrentArticle.id),
        ).called(1);
        verify(() => mockGetArticlesUseCase()).called(1);
      },
    );

    blocTest<ArticleDetailCubit, ArticleDetailState>(
      'emits [ArticleDetailLoading, ArticleDetailError] when getArticlesUseCase fails',
      build: () {
        when(
          () => mockGetArticleContentUseCase(tCurrentArticle.id),
        ).thenAnswer((_) async => Right(tArticleDetail));
        when(() => mockGetArticlesUseCase()).thenAnswer(
          (_) async => const Left(
            ServerFailure(message: 'Failed to load related articles'),
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadArticle(tCurrentArticle),
      expect: () => [
        isA<ArticleDetailLoading>(),
        isA<ArticleDetailError>().having(
          (state) => state.message,
          'failure message',
          'Failed to load related articles',
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetArticleContentUseCase(tCurrentArticle.id),
        ).called(1);
        verify(() => mockGetArticlesUseCase()).called(1);
      },
    );
  });
}
