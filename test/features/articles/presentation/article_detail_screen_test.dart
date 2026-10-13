import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:haditv/core/widgets/article_card.dart';
import 'package:haditv/core/widgets/error_widget.dart';
import 'package:haditv/features/articles/presentation/article_detail_screen.dart';
import 'package:haditv/features/articles/presentation/cubit/article_detail/article_detail_cubit.dart';
import 'package:haditv/features/articles/presentation/cubit/article_detail/article_detail_state.dart';
import 'package:haditv/features/articles/presentation/widgets/article_detail_skeleton.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/article/article_detail_fixtures.dart';
import '../../../fixtures/article/article_fixtures.dart';
import '../../../helper/mock_article_usecase.dart';
import '../../../helper/test_widget_wrapper.dart';

void main() {
  late MockArticleDetailCubit mockArticleDetailCubit;
  late MockBookmarkCubit mockBookmarkCubit;

  setUpAll(() {
    registerFallbackValue(ArticleFixtures.article);
  });

  setUp(() {
    mockArticleDetailCubit = MockArticleDetailCubit();
    mockBookmarkCubit = MockBookmarkCubit();

    when(() => mockBookmarkCubit.state).thenReturn(BookmarkInitial());
    when(() => mockBookmarkCubit.isArticleBookmarked(any())).thenReturn(false);
  });

  tearDown(() async {
    await mockBookmarkCubit.close();
    await mockArticleDetailCubit.close();
  });

  Widget buildWidgetWithBloc({required ArticleDetailState state}) {
    when(() => mockArticleDetailCubit.state).thenReturn(state);

    return createTestWidget(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ArticleDetailCubit>.value(value: mockArticleDetailCubit),
          BlocProvider<BookmarkCubit>.value(value: mockBookmarkCubit),
        ],
        child: ArticleDetailView(article: ArticleFixtures.article),
      ),
    );
  }

  group('ArticleDetailView Widget Tests', () {
    testWidgets(
      'renders ArticleDetailSkeleton when state is ArticleDetailLoading',
      (tester) async {
        await tester.pumpWidget(
          buildWidgetWithBloc(state: const ArticleDetailLoading()),
        );
        expect(find.byType(ArticleDetailSkeleton), findsOneWidget);
      },
    );
    testWidgets('renders CustomErrorWidget and handles retry', (tester) async {
      when(
        () => mockArticleDetailCubit.loadArticle(any()),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(
        buildWidgetWithBloc(
          state: const ArticleDetailError('server_error_msg'),
        ),
      );

      expect(find.byType(CustomErrorWidget), findsOneWidget);

      final retryButton = find.text('Retry');
      expect(retryButton, findsOneWidget);

      await tester.tap(retryButton);
      await tester.pump(const Duration(milliseconds: 100));

      verify(() => mockArticleDetailCubit.loadArticle(any())).called(1);

      // Clean up repeating animation before tear down
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });

    testWidgets(
      'renders article content, title, metadata, and HTML when loaded',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          buildWidgetWithBloc(
            state: ArticleDetailLoaded(
              article: ArticleDetailFixtures.articleDetail,
              relatedArticles: [
                ArticleFixtures.article2,
                ArticleFixtures.article3,
              ],
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));

        // Title
        expect(
          find.text(ArticleDetailFixtures.articleDetail.title),
          findsOneWidget,
        );

        // HTML Widget
        expect(find.byType(HtmlWidget), findsOneWidget);

        // Save & Share buttons
        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Share'), findsOneWidget);

        // Source button
        expect(find.text('Read Original Source'), findsOneWidget);

        // Related articles section
        expect(find.text('Related Articles'), findsOneWidget);
        expect(find.byType(ArticleCard), findsNWidgets(2));
      },
    );

    testWidgets('toggles bookmark when Save button is tapped', (tester) async {
      when(
        () => mockBookmarkCubit.toggleArticle(any()),
      ).thenAnswer((_) async => true);

      await tester.pumpWidget(
        buildWidgetWithBloc(
          state: ArticleDetailLoaded(
            article: ArticleDetailFixtures.articleDetail,
            relatedArticles: const [],
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      final saveButton = find.text('Save');
      expect(saveButton, findsOneWidget);

      await tester.tap(saveButton);
      await tester.pump(const Duration(milliseconds: 100));

      verify(() => mockBookmarkCubit.toggleArticle(any())).called(1);
    });

    testWidgets(
      'tapping related article calls loadArticle on ArticleDetailCubit',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        when(
          () => mockArticleDetailCubit.loadArticle(any()),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(
          buildWidgetWithBloc(
            state: ArticleDetailLoaded(
              article: ArticleDetailFixtures.articleDetail,
              relatedArticles: [ArticleFixtures.article2],
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));

        final relatedArticleFinder = find.text(ArticleFixtures.article2.title);
        expect(relatedArticleFinder, findsOneWidget);

        await tester.tap(relatedArticleFinder);
        await tester.pump(const Duration(milliseconds: 100));

        verify(
          () => mockArticleDetailCubit.loadArticle(ArticleFixtures.article2),
        ).called(1);
      },
    );
  });
}
