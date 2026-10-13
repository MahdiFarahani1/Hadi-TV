import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/live_tv/domain/entities/live_channel.dart';
import 'package:haditv/features/live_tv/domain/usecases/get_live_channels_usecase.dart';
import 'package:haditv/features/live_tv/presentation/cubit/live_tv_cubit.dart';
import 'package:haditv/features/live_tv/presentation/cubit/live_tv_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/live_tv/live_tv_fixtures.dart';

class MockGetLiveChannelsUseCase extends Mock
    implements GetLiveChannelsUseCase {}

void main() {
  late MockGetLiveChannelsUseCase mockUseCase;
  late LiveTvCubit cubit;

  setUp(() {
    mockUseCase = MockGetLiveChannelsUseCase();
    cubit = LiveTvCubit(mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  const liveChannel1 = LiveTvFixtures.liveChannel1;
  const offlineChannel2 = LiveTvFixtures.liveChannel2Offline;
  const liveChannel3 = LiveTvFixtures.liveChannel3WithSingleUrl;

  test('initial state should be LiveTvInitial', () {
    expect(cubit.state, isA<LiveTvInitial>());
  });

  group('loadChannels', () {
    blocTest<LiveTvCubit, LiveTvState>(
      'emits [LiveTvLoading, LiveTvLoaded] selecting first isLive channel by default',
      build: () {
        when(() => mockUseCase()).thenAnswer(
          (_) async => const Right([offlineChannel2, liveChannel1, liveChannel3]),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadChannels(),
      expect: () => [
        isA<LiveTvLoading>(),
        isA<LiveTvLoaded>()
            .having((s) => s.channels.length, 'channels count', 3)
            .having((s) => s.selectedChannel.id, 'selectedChannel.id', liveChannel1.id)
            .having((s) => s.selectedUrlIndex, 'selectedUrlIndex', 0),
      ],
      verify: (_) => verify(() => mockUseCase()).called(1),
    );

    blocTest<LiveTvCubit, LiveTvState>(
      'emits [LiveTvLoading, LiveTvLoaded] falling back to first channel if none is live',
      build: () {
        when(() => mockUseCase()).thenAnswer(
          (_) async => const Right([offlineChannel2]),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadChannels(),
      expect: () => [
        isA<LiveTvLoading>(),
        isA<LiveTvLoaded>()
            .having((s) => s.channels.length, 'channels count', 1)
            .having((s) => s.selectedChannel.id, 'selectedChannel.id', offlineChannel2.id),
      ],
      verify: (_) => verify(() => mockUseCase()).called(1),
    );

    blocTest<LiveTvCubit, LiveTvState>(
      'emits [LiveTvLoading, LiveTvLoaded] with initialChannel if provided',
      build: () {
        when(() => mockUseCase()).thenAnswer(
          (_) async => const Right([liveChannel1, liveChannel3]),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadChannels(initialChannel: liveChannel3),
      expect: () => [
        isA<LiveTvLoading>(),
        isA<LiveTvLoaded>()
            .having((s) => s.selectedChannel.id, 'selectedChannel.id', liveChannel3.id),
      ],
      verify: (_) => verify(() => mockUseCase()).called(1),
    );

    blocTest<LiveTvCubit, LiveTvState>(
      'emits [LiveTvLoading, LiveTvError] when channels list is empty',
      build: () {
        when(() => mockUseCase()).thenAnswer((_) async => const Right(<LiveChannel>[]));
        return cubit;
      },
      act: (cubit) => cubit.loadChannels(),
      expect: () => [
        isA<LiveTvLoading>(),
        isA<LiveTvError>().having(
          (s) => s.message,
          'message',
          'No live channels available right now.',
        ),
      ],
      verify: (_) => verify(() => mockUseCase()).called(1),
    );

    blocTest<LiveTvCubit, LiveTvState>(
      'emits [LiveTvLoading, LiveTvError] when repository call fails',
      build: () {
        when(() => mockUseCase()).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Connection failed', statusCode: 500)),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadChannels(),
      expect: () => [
        isA<LiveTvLoading>(),
        isA<LiveTvError>().having(
          (s) => s.message,
          'message',
          'Connection failed',
        ),
      ],
      verify: (_) => verify(() => mockUseCase()).called(1),
    );
  });

  group('selectChannel', () {
    blocTest<LiveTvCubit, LiveTvState>(
      'updates selectedChannel and resets selectedUrlIndex to 0 when currently loaded',
      build: () => cubit,
      seed: () => const LiveTvLoaded(
        channels: [liveChannel1, liveChannel3],
        selectedChannel: liveChannel1,
        selectedUrlIndex: 1,
      ),
      act: (cubit) => cubit.selectChannel(liveChannel3),
      expect: () => [
        isA<LiveTvLoaded>()
            .having((s) => s.selectedChannel.id, 'selectedChannel.id', liveChannel3.id)
            .having((s) => s.selectedUrlIndex, 'selectedUrlIndex', 0),
      ],
    );

    blocTest<LiveTvCubit, LiveTvState>(
      'does nothing when state is not LiveTvLoaded',
      build: () => cubit,
      act: (cubit) => cubit.selectChannel(liveChannel1),
      expect: () => [],
    );
  });

  group('selectUrl', () {
    blocTest<LiveTvCubit, LiveTvState>(
      'updates selectedUrlIndex when index is within valid bounds',
      build: () => cubit,
      seed: () => const LiveTvLoaded(
        channels: [liveChannel1],
        selectedChannel: liveChannel1,
        selectedUrlIndex: 0,
      ),
      act: (cubit) => cubit.selectUrl(1),
      expect: () => [
        isA<LiveTvLoaded>().having((s) => s.selectedUrlIndex, 'selectedUrlIndex', 1),
      ],
    );

    blocTest<LiveTvCubit, LiveTvState>(
      'ignores selection when index is out of bounds',
      build: () => cubit,
      seed: () => const LiveTvLoaded(
        channels: [liveChannel1],
        selectedChannel: liveChannel1,
        selectedUrlIndex: 0,
      ),
      act: (cubit) {
        cubit.selectUrl(-1);
        cubit.selectUrl(99);
      },
      expect: () => [],
    );

    blocTest<LiveTvCubit, LiveTvState>(
      'does nothing when state is not LiveTvLoaded',
      build: () => cubit,
      act: (cubit) => cubit.selectUrl(1),
      expect: () => [],
    );
  });
}
