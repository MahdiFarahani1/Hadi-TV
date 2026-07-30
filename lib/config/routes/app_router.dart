import 'package:go_router/go_router.dart';
import 'package:haditv/config/routes/app_route_name.dart';
import 'package:haditv/core/widgets/splash.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/bookmark/bookmark_view.dart';
import 'package:haditv/features/live_tv/domain/entities/live_channel.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/home/presentation/home_screen.dart';
import 'package:haditv/features/home/presentation/navigation_shell.dart';
import 'package:haditv/features/videos/presentation/videos_screen.dart';
import 'package:haditv/features/videos/presentation/video_detail_screen.dart';
import 'package:haditv/features/articles/presentation/articles_screen.dart';
import 'package:haditv/features/articles/presentation/article_detail_screen.dart';
import 'package:haditv/features/live_tv/presentation/live_tv_screen.dart';
import 'package:haditv/features/settings/presentation/settings_screen.dart';
import 'package:haditv/features/search/presentation/search_screen.dart';
import 'package:haditv/features/onboarding/presentation/onboarding_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return NavigationShell(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: RouteNames.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.videos,
          name: RouteNames.videos,
          builder: (context, state) => const VideosScreen(),
        ),
        GoRoute(
          path: AppRoutes.articles,
          name: RouteNames.articles,
          builder: (context, state) => const ArticlesScreen(),
        ),
        GoRoute(
          path: AppRoutes.bookmarks,
          name: RouteNames.bookmarks,
          builder: (context, state) => const BookmarkView(),
        ),
        GoRoute(
          path: AppRoutes.live,
          name: RouteNames.live,
          builder: (context, state) {
            final initialChannel = state.extra as LiveChannel?;
            return LiveTvScreen(initialChannel: initialChannel);
          },
        ),

        GoRoute(
          path: AppRoutes.settings,
          name: RouteNames.settings,
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),

    GoRoute(
      path: AppRoutes.onboarding,
      name: RouteNames.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),

    GoRoute(
      path: AppRoutes.videoDetail,
      name: RouteNames.videoDetail,
      builder: (context, state) {
        final video = state.extra as Video;
        return VideoDetailScreen(video: video);
      },
    ),

    GoRoute(
      path: AppRoutes.articleDetail,
      name: RouteNames.articleDetail,
      builder: (context, state) {
        final article = state.extra as Article;
        return ArticleDetailScreen(article: article);
      },
    ),

    GoRoute(
      path: AppRoutes.search,
      name: RouteNames.search,
      builder: (context, state) => const SearchScreen(),
    ),

    GoRoute(
      path: AppRoutes.splash,
      name: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
  ],
);
