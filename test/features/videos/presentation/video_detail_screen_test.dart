import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/core/widgets/video_card.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_state.dart';
import 'package:haditv/features/videos/domain/entities/speaker.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/videos/presentation/cubit/video_detail_cubit.dart';
import 'package:haditv/features/videos/presentation/cubit/video_detail_state.dart';
import 'package:haditv/features/videos/presentation/video_detail_screen.dart';
import 'package:haditv/features/videos/presentation/widgets/video_detail_skeleton.dart';
import 'package:haditv/features/volume/presentation/cubit/volume_cubit.dart';
import 'package:haditv/features/volume/presentation/cubit/volume_state.dart';

import 'package:mocktail/mocktail.dart';

import '../../../helper/test_widget_wrapper.dart';

class MockVideoDetailCubit extends MockCubit<VideoDetailState>
    implements VideoDetailCubit {}

class MockBookmarkCubit extends MockCubit<BookmarkState>
    implements BookmarkCubit {}

class MockVolumeCubit extends MockCubit<VolumeState> implements VolumeCubit {}

void main() {
  late MockVideoDetailCubit mockVideoDetailCubit;
  late MockBookmarkCubit mockBookmarkCubit;
  late VolumeCubit mockVolumeCubit;
  late List<Video> testVideos;
  Video video = const Video(
    id: 1,
    title: 'learn dota',
    description: 'learn dota description',
    img: '',
    videoUrl: 'url1',
    dateTime: 1700000000,
    showCounter: 1,
    photoUrl: '',
    speakerName: 'ashkan',
    speaker: Speaker(id: 1, name: 'ashkan', photoUrl: ''),
    categoryId: 1,
    speakerId: 1,
  );

  setUpAll(() {
    registerFallbackValue(video);
  });

  setUp(() {
    mockBookmarkCubit = MockBookmarkCubit();
    mockVideoDetailCubit = MockVideoDetailCubit();
    mockVolumeCubit = MockVolumeCubit();

    testVideos = [
      const Video(
        id: 101,
        title: 'Intro to Hadith',
        description: 'Description 1',
        img: '',
        videoUrl: 'url1',
        dateTime: 1700000000,
        showCounter: 10,
        photoUrl: '',
        speakerName: 'Speaker Alpha',
        speaker: Speaker(id: 10, name: 'Speaker Alpha', photoUrl: ''),
        categoryId: 1,
        speakerId: 10,
      ),
      const Video(
        id: 102,
        title: 'Ethics in Islam',
        description: 'Description 2',
        img: '',
        videoUrl: 'url2',
        dateTime: 1700000000,
        showCounter: 20,
        photoUrl: '',
        speakerName: 'Speaker Beta',
        speaker: Speaker(id: 20, name: 'Speaker Beta', photoUrl: ''),
        categoryId: 2,
        speakerId: 20,
      ),
    ];
    when(
      () => mockVolumeCubit.state,
    ).thenReturn(const VolumeState(volume: 0.5, lastNonZeroVolume: 0.5));
    when(() => mockBookmarkCubit.state).thenReturn(BookmarkInitial());
    when(() => mockBookmarkCubit.isVideoBookmarked(any())).thenReturn(false);
    when(() => mockVideoDetailCubit.loadVideo(any())).thenAnswer((_) async {});
  });

  tearDown(() async {
    await mockVideoDetailCubit.close();
    await mockBookmarkCubit.close();
    await mockVolumeCubit.close();
  });

  Widget buildWidget(VideoDetailState state) {
    when(() => mockVideoDetailCubit.state).thenReturn(state);
    return createTestWidget(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<VideoDetailCubit>.value(value: mockVideoDetailCubit),
          BlocProvider<BookmarkCubit>.value(value: mockBookmarkCubit),
          BlocProvider<VolumeCubit>.value(value: mockVolumeCubit),
        ],
        child: const Scaffold(body: VideoDetailView(showPlayer: false)),
      ),
    );
  }

  group('UI Test for VideoDetailView', () {
    testWidgets('renders VideoDetailLoading skeleton', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget(const VideoDetailLoading()));
      expect(find.byType(VideoDetailSkeleton), findsOneWidget);
    });
    testWidgets('renders VideoDetailError message', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget(const VideoDetailError('Error')));
      expect(find.text('Error'), findsOneWidget);
    });
    testWidgets('renders VideoDetailLoaded content', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildWidget(VideoDetailLoaded(video: video, relatedVideos: testVideos)),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text(video.title), findsOneWidget);
      expect(find.text(video.speakerName), findsOneWidget);
      expect(find.byType(VideoCard), findsNWidgets(testVideos.length));
    });

    testWidgets('loads related video when tapped', (tester) async {
      await tester.pumpWidget(
        buildWidget(VideoDetailLoaded(video: video, relatedVideos: testVideos)),
      );

      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.byType(VideoCard).first);

      verify(() => mockVideoDetailCubit.loadVideo(testVideos.first)).called(1);
    });
  });
}
