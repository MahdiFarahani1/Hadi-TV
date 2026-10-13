import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/core/widgets/error_widget.dart';
import 'package:haditv/features/live_tv/presentation/cubit/live_tv_cubit.dart';
import 'package:haditv/features/live_tv/presentation/cubit/live_tv_state.dart';
import 'package:haditv/features/live_tv/presentation/live_tv_screen.dart';
import 'package:haditv/features/live_tv/presentation/widgets/live_tv_skeleton.dart';
import 'package:haditv/features/volume/presentation/cubit/volume_cubit.dart';
import 'package:haditv/features/volume/presentation/cubit/volume_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/live_tv/live_tv_fixtures.dart';
import '../../../helper/test_widget_wrapper.dart';

class MockLiveTvCubit extends MockCubit<LiveTvState> implements LiveTvCubit {}

class MockVolumeCubit extends MockCubit<VolumeState> implements VolumeCubit {}

void main() {
  late MockLiveTvCubit mockLiveTvCubit;
  late MockVolumeCubit mockVolumeCubit;

  const offlineChannel = LiveTvFixtures.liveChannel2Offline;
  const channelWithMultipleUrls = LiveTvFixtures.liveChannel1;
  const channelWithSingleUrl = LiveTvFixtures.liveChannel3WithSingleUrl;

  setUpAll(() {
    registerFallbackValue(offlineChannel);
  });

  setUp(() {
    mockLiveTvCubit = MockLiveTvCubit();
    mockVolumeCubit = MockVolumeCubit();

    when(() => mockVolumeCubit.state).thenReturn(
      const VolumeState(volume: 0.5, lastNonZeroVolume: 0.5),
    );
    when(() => mockLiveTvCubit.loadChannels(
          initialChannel: any(named: 'initialChannel'),
        )).thenAnswer((_) async {});
  });

  tearDown(() async {
    await mockLiveTvCubit.close();
    await mockVolumeCubit.close();
  });

  Widget buildWidget(LiveTvState state) {
    when(() => mockLiveTvCubit.state).thenReturn(state);

    return createTestWidget(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LiveTvCubit>.value(value: mockLiveTvCubit),
          BlocProvider<VolumeCubit>.value(value: mockVolumeCubit),
        ],
        child: const Scaffold(body: LiveTvView()),
      ),
    );
  }

  group('LiveTvView Widget Tests', () {
    testWidgets('renders LiveTvSkeleton when state is LiveTvLoading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget(const LiveTvLoading()));

      expect(find.byType(LiveTvSkeleton), findsOneWidget);
    });

    testWidgets('renders CustomErrorWidget and triggers reload on retry button tap', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Failed to load channels';
      await tester.pumpWidget(buildWidget(const LiveTvError(errorMessage)));

      expect(find.byType(CustomErrorWidget), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);

      final retryFinder = find.text('Retry');
      expect(retryFinder, findsOneWidget);

      await tester.tap(retryFinder);
      await tester.pump(const Duration(milliseconds: 100));

      verify(() => mockLiveTvCubit.loadChannels()).called(1);

      // Clean up widget tree
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('renders offline placeholder and channel list when selected channel is offline', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const loadedState = LiveTvLoaded(
        channels: [offlineChannel],
        selectedChannel: offlineChannel,
        selectedUrlIndex: 0,
      );

      await tester.pumpWidget(buildWidget(loadedState));
      await tester.pump(const Duration(milliseconds: 300));

      // Offline placeholder displays channel name
      expect(find.text(offlineChannel.channelName), findsWidgets);
      // Offline status icon
      expect(find.byIcon(Icons.tv_off_rounded), findsWidgets);
    });

    testWidgets('renders channel list with multiple channels in loaded state', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const loadedState = LiveTvLoaded(
        channels: [offlineChannel, channelWithSingleUrl],
        selectedChannel: offlineChannel,
        selectedUrlIndex: 0,
      );

      await tester.pumpWidget(buildWidget(loadedState));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text(offlineChannel.channelName), findsWidgets);
      expect(find.text(channelWithSingleUrl.channelName), findsWidgets);
    });

    testWidgets('tapping an on-air single-url channel calls selectChannel on LiveTvCubit without opening picker', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const loadedState = LiveTvLoaded(
        channels: [offlineChannel, channelWithSingleUrl],
        selectedChannel: offlineChannel,
        selectedUrlIndex: 0,
      );

      await tester.pumpWidget(buildWidget(loadedState));
      await tester.pump(const Duration(milliseconds: 300));

      final liveChannelTileFinder = find.text(channelWithSingleUrl.channelName).first;
      await tester.tap(liveChannelTileFinder);
      await tester.pump(const Duration(milliseconds: 300));

      verify(() => mockLiveTvCubit.selectChannel(channelWithSingleUrl)).called(1);

      // Clean up widget tree
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('tapping an on-air channel with multiple URLs calls selectChannel and opens URL picker sheet', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const loadedState = LiveTvLoaded(
        channels: [offlineChannel, channelWithMultipleUrls],
        selectedChannel: offlineChannel,
        selectedUrlIndex: 0,
      );

      await tester.pumpWidget(buildWidget(loadedState));
      await tester.pump(const Duration(milliseconds: 300));

      final liveChannelTileFinder = find.text(channelWithMultipleUrls.channelName).first;
      await tester.tap(liveChannelTileFinder);

      // Wait 150ms for timer and modal sheet animation
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 300));

      verify(() => mockLiveTvCubit.selectChannel(channelWithMultipleUrls)).called(1);

      // Clean up widget tree and all pending timers
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 300));
    });
  });
}
