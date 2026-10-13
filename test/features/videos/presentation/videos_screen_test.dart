import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/core/widgets/empty_widget.dart';
import 'package:haditv/core/widgets/error_widget.dart';
import 'package:haditv/core/widgets/video_card.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_state.dart';
import 'package:haditv/features/videos/domain/entities/speaker.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';
import 'package:haditv/features/videos/domain/entities/video_category.dart';
import 'package:haditv/features/videos/presentation/cubit/video_list_cubit.dart';
import 'package:haditv/features/videos/presentation/cubit/video_list_state.dart';
import 'package:haditv/features/videos/presentation/videos_screen.dart';
import 'package:haditv/features/videos/presentation/widgets/videos_skeleton.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helper/test_widget_wrapper.dart';

class MockVideoListCubit extends MockCubit<VideoListState>
    implements VideoListCubit {}

class MockBookmarkCubit extends MockCubit<BookmarkState>
    implements BookmarkCubit {}

void main() {
  late MockVideoListCubit mockVideoListCubit;
  late MockBookmarkCubit mockBookmarkCubit;

  final testCategories = [
    const VideoCategory(id: 1, title: 'Category 1', parentId: 0),
    const VideoCategory(id: 2, title: 'Category 2', parentId: 0),
  ];

  final testSpeakers = [
    const Speaker(id: 10, name: 'Scholar Ali', photoUrl: ''),
    const Speaker(id: 20, name: 'Scholar Reza', photoUrl: ''),
  ];

  final testVideos = [
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

  setUp(() {
    mockVideoListCubit = MockVideoListCubit();
    mockBookmarkCubit = MockBookmarkCubit();

    when(() => mockBookmarkCubit.state).thenReturn(BookmarkInitial());
    when(() => mockBookmarkCubit.isVideoBookmarked(any())).thenReturn(false);

    when(
      () => mockVideoListCubit.changeCategory(
        any(),
        any(),
        lang: any(named: 'lang'),
      ),
    ).thenAnswer((_) async {});

    when(
      () => mockVideoListCubit.filterBySpeaker(any(), lang: any(named: 'lang')),
    ).thenAnswer((_) async {});
  });

  tearDown(() async {
    await mockVideoListCubit.close();
    await mockBookmarkCubit.close();
  });

  Widget buildWidget(VideoListState state) {
    when(() => mockVideoListCubit.state).thenReturn(state);

    return createTestWidget(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<VideoListCubit>.value(value: mockVideoListCubit),
          BlocProvider<BookmarkCubit>.value(value: mockBookmarkCubit),
        ],
        child: const Scaffold(body: VideosView()),
      ),
    );
  }

  group('VideosView', () {
    testWidgets('shows skeleton when state is loading', (tester) async {
      await tester.pumpWidget(buildWidget(const VideoListLoading()));

      expect(find.byType(VideosSkeleton), findsOneWidget);
    });

    testWidgets('shows error widget and retries when tapped', (tester) async {
      when(() => mockVideoListCubit.loadInit()).thenAnswer((_) async {});

      await tester.pumpWidget(
        buildWidget(const VideoListError('Network Error')),
      );

      expect(find.byType(CustomErrorWidget), findsOneWidget);
      expect(find.text('Network Error'), findsOneWidget);

      final retryButton = find.text('Retry');
      expect(retryButton, findsOneWidget);

      await tester.tap(retryButton);
      await tester.pump(const Duration(milliseconds: 100));

      verify(() => mockVideoListCubit.loadInit()).called(1);

      // Clean up repeating animations before tearDown
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('shows categories, speakers, and video cards when loaded', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildWidget(
          VideoListLoaded(
            categories: testCategories,
            speakers: testSpeakers,
            videos: testVideos,
            selectedCategory: 'All Categories',
            start: 0,
            hasReachedMax: false,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Category 1'), findsOneWidget);
      expect(find.text('Scholar Ali'), findsOneWidget);
      expect(find.byType(VideoCard), findsNWidgets(testVideos.length));
      expect(find.text('Intro to Hadith'), findsOneWidget);
    });

    testWidgets('calls changeCategory when category chip is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWidget(
          VideoListLoaded(
            categories: testCategories,
            speakers: testSpeakers,
            videos: testVideos,
            selectedCategory: 'All Categories',
            start: 0,
            hasReachedMax: false,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      final categoryChip = find.text('Category 1');
      expect(categoryChip, findsOneWidget);

      await tester.tap(categoryChip);
      await tester.pump();

      verify(
        () => mockVideoListCubit.changeCategory(
          1,
          'Category 1',
          lang: any(named: 'lang'),
        ),
      ).called(1);
    });

    testWidgets('calls filterBySpeaker when speaker chip is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWidget(
          VideoListLoaded(
            categories: testCategories,
            speakers: testSpeakers,
            videos: testVideos,
            selectedCategory: 'All Categories',
            start: 0,
            hasReachedMax: false,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      final speakerChip = find.text('Scholar Ali');
      expect(speakerChip, findsOneWidget);

      await tester.tap(speakerChip);
      await tester.pump();

      verify(
        () => mockVideoListCubit.filterBySpeaker(10, lang: any(named: 'lang')),
      ).called(1);
    });

    testWidgets('shows empty widget and resets filters on action tap', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWidget(
          VideoListLoaded(
            categories: testCategories,
            speakers: testSpeakers,
            videos: const [],
            selectedCategory: 'Category 1',
            selectedGid: 1,
            start: 0,
            hasReachedMax: true,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AppEmptyWidget), findsOneWidget);

      final resetButton = find.text('Show All Videos');
      expect(resetButton, findsOneWidget);

      await tester.tap(resetButton);
      await tester.pump();

      verify(
        () => mockVideoListCubit.changeCategory(
          null,
          'All Categories',
          lang: any(named: 'lang'),
        ),
      ).called(1);
      verify(
        () =>
            mockVideoListCubit.filterBySpeaker(null, lang: any(named: 'lang')),
      ).called(1);
    });

    testWidgets('shows loading indicator when isLoadingMore is true', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildWidget(
          VideoListLoaded(
            categories: testCategories,
            speakers: testSpeakers,
            videos: testVideos,
            selectedCategory: 'All Categories',
            start: 0,
            hasReachedMax: false,
            isLoadingMore: true,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
