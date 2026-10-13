import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/articles/domain/entities/article_category.dart';
import 'package:haditv/features/articles/domain/usecases/get_article_categories_usecase.dart';
import 'package:haditv/features/articles/presentation/cubit/article_list/article_list_cubit.dart';
import 'package:haditv/features/articles/presentation/cubit/article_list/article_list_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/article/article_cat_fixtures.dart';
import '../../../../fixtures/article/article_fixtures.dart';
import '../../../../helper/mock_article_usecase.dart';

class MockGetArticleCategoriesUseCase extends Mock
    implements GetArticleCategoriesUseCase {}

void main() {
  late MockGetArticlesUseCase mockGetArticlesUseCase;
  late MockGetArticleCategoriesUseCase mockGetCategoriesUseCase;
  late ArticleListCubit cubit;

  setUp(() {
    mockGetArticlesUseCase = MockGetArticlesUseCase();
    mockGetCategoriesUseCase = MockGetArticleCategoriesUseCase();

    cubit = ArticleListCubit(
      getArticlesUseCase: mockGetArticlesUseCase,
      getCategoriesUseCase: mockGetCategoriesUseCase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('ArticleListCubit', () {
    // ----------------------------------------------------------
    // Initial State
    // ----------------------------------------------------------

    test('initial state should be ArticleListInitial', () {
      expect(cubit.state, isA<ArticleListInitial>());
    });

    // ----------------------------------------------------------
    // loadInit
    // ----------------------------------------------------------

    group('loadInit', () {
      blocTest<ArticleListCubit, ArticleListState>(
        'emits [Loading, Loaded] when categories and articles succeed',
        build: () {
          when(
            () => mockGetCategoriesUseCase(),
          ).thenAnswer((_) async => Right(ArticleCategoryFixtures.categories));

          when(
            () => mockGetArticlesUseCase(),
          ).thenAnswer((_) async => Right(ArticleFixtures.articles));

          return cubit;
        },
        act: (cubit) => cubit.loadInit(),
        expect: () => [
          isA<ArticleListLoading>(),
          isA<ArticleListLoaded>()
              .having(
                (state) => state.categories.length,
                'all article cat length',
                ArticleCategoryFixtures.categories.length,
              )
              .having(
                (state) => state.allArticles.length,
                'allArticles length',
                ArticleFixtures.articles.length,
              )
              .having(
                (state) => state.filteredArticles.length,
                'filteredArticles length',
                ArticleFixtures.articles.length,
              )
              .having(
                (state) => state.selectedCategoryId,
                'selected category',
                0,
              ),
        ],
        verify: (_) {
          verify(() => mockGetCategoriesUseCase()).called(1);

          verify(() => mockGetArticlesUseCase()).called(1);
        },
      );

      blocTest<ArticleListCubit, ArticleListState>(
        'emits [Loading, Error] when categories fail',
        build: () {
          when(() => mockGetCategoriesUseCase()).thenAnswer(
            (_) async =>
                const Left(ServerFailure(message: 'Failed to load categories')),
          );

          when(
            () => mockGetArticlesUseCase(),
          ).thenAnswer((_) async => Right(ArticleFixtures.articles));

          return cubit;
        },
        act: (cubit) => cubit.loadInit(),
        expect: () => [
          isA<ArticleListLoading>(),
          isA<ArticleListError>().having(
            (state) => state.message,
            'error message',
            'Failed to load categories',
          ),
        ],
        verify: (_) {
          verify(() => mockGetCategoriesUseCase()).called(1);

          verify(() => mockGetArticlesUseCase()).called(1);
        },
      );

      blocTest<ArticleListCubit, ArticleListState>(
        'emits [Loading, Error] when articles fail',
        build: () {
          when(
            () => mockGetCategoriesUseCase(),
          ).thenAnswer((_) async => const Right(<ArticleCategory>[]));

          when(() => mockGetArticlesUseCase()).thenAnswer(
            (_) async =>
                const Left(ServerFailure(message: 'Failed to load articles')),
          );

          return cubit;
        },
        act: (cubit) => cubit.loadInit(),
        expect: () => [
          isA<ArticleListLoading>(),
          isA<ArticleListError>().having(
            (state) => state.message,
            'error message',
            'Failed to load articles',
          ),
        ],
        verify: (_) {
          verify(() => mockGetCategoriesUseCase()).called(1);

          verify(() => mockGetArticlesUseCase()).called(1);
        },
      );
    });

    // ----------------------------------------------------------
    // changeCategory
    // ----------------------------------------------------------

    group('changeCategory', () {
      blocTest<ArticleListCubit, ArticleListState>(
        'filters articles by selected category',
        build: () => cubit,
        seed: () {
          return ArticleListLoaded(
            categories: const [],
            allArticles: ArticleFixtures.articles,
            filteredArticles: ArticleFixtures.articles,
            selectedCategoryId: 0,
          );
        },
        act: (cubit) => cubit.changeCategory(20),
        expect: () => [
          isA<ArticleListLoaded>()
              .having(
                (state) => state.selectedCategoryId,
                'selected category',
                20,
              )
              .having(
                (state) => state.filteredArticles
                    .map((article) => article.id)
                    .toList(),
                'filtered articles',
                [2, 3],
              ),
        ],
      );

      blocTest<ArticleListCubit, ArticleListState>(
        'shows all articles when category id is 0',
        build: () => cubit,
        seed: () {
          return ArticleListLoaded(
            categories: const [],
            allArticles: ArticleFixtures.articles,
            filteredArticles: const [],
            selectedCategoryId: 20,
          );
        },
        act: (cubit) => cubit.changeCategory(0),
        expect: () => [
          isA<ArticleListLoaded>()
              .having(
                (state) => state.selectedCategoryId,
                'selected category',
                0,
              )
              .having(
                (state) => state.filteredArticles.length,
                'filtered articles count',
                ArticleFixtures.articles.length,
              ),
        ],
      );

      blocTest<ArticleListCubit, ArticleListState>(
        'emits empty filtered list when category has no articles',
        build: () => cubit,
        seed: () {
          return ArticleListLoaded(
            categories: const [],
            allArticles: ArticleFixtures.articles,
            filteredArticles: ArticleFixtures.articles,
            selectedCategoryId: 0,
          );
        },
        act: (cubit) => cubit.changeCategory(999),
        expect: () => [
          isA<ArticleListLoaded>()
              .having(
                (state) => state.selectedCategoryId,
                'selected category',
                999,
              )
              .having(
                (state) => state.filteredArticles,
                'filtered articles',
                isEmpty,
              ),
        ],
      );

      blocTest<ArticleListCubit, ArticleListState>(
        'does not emit a new state when current state is not Loaded',
        build: () => cubit,
        act: (cubit) => cubit.changeCategory(20),
        expect: () => [],
      );
    });
  });
}
