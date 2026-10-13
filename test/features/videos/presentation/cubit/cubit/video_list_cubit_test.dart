import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/videos/domain/entities/speaker.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/videos/domain/entities/video_category.dart';
import 'package:haditv/features/videos/domain/usecases/get_speakers_usecase.dart';
import 'package:haditv/features/videos/domain/usecases/get_video_categories_usecase.dart';
import 'package:haditv/features/videos/domain/usecases/get_videos_usecase.dart';
import 'package:haditv/features/videos/presentation/cubit/video_list_cubit.dart';
import 'package:haditv/features/videos/presentation/cubit/video_list_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetVideosUseCase extends Mock implements GetVideosUseCase {}

class MockGetCategoriesUseCase extends Mock
    implements GetVideoCategoriesUseCase {}

class MockGetSpeakersUseCase extends Mock implements GetSpeakersUsecase {}

void main() {
  late VideoListCubit videoCubit;
  late MockGetVideosUseCase mockGetVideosUseCase;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockGetSpeakersUseCase mockGetSpeakersUseCase;
  late List<Video> videos;
  late List<VideoCategory> categories;
  late List<Speaker> speakers;
  setUp(() {
    videos = [
      const Video(
        id: 1,
        title: 'video 1',
        description: 'description',
        img: 'img.url',
        videoUrl: 'video.url',
        dateTime: 2020,
        showCounter: 2,
        photoUrl: 'photo.url',
        speakerName: 'reza',
        speaker: const Speaker(id: 1, name: 'reza', photoUrl: 'photo.url'),
        categoryId: 1,
        speakerId: 1,
      ),
      const Video(
        id: 2,
        title: 'video 2',
        description: 'description 2',
        img: 'img 2.url',
        videoUrl: 'video 2.url',
        dateTime: 2022,
        showCounter: 22,
        photoUrl: 'photo.url',
        speakerName: 'reza',
        speaker: const Speaker(id: 2, name: 'mahdi', photoUrl: 'photo.url'),
        categoryId: 2,
        speakerId: 2,
      ),
    ];
    categories = [
      const VideoCategory(id: 1, title: 'cat 1', parentId: 0),
      const VideoCategory(id: 2, title: 'cat 2', parentId: 2),
    ];
    speakers = [
      const Speaker(id: 1, name: 'reza', photoUrl: 'photo.url'),
      const Speaker(id: 2, name: 'mahdi', photoUrl: 'photo.url'),
    ];
    mockGetVideosUseCase = MockGetVideosUseCase();
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockGetSpeakersUseCase = MockGetSpeakersUseCase();
    videoCubit = VideoListCubit(
      getVideosUseCase: mockGetVideosUseCase,
      getCategoriesUseCase: mockGetCategoriesUseCase,
      getSpeakersUseCase: mockGetSpeakersUseCase,
    );
  });

  tearDown(() {
    videoCubit.close();
  });
  group('VideoListCubit', () {
    test('initial state should be VideoListInitial', () {
      expect(videoCubit.state, isA<VideoListInitial>());
    });
    group('loadInit', () {
      blocTest<VideoListCubit, VideoListState>(
        'should return list of videos / cat videos / speakers successfully',
        build: () {
          when(
            () => mockGetVideosUseCase.call(start: 0, limit: 15, lang: 'en'),
          ).thenAnswer((_) async => Right(videos));
          when(
            () => mockGetCategoriesUseCase.call(),
          ).thenAnswer((_) async => Right(categories));
          when(
            () => mockGetSpeakersUseCase.call(lang: 'en'),
          ).thenAnswer((_) async => Right(speakers));
          return videoCubit;
        },
        act: (cubit) {
          cubit.loadInit();
        },
        expect: () {
          return [
            isA<VideoListLoading>(),
            isA<VideoListLoaded>()
                .having((state) => state.videos, 'videos', equals(videos))
                .having(
                  (state) => state.categories,
                  'categories',
                  equals(categories),
                )
                .having(
                  (state) => state.speakers,
                  'speakers',
                  equals(speakers),
                ),
          ];
        },
        verify: (_) {
          verify(
            () => mockGetVideosUseCase.call(lang: 'en', start: 0, limit: 15),
          ).called(1);
          verify(() => mockGetCategoriesUseCase.call()).called(1);
          verify(() => mockGetSpeakersUseCase.call(lang: 'en')).called(1);
        },
      );

      blocTest<VideoListCubit, VideoListState>(
        'should return Error of videos / cat videos / speakers',
        build: () {
          when(
            () => mockGetVideosUseCase.call(start: 0, limit: 15, lang: 'en'),
          ).thenAnswer(
            (_) async =>
                const Left(ServerFailure(message: 'Failed to load videos')),
          );
          when(
            () => mockGetCategoriesUseCase.call(),
          ).thenAnswer((_) async => const Left(ServerFailure(message: '')));
          when(
            () => mockGetSpeakersUseCase.call(lang: 'en'),
          ).thenAnswer((_) async => const Left(ServerFailure(message: '')));
          return videoCubit;
        },
        act: (cubit) {
          cubit.loadInit();
        },
        expect: () {
          return [
            isA<VideoListLoading>(),
            isA<VideoListError>().having(
              (state) => state.message,
              'message',
              equals('Failed to load videos'),
            ),
          ];
        },
        verify: (_) {
          verify(
            () => mockGetVideosUseCase.call(lang: 'en', start: 0, limit: 15),
          ).called(1);
          verify(() => mockGetCategoriesUseCase.call()).called(1);
          verify(() => mockGetSpeakersUseCase.call(lang: 'en')).called(1);
        },
      );
    });

    group('change category', () {
      blocTest<VideoListCubit, VideoListState>(
        'should change category and load videos successfully',
        build: () {
          when(
            () => mockGetVideosUseCase.call(
              lang: 'en',
              start: 0,
              limit: 15,
              gid: 2,
              speakerId: 1,
            ),
          ).thenAnswer((_) async => Right(videos));

          return videoCubit;
        },
        seed: () {
          return VideoListLoaded(
            videos: videos,
            categories: categories,
            speakers: speakers,
            selectedCategory: 'cat 1',
            selectedGid: 1,
            selectedSpeakerId: 1,
            start: 0,
            hasReachedMax: false,
            isItemsLoading: false,
          );
        },
        act: (cubit) => cubit.changeCategory(2, 'cat 2'),
        expect: () => [
          isA<VideoListLoaded>()
              .having(
                (state) => state.selectedCategory,
                'selected category',
                'cat 2',
              )
              .having((state) => state.selectedGid, 'selected gid', 2)
              .having(
                (state) => state.isItemsLoading,
                'is items loading',
                true,
              ),
          isA<VideoListLoaded>()
              .having((state) => state.videos, 'videos', equals(videos))
              .having((state) => state.start, 'start', 0)
              .having((state) => state.hasReachedMax, 'has reached max', true)
              .having(
                (state) => state.isItemsLoading,
                'is items loading',
                false,
              ),
        ],
        verify: (_) {
          verify(
            () => mockGetVideosUseCase.call(
              lang: 'en',
              start: 0,
              limit: 15,
              gid: 2,
              speakerId: 1,
            ),
          ).called(1);
        },
      );

      blocTest<VideoListCubit, VideoListState>(
        'should emit error when loading category videos fails',
        build: () {
          when(
            () => mockGetVideosUseCase.call(
              lang: 'en',
              start: 0,
              limit: 15,
              gid: 2,
              speakerId: 1,
            ),
          ).thenAnswer(
            (_) async =>
                const Left(ServerFailure(message: 'Failed to load videos')),
          );

          return videoCubit;
        },
        seed: () {
          return VideoListLoaded(
            videos: videos,
            categories: categories,
            speakers: speakers,
            selectedCategory: 'cat 1',
            selectedGid: 1,
            selectedSpeakerId: 1,
            start: 0,
            hasReachedMax: false,
            isItemsLoading: false,
          );
        },
        act: (cubit) => cubit.changeCategory(2, 'cat 2'),
        expect: () => [
          isA<VideoListLoaded>()
              .having(
                (state) => state.selectedCategory,
                'selected category',
                'cat 2',
              )
              .having((state) => state.selectedGid, 'selected gid', 2)
              .having(
                (state) => state.isItemsLoading,
                'is items loading',
                true,
              ),
          isA<VideoListError>().having(
            (state) => state.message,
            'message',
            'Failed to load videos',
          ),
        ],
        verify: (_) {
          verify(
            () => mockGetVideosUseCase.call(
              lang: 'en',
              start: 0,
              limit: 15,
              gid: 2,
              speakerId: 1,
            ),
          ).called(1);
        },
      );
    });

    group('filterBySpeaker', () {
      blocTest<VideoListCubit, VideoListState>(
        'should fillter videos by speakers and load videos successfully',
        build: () {
          when(
            () => mockGetVideosUseCase.call(
              lang: 'en',
              start: 0,
              limit: 15,
              gid: 1,
              speakerId: 2,
            ),
          ).thenAnswer((_) async => Right(videos));

          return videoCubit;
        },
        seed: () {
          return VideoListLoaded(
            videos: videos,
            categories: categories,
            speakers: speakers,
            selectedCategory: 'cat 1',
            selectedGid: 1,
            selectedSpeakerId: 1,
            start: 0,
            hasReachedMax: videos.length < 15,
            isItemsLoading: false,
          );
        },
        act: (cubit) => cubit.filterBySpeaker(2),
        expect: () => [
          isA<VideoListLoaded>()
              .having(
                (state) => state.selectedSpeakerId,
                'selected speakerId',
                2,
              )
              .having((state) => state.selectedGid, 'selected gid', 1)
              .having(
                (state) => state.isItemsLoading,

                'is items loading',
                true,
              ),
          isA<VideoListLoaded>().having(
            (state) => state.videos,
            'videos',
            equals(videos),
          ),
        ],
        verify: (_) {
          verify(
            () => mockGetVideosUseCase.call(
              lang: 'en',
              start: 0,
              limit: 15,
              gid: 1,

              speakerId: 2,
            ),
          ).called(1);
        },
      );
      blocTest<VideoListCubit, VideoListState>(
        'should emit error when filtering videos by speaker fails',
        build: () {
          when(
            () => mockGetVideosUseCase.call(
              lang: 'en',
              start: 0,
              limit: 15,
              gid: 1,
              speakerId: 2,
            ),
          ).thenAnswer(
            (_) async =>
                const Left(ServerFailure(message: 'Failed to load videos')),
          );

          return videoCubit;
        },
        seed: () {
          return VideoListLoaded(
            videos: videos,
            categories: categories,
            speakers: speakers,
            selectedCategory: 'cat 1',
            selectedGid: 1,
            selectedSpeakerId: 1,
            start: 0,
            hasReachedMax: false,
            isItemsLoading: false,
          );
        },
        act: (cubit) => cubit.filterBySpeaker(2),
        expect: () => [
          isA<VideoListLoaded>()
              .having(
                (state) => state.selectedSpeakerId,
                'selected speakerId',
                2,
              )
              .having((state) => state.selectedGid, 'selected gid', 1)
              .having(
                (state) => state.isItemsLoading,
                'is items loading',
                true,
              ),
          isA<VideoListError>().having(
            (state) => state.message,
            'message',
            'Failed to load videos',
          ),
        ],
        verify: (_) {
          verify(
            () => mockGetVideosUseCase.call(
              lang: 'en',
              start: 0,
              limit: 15,
              gid: 1,
              speakerId: 2,
            ),
          ).called(1);
        },
      );
    });

    group('loadMore', () {
      blocTest<VideoListCubit, VideoListState>(
        'should load more videos successfully',
        build: () {
          when(
            () => mockGetVideosUseCase.call(
              lang: 'en',
              start: 2,
              limit: 15,
              gid: 1,
              speakerId: 1,
            ),
          ).thenAnswer(
            (_) async => Right([
              const Video(
                id: 3,
                title: 'video 3',
                description: 'description 3',
                img: 'img 3.url',
                videoUrl: 'video 3.url',
                dateTime: 2023,
                showCounter: 33,
                photoUrl: 'photo 3.url',
                speakerName: 'reza',
                speaker: Speaker(id: 1, name: 'reza', photoUrl: 'photo.url'),
                categoryId: 1,
                speakerId: 1,
              ),
            ]),
          );

          return videoCubit;
        },
        seed: () {
          return VideoListLoaded(
            videos: videos,
            categories: categories,
            speakers: speakers,
            selectedCategory: 'cat 1',
            selectedGid: 1,
            selectedSpeakerId: 1,
            start: 0,
            hasReachedMax: false,
            isItemsLoading: false,
            isLoadingMore: false,
          );
        },
        act: (cubit) => cubit.loadMore(),
        expect: () => [
          isA<VideoListLoaded>().having(
            (state) => state.isLoadingMore,
            'is loading more',
            true,
          ),
          isA<VideoListLoaded>()
              .having((state) => state.videos.length, 'videos length', 3)
              .having((state) => state.videos[2].id, 'new video id', 3)
              .having((state) => state.start, 'start', 2)
              .having((state) => state.hasReachedMax, 'has reached max', true)
              .having((state) => state.isLoadingMore, 'is loading more', false),
        ],
        verify: (_) {
          verify(
            () => mockGetVideosUseCase.call(
              lang: 'en',
              start: 2,
              limit: 15,
              gid: 1,
              speakerId: 1,
            ),
          ).called(1);
        },
      );
      blocTest<VideoListCubit, VideoListState>(
        'should stop loading more when loading more videos fails',
        build: () {
          when(
            () => mockGetVideosUseCase.call(
              lang: 'en',
              start: 2,
              limit: 15,
              gid: 1,
              speakerId: 1,
            ),
          ).thenAnswer(
            (_) async =>
                const Left(ServerFailure(message: 'Failed to load videos')),
          );

          return videoCubit;
        },
        seed: () {
          return VideoListLoaded(
            videos: videos,
            categories: categories,
            speakers: speakers,
            selectedCategory: 'cat 1',
            selectedGid: 1,
            selectedSpeakerId: 1,
            start: 0,
            hasReachedMax: false,
            isItemsLoading: false,
            isLoadingMore: false,
          );
        },
        act: (cubit) => cubit.loadMore(),
        expect: () => [
          isA<VideoListLoaded>().having(
            (state) => state.isLoadingMore,
            'is loading more',
            true,
          ),
          isA<VideoListLoaded>()
              .having((state) => state.videos, 'videos', equals(videos))
              .having((state) => state.isLoadingMore, 'is loading more', false),
        ],
        verify: (_) {
          verify(
            () => mockGetVideosUseCase.call(
              lang: 'en',
              start: 2,
              limit: 15,
              gid: 1,
              speakerId: 1,
            ),
          ).called(1);
        },
      );
      blocTest<VideoListCubit, VideoListState>(
        'should not load more when hasReachedMax is true',
        build: () => videoCubit,
        seed: () {
          return VideoListLoaded(
            videos: videos,
            categories: categories,
            speakers: speakers,
            selectedCategory: 'cat 1',
            selectedGid: 1,
            selectedSpeakerId: 1,
            start: 0,
            hasReachedMax: true,
            isItemsLoading: false,
            isLoadingMore: false,
          );
        },
        act: (cubit) => cubit.loadMore(),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => mockGetVideosUseCase.call(
              lang: 'en',
              start: 2,
              limit: 15,
              gid: 1,
              speakerId: 1,
            ),
          );
        },
      );
      blocTest<VideoListCubit, VideoListState>(
        'should not load more when items are loading',
        build: () => videoCubit,
        seed: () {
          return VideoListLoaded(
            videos: videos,
            categories: categories,
            speakers: speakers,
            selectedCategory: 'cat 1',
            selectedGid: 1,
            selectedSpeakerId: 1,
            start: 0,
            hasReachedMax: false,
            isItemsLoading: true,
            isLoadingMore: false,
          );
        },
        act: (cubit) => cubit.loadMore(),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => mockGetVideosUseCase.call(
              lang: 'en',
              start: 2,
              limit: 15,
              gid: 1,
              speakerId: 1,
            ),
          );
        },
      );
    });
  });
}
