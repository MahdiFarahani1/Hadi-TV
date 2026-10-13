import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/videos/domain/entities/speaker.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/videos/domain/usecases/get_videos_usecase.dart';
import 'package:haditv/features/videos/presentation/cubit/video_detail_cubit.dart';
import 'package:haditv/features/videos/presentation/cubit/video_detail_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetVideosUseCase extends Mock implements GetVideosUseCase {}

void main() {
  late VideoDetailCubit cubit;
  late MockGetVideosUseCase mockGetVideosUseCase;

  const tSpeaker = Speaker(id: 1, name: 'reza', photoUrl: 'photo.url');

  const tVideo = Video(
    id: 1,
    title: 'video 1',
    description: 'desc 1',
    img: 'img.url',
    videoUrl: 'video.url',
    dateTime: 2020,
    showCounter: 2,
    photoUrl: 'photo.url',
    speakerName: 'reza',
    speaker: tSpeaker,
    categoryId: 5,
    speakerId: 1,
  );

  const tRelatedVideo = Video(
    id: 2,
    title: 'video 2',
    description: 'desc 2',
    img: 'img2.url',
    videoUrl: 'video2.url',
    dateTime: 2021,
    showCounter: 10,
    photoUrl: 'photo2.url',
    speakerName: 'reza',
    speaker: tSpeaker,
    categoryId: 5,
    speakerId: 1,
  );

  setUp(() {
    mockGetVideosUseCase = MockGetVideosUseCase();
    cubit = VideoDetailCubit(getVideosUseCase: mockGetVideosUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be VideoDetailInitial', () {
    expect(cubit.state, isA<VideoDetailInitial>());
  });

  group('loadVideo', () {
    blocTest<VideoDetailCubit, VideoDetailState>(
      'should emit [VideoDetailLoading, VideoDetailLoaded] with filtered related videos on success',
      build: () {
        when(
          () => mockGetVideosUseCase(
            gid: tVideo.categoryId,
            start: 0,
            limit: 6,
          ),
        ).thenAnswer((_) async => const Right([tVideo, tRelatedVideo]));
        return cubit;
      },
      act: (cubit) => cubit.loadVideo(tVideo),
      expect: () => [
        isA<VideoDetailLoading>(),
        isA<VideoDetailLoaded>()
            .having((s) => s.video, 'video', tVideo)
            .having((s) => s.relatedVideos, 'relatedVideos', [tRelatedVideo]),
      ],
      verify: (_) {
        verify(
          () => mockGetVideosUseCase(
            gid: tVideo.categoryId,
            start: 0,
            limit: 6,
          ),
        ).called(1);
      },
    );

    blocTest<VideoDetailCubit, VideoDetailState>(
      'should emit [VideoDetailLoading, VideoDetailError] on failure',
      build: () {
        when(
          () => mockGetVideosUseCase(
            gid: tVideo.categoryId,
            start: 0,
            limit: 6,
          ),
        ).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server Error')),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadVideo(tVideo),
      expect: () => [
        isA<VideoDetailLoading>(),
        isA<VideoDetailError>().having(
          (s) => s.message,
          'message',
          'Server Error',
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetVideosUseCase(
            gid: tVideo.categoryId,
            start: 0,
            limit: 6,
          ),
        ).called(1);
      },
    );
  });
}
