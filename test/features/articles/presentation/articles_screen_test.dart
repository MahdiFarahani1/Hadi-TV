import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/core/widgets/article_card.dart';
import 'package:haditv/core/widgets/empty_widget.dart';
import 'package:haditv/features/articles/presentation/articles_screen.dart';
import 'package:haditv/features/articles/presentation/cubit/article_list/article_list_cubit.dart';
import 'package:haditv/features/articles/presentation/cubit/article_list/article_list_state.dart';
import 'package:haditv/features/articles/presentation/widgets/articles_skeleton.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/article/article_cat_fixtures.dart';
import '../../../fixtures/article/article_fixtures.dart';
import '../../../helper/mock_article_usecase.dart';
import '../../../helper/test_widget_wrapper.dart';

void main() {
  late MockArticleListCubit mockArticleListCubit;
  late MockBookmarkCubit mockBookmarkCubit;

  setUp(() {
    mockArticleListCubit = MockArticleListCubit();
    mockBookmarkCubit = MockBookmarkCubit();

    when(() => mockBookmarkCubit.state).thenReturn(BookmarkInitial());

    when(() => mockBookmarkCubit.isArticleBookmarked(any())).thenReturn(false);
  });

  tearDown(() async {
    await mockArticleListCubit.close();
    await mockBookmarkCubit.close();
  });

  Widget buildWidget(ArticleListState state) {
    when(() => mockArticleListCubit.state).thenReturn(state);

    return createTestWidget(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ArticleListCubit>.value(value: mockArticleListCubit),
          BlocProvider<BookmarkCubit>.value(value: mockBookmarkCubit),
        ],
        child: const Scaffold(body: ArticlesView()),
      ),
    );
  }

  group('ArticlesView', () {
    testWidgets('shows skeleton when state is loading', (tester) async {
      await tester.pumpWidget(buildWidget(const ArticleListLoading()));

      expect(find.byType(ArticlesSkeleton), findsOneWidget);
    });

    testWidgets('shows error message and calls loadInit when retry is tapped', (
      tester,
    ) async {
      when(() => mockArticleListCubit.loadInit()).thenAnswer((_) async {});

      await tester.pumpWidget(
        buildWidget(const ArticleListError('Network Error')),
      );

      expect(find.text('Network Error'), findsOneWidget);

      final retryButton = find.widgetWithText(ElevatedButton, 'Retry');

      expect(retryButton, findsOneWidget);

      await tester.tap(retryButton);

      await tester.pump();

      verify(() => mockArticleListCubit.loadInit()).called(1);
    });

    testWidgets('shows categories and articles when state is loaded', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWidget(
          ArticleListLoaded(
            categories: ArticleCategoryFixtures.categories,
            allArticles: ArticleFixtures.articles,
            filteredArticles: ArticleFixtures.articles,
            selectedCategoryId: 0,
          ),
        ),
      );

      expect(
        find.byType(ChoiceChip),
        findsNWidgets(ArticleCategoryFixtures.categories.length + 1),
      );

      expect(
        find.byType(ArticleCard),
        findsNWidgets(ArticleFixtures.articles.length),
      );

      expect(find.text('Test Article'), findsOneWidget);
    });

    testWidgets('calls changeCategory when category chip is tapped', (
      tester,
    ) async {
      when(() => mockArticleListCubit.changeCategory(any())).thenReturn(null);

      await tester.pumpWidget(
        buildWidget(
          ArticleListLoaded(
            categories: ArticleCategoryFixtures.categories,
            allArticles: ArticleFixtures.articles,
            filteredArticles: ArticleFixtures.articles,
            selectedCategoryId: 0,
          ),
        ),
      );

      final category = ArticleCategoryFixtures.categories.first;

      final categoryChip = find.widgetWithText(ChoiceChip, category.title);

      expect(categoryChip, findsOneWidget);

      await tester.tap(categoryChip);

      await tester.pump();

      verify(() => mockArticleListCubit.changeCategory(category.id)).called(1);
    });

    testWidgets(
      'shows empty widget and calls changeCategory(0) when there are no filtered articles',
      (tester) async {
        when(() => mockArticleListCubit.changeCategory(0)).thenReturn(null);

        await tester.pumpWidget(
          buildWidget(
            ArticleListLoaded(
              categories: ArticleCategoryFixtures.categories,
              allArticles: ArticleFixtures.articles,
              filteredArticles: const [],
              selectedCategoryId: 99,
            ),
          ),
        );

        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(AppEmptyWidget), findsOneWidget);

        final showAllButton = find.text('Show All Articles');

        expect(showAllButton, findsOneWidget);

        await tester.tap(showAllButton);

        await tester.pump(const Duration(milliseconds: 500));

        verify(() => mockArticleListCubit.changeCategory(0)).called(1);
      },
    );
  });
}
