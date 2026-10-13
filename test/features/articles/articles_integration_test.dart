import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:haditv/config/localization/app_localizations_delegate.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/di/injection.dart';
import 'package:haditv/core/network/api_endpoints.dart';
import 'package:haditv/core/widgets/article_card.dart';
import 'package:haditv/features/articles/data/datasources/article_remote_data_source.dart';
import 'package:haditv/features/articles/data/repositories/article_repository_impl.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/articles/domain/usecases/get_article_categories_usecase.dart';
import 'package:haditv/features/articles/domain/usecases/get_article_content_usecase.dart';
import 'package:haditv/features/articles/domain/usecases/get_articles_usecase.dart';
import 'package:haditv/features/articles/presentation/article_detail_screen.dart';
import 'package:haditv/features/articles/presentation/articles_screen.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/article/article_fixtures.dart';
import '../../helper/mock_apiclient.dart';
import '../../helper/mock_article_usecase.dart';
import '../../helper/mock_dio.dart';

void main() {
  late MockApiClient mockApiClient;
  late MockDio mockDio;
  late MockBookmarkCubit mockBookmarkCubit;

  // Real Feature Articles Instances
  late ArticleRemoteDataSource realDataSource;
  late ArticleRepositoryImpl realRepository;
  late GetArticlesUseCase realGetArticlesUseCase;
  late GetArticleCategoriesUseCase realGetCategoriesUseCase;
  late GetArticleContentUseCase realGetArticleContentUseCase;

  // Raw API Response Data (simulating actual server payloads)
  final rawCategoriesPayload = {
    'articlegroup': [
      {'id': 10, 'parent_id': 0, 'title': 'Islamic History'},
      {'id': 20, 'parent_id': 0, 'title': 'Ethics & Manners'},
    ],
  };

  final rawArticlesPayload = {
    'articles': [
      {
        'id': 1,
        'category_id': 10,
        'title': 'History of Medina',
        'photo_url': 'https://example.com/medina.jpg',
        'article_date': '2026-01-01',
        'article_url': 'https://example.com/article/1',
      },
      {
        'id': 2,
        'category_id': 20,
        'title': 'Moral Philosophy',
        'photo_url': 'https://example.com/ethics.jpg',
        'article_date': '2026-01-02',
        'article_url': 'https://example.com/article/2',
      },
      {
        'id': 3,
        'category_id': 20,
        'title': 'Kindness in Everyday Life',
        'photo_url': 'https://example.com/kindness.jpg',
        'article_date': '2026-01-03',
        'article_url': 'https://example.com/article/3',
      },
    ],
  };

  final rawDetailArticle1Payload = {
    'post': [
      {
        'id': 1,
        'category_id': 10,
        'title': 'History of Medina Full Content',
        'content': '<p>Deep historical <b>insights</b> about Medina.</p>',
        'photo_url': 'https://example.com/medina_full.jpg',
        'article_date': '2026-01-01',
        'article_url': 'https://example.com/article/1',
      },
    ],
  };

  final rawDetailArticle2Payload = {
    'post': [
      {
        'id': 2,
        'category_id': 20,
        'title': 'Moral Philosophy In Depth',
        'content': '<p>Comprehensive guide to <i>ethics</i>.</p>',
        'photo_url': 'https://example.com/ethics_full.jpg',
        'article_date': '2026-01-02',
        'article_url': 'https://example.com/article/2',
      },
    ],
  };

  setUpAll(() {
    registerFallbackValue(ArticleFixtures.article);
  });

  setUp(() {
    // 1. Mock boundary dependencies (Network client and Bookmark dummy)
    mockApiClient = MockApiClient();
    mockDio = MockDio();
    when(() => mockApiClient.dio).thenReturn(mockDio);

    mockBookmarkCubit = MockBookmarkCubit();
    when(() => mockBookmarkCubit.state).thenReturn(BookmarkInitial());
    when(() => mockBookmarkCubit.isArticleBookmarked(any())).thenReturn(false);

    // 2. Instantiate REAL internal layers of the Articles feature
    realDataSource = ArticleRemoteDataSource(mockApiClient);
    realRepository = ArticleRepositoryImpl(realDataSource);
    realGetArticlesUseCase = GetArticlesUseCase(realRepository);
    realGetCategoriesUseCase = GetArticleCategoriesUseCase(realRepository);
    realGetArticleContentUseCase = GetArticleContentUseCase(realRepository);

    // 3. Register real UseCases in GetIt for UI/Cubit consumption
    if (getIt.isRegistered<GetArticlesUseCase>()) {
      getIt.unregister<GetArticlesUseCase>();
    }
    getIt.registerSingleton<GetArticlesUseCase>(realGetArticlesUseCase);

    if (getIt.isRegistered<GetArticleCategoriesUseCase>()) {
      getIt.unregister<GetArticleCategoriesUseCase>();
    }
    getIt.registerSingleton<GetArticleCategoriesUseCase>(
      realGetCategoriesUseCase,
    );

    if (getIt.isRegistered<GetArticleContentUseCase>()) {
      getIt.unregister<GetArticleContentUseCase>();
    }
    getIt.registerSingleton<GetArticleContentUseCase>(
      realGetArticleContentUseCase,
    );
  });

  tearDown(() async {
    await mockBookmarkCubit.close();
    await getIt.reset();
  });

  GoRouter createTestRouter() {
    return GoRouter(
      initialLocation: '/articles',
      routes: [
        GoRoute(
          path: '/articles',
          builder: (context, state) => const ArticlesScreen(),
        ),
        GoRoute(
          path: '/articles/detail/:id',
          builder: (context, state) {
            final article = state.extra as Article;
            return ArticleDetailScreen(article: article);
          },
        ),
      ],
    );
  }

  Widget createTestApp(GoRouter router) {
    return BlocProvider<BookmarkCubit>.value(
      value: mockBookmarkCubit,
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('fa')],
        routerConfig: router,
      ),
    );
  }

  testWidgets(
    'End-to-End Articles Integration Flow: Fake Network -> Real DataSource -> Real Repository -> Real UseCase -> Real Cubit -> Real UI',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Stub HTTP Network layer responses with raw JSON
      when(() => mockDio.get(ApiEndpoints.articleGroup)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.articleGroup),
          statusCode: 200,
          data: rawCategoriesPayload,
        ),
      );

      when(() => mockDio.get(ApiEndpoints.article)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.article),
          statusCode: 200,
          data: rawArticlesPayload,
        ),
      );

      when(
        () => mockDio.post(
          ApiEndpoints.articleContent,
          queryParameters: {'id': 1},
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.articleContent),
          statusCode: 200,
          data: rawDetailArticle1Payload,
        ),
      );

      when(
        () => mockDio.post(
          ApiEndpoints.articleContent,
          queryParameters: {'id': 2},
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.articleContent),
          statusCode: 200,
          data: rawDetailArticle2Payload,
        ),
      );

      // Start application at /articles
      final router = createTestRouter();
      await tester.pumpWidget(createTestApp(router));

      // Allow async chain (Network -> DataSource -> Repository -> UseCase -> Cubit -> UI) to complete
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 200));

      // ── Step 1: Verify data flowed from raw JSON all the way to ArticlesScreen ──
      expect(find.byType(ArticlesScreen), findsOneWidget);
      expect(find.text('Islamic History'), findsOneWidget);
      expect(find.text('Ethics & Manners'), findsOneWidget);
      expect(find.byType(ArticleCard), findsNWidgets(3));

      // ── Step 2: Interactive Filtering via real Cubit logic ──────────────────────
      await tester.tap(find.text('Islamic History'));
      await tester.pump(const Duration(milliseconds: 100));

      // Only Article 1 matches category 10
      expect(find.text('History of Medina'), findsOneWidget);
      expect(find.byType(ArticleCard), findsOneWidget);

      // ── Step 3: Navigate to ArticleDetailScreen via GoRouter ────────────────────
      await tester.tap(find.byType(ArticleCard));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 200));

      // Real ArticleDetailCubit loaded content via real UseCase & DataSource
      expect(find.byType(ArticleDetailScreen), findsOneWidget);
      expect(find.text('History of Medina Full Content'), findsOneWidget);
      expect(find.byType(HtmlWidget), findsOneWidget);

      // Verify related articles section rendered (excluding current article #1)
      expect(find.text('Related Articles'), findsOneWidget);

      // ── Step 4: Switch to a related article ─────────────────────────────────────
      final relatedArticleFinder = find.text('Moral Philosophy');
      expect(relatedArticleFinder, findsOneWidget);

      await tester.tap(relatedArticleFinder);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 200));

      // Verify detail screen fetched & updated to Article #2's content
      expect(find.text('Moral Philosophy In Depth'), findsOneWidget);
    },
  );
}
