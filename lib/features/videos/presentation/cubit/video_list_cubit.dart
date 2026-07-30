import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haditv/features/videos/domain/entities/speaker.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/videos/domain/entities/video_category.dart';
import 'package:haditv/features/videos/domain/usecases/get_speakers_usecase.dart';
import 'package:haditv/features/videos/domain/usecases/get_videos_usecase.dart';
import 'package:haditv/features/videos/domain/usecases/get_video_categories_usecase.dart';
import 'video_list_state.dart';

class VideoListCubit extends Cubit<VideoListState> {
  final GetVideosUseCase getVideosUseCase;
  final GetVideoCategoriesUseCase getCategoriesUseCase;
  final GetSpeakersUsecase getSpeakersUseCase;

  static const int _pageSize = 15;

  VideoListCubit({
    required this.getVideosUseCase,
    required this.getCategoriesUseCase,
    required this.getSpeakersUseCase,
  }) : super(const VideoListInitial());

  Future<void> loadInit({String lang = 'en'}) async {
    emit(const VideoListLoading());

    final catResult = await getCategoriesUseCase();
    final speakersResult = await getSpeakersUseCase(lang: lang);
    final vidResult = await getVideosUseCase(
      lang: lang,
      start: 0,
      limit: _pageSize,
    );

    List<VideoCategory> categories = [];
    List<Speaker> speakers = [];

    catResult.fold((_) => null, (c) => categories = c);
    speakersResult.fold((_) => null, (s) => speakers = s);

    vidResult.fold(
      (failure) => emit(VideoListError(failure.message)),
      (results) => emit(
        VideoListLoaded(
          categories: categories,
          speakers: speakers,
          videos: results,
          selectedCategory: 'All',
          selectedGid: null,
          selectedSpeakerId: null,
          start: 0,
          hasReachedMax: results.length < _pageSize,
        ),
      ),
    );
  }

  Future<void> changeCategory(
    int? gid,
    String categoryName, {
    String lang = 'en',
  }) async {
    if (state is VideoListLoaded) {
      final current = state as VideoListLoaded;

      emit(
        current.copyWith(
          selectedCategory: categoryName,
          selectedGid: () => gid,
          isItemsLoading: true,
        ),
      );

      final result = await getVideosUseCase(
        lang: lang,
        start: 0,
        limit: _pageSize,
        gid: gid,
        speakerId: current.selectedSpeakerId,
      );

      if (state is VideoListLoaded) {
        final latest = state as VideoListLoaded;
        result.fold(
          (failure) => emit(VideoListError(failure.message)),
          (results) => emit(
            latest.copyWith(
              videos: results,
              start: 0,
              hasReachedMax: results.length < _pageSize,
              isItemsLoading: false,
            ),
          ),
        );
      }
    }
  }

  Future<void> filterBySpeaker(int? speakerId, {String lang = 'en'}) async {
    if (state is VideoListLoaded) {
      final current = state as VideoListLoaded;

      emit(
        current.copyWith(
          selectedSpeakerId: () => speakerId,
          isItemsLoading: true,
        ),
      );

      final result = await getVideosUseCase(
        lang: lang,
        start: 0,
        limit: _pageSize,
        gid: current.selectedGid,
        speakerId: speakerId,
      );

      if (state is VideoListLoaded) {
        final latest = state as VideoListLoaded;
        result.fold(
          (failure) => emit(VideoListError(failure.message)),
          (results) => emit(
            latest.copyWith(
              videos: results,
              start: 0,
              hasReachedMax: results.length < _pageSize,
              isItemsLoading: false,
            ),
          ),
        );
      }
    }
  }

  bool _isLoadingMore = false;

  Future<void> loadMore({String lang = 'en'}) async {
    if (state is! VideoListLoaded) return;
    final current = state as VideoListLoaded;
    if (current.hasReachedMax ||
        current.isItemsLoading ||
        current.isLoadingMore ||
        _isLoadingMore) {
      return;
    }

    _isLoadingMore = true;
    emit(current.copyWith(isLoadingMore: true));

    final nextStart = current.videos.length;
    final result = await getVideosUseCase(
      lang: lang,
      start: nextStart,
      limit: _pageSize,
      gid: current.selectedGid,
      speakerId: current.selectedSpeakerId,
    );

    _isLoadingMore = false;

    if (state is VideoListLoaded) {
      final latest = state as VideoListLoaded;
      result.fold(
        (failure) {
          emit(latest.copyWith(isLoadingMore: false));
        },
        (results) {
          emit(
            latest.copyWith(
              videos: List<Video>.from(latest.videos)..addAll(results),
              start: nextStart,
              hasReachedMax: results.length < _pageSize,
              isLoadingMore: false,
            ),
          );
        },
      );
    }
  }
}
