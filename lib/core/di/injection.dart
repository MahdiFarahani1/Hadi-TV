import 'package:get_it/get_it.dart';
import 'package:haditv/core/network/api_client.dart';

// Local DataSources
import 'package:haditv/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:haditv/features/search/data/datasources/search_local_data_source.dart';
import 'package:haditv/features/bookmark/data/datasources/bookmark_local_data_source.dart';
import 'package:haditv/features/onboarding/data/datasources/onboarding_local_data_source.dart';

// Home Feature
import 'package:haditv/features/home/data/repositories/home_repository_impl.dart';
import 'package:haditv/features/home/domain/repositories/home_repository.dart';
import 'package:haditv/features/home/domain/usecases/get_home_content_usecase.dart';

// Videos Feature
import 'package:haditv/features/videos/data/datasources/video_remote_data_source.dart';
import 'package:haditv/features/videos/data/repositories/video_repository_impl.dart';
import 'package:haditv/features/videos/domain/repositories/video_repository.dart';
import 'package:haditv/features/videos/domain/usecases/get_videos_usecase.dart';
import 'package:haditv/features/videos/domain/usecases/get_video_categories_usecase.dart';
import 'package:haditv/features/videos/domain/usecases/get_speakers_usecase.dart';

// Articles Feature
import 'package:haditv/features/articles/data/datasources/article_remote_data_source.dart';
import 'package:haditv/features/articles/data/repositories/article_repository_impl.dart';
import 'package:haditv/features/articles/domain/repositories/article_repository.dart';
import 'package:haditv/features/articles/domain/usecases/get_articles_usecase.dart';
import 'package:haditv/features/articles/domain/usecases/get_article_categories_usecase.dart';
import 'package:haditv/features/articles/domain/usecases/get_article_content_usecase.dart';

// Live TV Feature
import 'package:haditv/features/live_tv/data/datasources/live_tv_remote_data_source.dart';
import 'package:haditv/features/live_tv/data/repositories/live_tv_repository_impl.dart';
import 'package:haditv/features/live_tv/domain/repositories/live_tv_repository.dart';
import 'package:haditv/features/live_tv/domain/usecases/get_live_channels_usecase.dart';

// Settings Feature
import 'package:haditv/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:haditv/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:haditv/features/settings/domain/repositories/settings_repository.dart';
import 'package:haditv/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:haditv/features/settings/domain/usecases/get_languages_usecase.dart';
import 'package:haditv/features/settings/presentation/cubit/settings_cubit.dart';

// Search Feature
import 'package:haditv/features/search/data/repositories/search_repository_impl.dart';
import 'package:haditv/features/search/domain/repositories/search_repository.dart';
import 'package:haditv/features/search/domain/usecases/perform_global_search_usecase.dart';
import 'package:haditv/features/search/presentation/cubit/search_cubit.dart';

// Bookmark Feature
import 'package:haditv/features/bookmark/data/repositories/bookmark_repository_impl.dart';
import 'package:haditv/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:haditv/features/bookmark/domain/usecases/get_bookmarks_usecase.dart';
import 'package:haditv/features/bookmark/domain/usecases/toggle_bookmark_usecase.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_cubit.dart';

// Onboarding Feature
import 'package:haditv/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:haditv/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:haditv/features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import 'package:haditv/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:haditv/features/onboarding/presentation/cubit/onboarding_cubit.dart';

// Volume Feature
import 'package:haditv/features/volume/data/datasources/volume_local_data_source.dart';
import 'package:haditv/features/volume/data/repositories/volume_repository_impl.dart';
import 'package:haditv/features/volume/domain/repositories/volume_repository.dart';
import 'package:haditv/features/volume/domain/usecases/get_volume_usecase.dart';
import 'package:haditv/features/volume/domain/usecases/set_volume_usecase.dart';
import 'package:haditv/features/volume/domain/usecases/watch_volume_usecase.dart';
import 'package:haditv/features/volume/presentation/cubit/volume_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // ── Core Local DataSources ────────────────────────────────────────────────
  if (!getIt.isRegistered<SettingsLocalDataSource>()) {
    getIt.registerLazySingleton<SettingsLocalDataSource>(
      () => SettingsLocalDataSourceImpl(),
    );
  }
  if (!getIt.isRegistered<SearchLocalDataSource>()) {
    getIt.registerLazySingleton<SearchLocalDataSource>(
      () => SearchLocalDataSourceImpl(),
    );
  }
  if (!getIt.isRegistered<BookmarkLocalDataSource>()) {
    getIt.registerLazySingleton<BookmarkLocalDataSource>(
      () => BookmarkLocalDataSourceImpl(),
    );
  }

  if (!getIt.isRegistered<OnboardingLocalDataSource>()) {
    getIt.registerLazySingleton<OnboardingLocalDataSource>(
      () => OnboardingLocalDataSourceImpl(),
    );
  }

  // ── Core Network ──────────────────────────────────────────────────────────
  if (!getIt.isRegistered<ApiClient>()) {
    getIt.registerLazySingleton<ApiClient>(
      () => ApiClient(getIt<SettingsLocalDataSource>()),
    );
  }

  // ── Videos Feature dependencies ───────────────────────────────────────────
  if (!getIt.isRegistered<VideoRemoteDataSource>()) {
    getIt.registerLazySingleton<VideoRemoteDataSource>(
      () => VideoRemoteDataSource(getIt<ApiClient>()),
    );
  }
  if (!getIt.isRegistered<VideoRepository>()) {
    getIt.registerLazySingleton<VideoRepository>(
      () => VideoRepositoryImpl(getIt<VideoRemoteDataSource>()),
    );
  }
  if (!getIt.isRegistered<GetVideosUseCase>()) {
    getIt.registerLazySingleton<GetVideosUseCase>(
      () => GetVideosUseCase(getIt<VideoRepository>()),
    );
  }
  if (!getIt.isRegistered<GetVideoCategoriesUseCase>()) {
    getIt.registerLazySingleton<GetVideoCategoriesUseCase>(
      () => GetVideoCategoriesUseCase(getIt<VideoRepository>()),
    );
  }
  if (!getIt.isRegistered<GetSpeakersUsecase>()) {
    getIt.registerLazySingleton<GetSpeakersUsecase>(
      () => GetSpeakersUsecase(getIt<VideoRepository>()),
    );
  }

  // ── Articles Feature dependencies ─────────────────────────────────────────
  if (!getIt.isRegistered<ArticleRemoteDataSource>()) {
    getIt.registerLazySingleton<ArticleRemoteDataSource>(
      () => ArticleRemoteDataSource(getIt<ApiClient>()),
    );
  }
  if (!getIt.isRegistered<ArticleRepository>()) {
    getIt.registerLazySingleton<ArticleRepository>(
      () => ArticleRepositoryImpl(getIt<ArticleRemoteDataSource>()),
    );
  }
  if (!getIt.isRegistered<GetArticlesUseCase>()) {
    getIt.registerLazySingleton<GetArticlesUseCase>(
      () => GetArticlesUseCase(getIt<ArticleRepository>()),
    );
  }
  if (!getIt.isRegistered<GetArticleCategoriesUseCase>()) {
    getIt.registerLazySingleton<GetArticleCategoriesUseCase>(
      () => GetArticleCategoriesUseCase(getIt<ArticleRepository>()),
    );
  }
  if (!getIt.isRegistered<GetArticleContentUseCase>()) {
    getIt.registerLazySingleton<GetArticleContentUseCase>(
      () => GetArticleContentUseCase(getIt<ArticleRepository>()),
    );
  }

  // ── Live TV Feature dependencies ──────────────────────────────────────────
  if (!getIt.isRegistered<LiveTvRemoteDataSource>()) {
    getIt.registerLazySingleton<LiveTvRemoteDataSource>(
      () => LiveTvRemoteDataSource(getIt<ApiClient>()),
    );
  }
  if (!getIt.isRegistered<LiveTvRepository>()) {
    getIt.registerLazySingleton<LiveTvRepository>(
      () => LiveTvRepositoryImpl(getIt<LiveTvRemoteDataSource>()),
    );
  }
  if (!getIt.isRegistered<GetLiveChannelsUseCase>()) {
    getIt.registerLazySingleton<GetLiveChannelsUseCase>(
      () => GetLiveChannelsUseCase(getIt<LiveTvRepository>()),
    );
  }

  // ── Home Feature dependencies ─────────────────────────────────────────────
  if (!getIt.isRegistered<HomeRepository>()) {
    getIt.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(
        videoRepository: getIt<VideoRepository>(),
        articleRepository: getIt<ArticleRepository>(),
        liveTvRepository: getIt<LiveTvRepository>(),
      ),
    );
  }
  if (!getIt.isRegistered<GetHomeContentUseCase>()) {
    getIt.registerLazySingleton<GetHomeContentUseCase>(
      () => GetHomeContentUseCase(getIt<HomeRepository>()),
    );
  }

  // ── Settings Feature dependencies ─────────────────────────────────────────
  if (!getIt.isRegistered<SettingsRemoteDataSource>()) {
    getIt.registerLazySingleton<SettingsRemoteDataSource>(
      () => SettingsRemoteDataSource(getIt<ApiClient>()),
    );
  }
  if (!getIt.isRegistered<SettingsRepository>()) {
    getIt.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(
        remoteDataSource: getIt<SettingsRemoteDataSource>(),
        localDataSource: getIt<SettingsLocalDataSource>(),
      ),
    );
  }
  if (!getIt.isRegistered<GetSettingsUseCase>()) {
    getIt.registerLazySingleton<GetSettingsUseCase>(
      () => GetSettingsUseCase(getIt<SettingsRepository>()),
    );
  }
  if (!getIt.isRegistered<GetLanguagesUseCase>()) {
    getIt.registerLazySingleton<GetLanguagesUseCase>(
      () => GetLanguagesUseCase(getIt<SettingsRepository>()),
    );
  }
  if (!getIt.isRegistered<SettingsCubit>()) {
    getIt.registerFactory<SettingsCubit>(
      () => SettingsCubit(
        getSettingsUseCase: getIt<GetSettingsUseCase>(),
        getLanguagesUseCase: getIt<GetLanguagesUseCase>(),
        settingsRepository: getIt<SettingsRepository>(),
      ),
    );
  }

  // ── Search Feature dependencies ───────────────────────────────────────────
  if (!getIt.isRegistered<SearchRepository>()) {
    getIt.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(
        videoRepository: getIt<VideoRepository>(),
        articleRepository: getIt<ArticleRepository>(),
        searchLocalDataSource: getIt<SearchLocalDataSource>(),
      ),
    );
  }
  if (!getIt.isRegistered<PerformGlobalSearchUseCase>()) {
    getIt.registerLazySingleton<PerformGlobalSearchUseCase>(
      () => PerformGlobalSearchUseCase(getIt<SearchRepository>()),
    );
  }
  if (!getIt.isRegistered<SearchCubit>()) {
    getIt.registerFactory<SearchCubit>(
      () => SearchCubit(
        performGlobalSearchUseCase: getIt<PerformGlobalSearchUseCase>(),
        searchRepository: getIt<SearchRepository>(),
      ),
    );
  }

  // ── Bookmark Feature dependencies ─────────────────────────────────────────
  if (!getIt.isRegistered<BookmarkRepository>()) {
    getIt.registerLazySingleton<BookmarkRepository>(
      () => BookmarkRepositoryImpl(getIt<BookmarkLocalDataSource>()),
    );
  }
  if (!getIt.isRegistered<GetBookmarksUseCase>()) {
    getIt.registerLazySingleton<GetBookmarksUseCase>(
      () => GetBookmarksUseCase(getIt<BookmarkRepository>()),
    );
  }
  if (!getIt.isRegistered<ToggleBookmarkUseCase>()) {
    getIt.registerLazySingleton<ToggleBookmarkUseCase>(
      () => ToggleBookmarkUseCase(getIt<BookmarkRepository>()),
    );
  }
  if (!getIt.isRegistered<BookmarkCubit>()) {
    getIt.registerLazySingleton<BookmarkCubit>(
      () => BookmarkCubit(
        getBookmarksUseCase: getIt<GetBookmarksUseCase>(),
        toggleBookmarkUseCase: getIt<ToggleBookmarkUseCase>(),
      ),
    );
  }

  // ── Onboarding Feature dependencies ───────────────────────────────────────
  if (!getIt.isRegistered<OnboardingRepository>()) {
    getIt.registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryImpl(getIt<OnboardingLocalDataSource>()),
    );
  }
  if (!getIt.isRegistered<GetOnboardingStatusUseCase>()) {
    getIt.registerLazySingleton<GetOnboardingStatusUseCase>(
      () => GetOnboardingStatusUseCase(getIt<OnboardingRepository>()),
    );
  }
  if (!getIt.isRegistered<CompleteOnboardingUseCase>()) {
    getIt.registerLazySingleton<CompleteOnboardingUseCase>(
      () => CompleteOnboardingUseCase(getIt<OnboardingRepository>()),
    );
  }
  if (!getIt.isRegistered<OnboardingCubit>()) {
    getIt.registerFactory<OnboardingCubit>(
      () => OnboardingCubit(
        completeOnboardingUseCase: getIt<CompleteOnboardingUseCase>(),
      ),
    );
  }

  // ── Volume Feature dependencies ───────────────────────────────────────────
  if (!getIt.isRegistered<VolumeLocalDataSource>()) {
    getIt.registerLazySingleton<VolumeLocalDataSource>(
      () => VolumeLocalDataSourceImpl(),
    );
  }
  if (!getIt.isRegistered<VolumeRepository>()) {
    getIt.registerLazySingleton<VolumeRepository>(
      () => VolumeRepositoryImpl(getIt<VolumeLocalDataSource>()),
    );
  }
  if (!getIt.isRegistered<GetVolumeUseCase>()) {
    getIt.registerLazySingleton<GetVolumeUseCase>(
      () => GetVolumeUseCase(getIt<VolumeRepository>()),
    );
  }
  if (!getIt.isRegistered<SetVolumeUseCase>()) {
    getIt.registerLazySingleton<SetVolumeUseCase>(
      () => SetVolumeUseCase(getIt<VolumeRepository>()),
    );
  }
  if (!getIt.isRegistered<WatchVolumeUseCase>()) {
    getIt.registerLazySingleton<WatchVolumeUseCase>(
      () => WatchVolumeUseCase(getIt<VolumeRepository>()),
    );
  }
  if (!getIt.isRegistered<VolumeCubit>()) {
    getIt.registerLazySingleton<VolumeCubit>(
      () => VolumeCubit(
        getVolumeUseCase: getIt<GetVolumeUseCase>(),
        setVolumeUseCase: getIt<SetVolumeUseCase>(),
        watchVolumeUseCase: getIt<WatchVolumeUseCase>(),
      ),
    );
  }
}
