import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/features/live_tv/data/datasources/live_tv_remote_data_source.dart';
import 'package:haditv/features/live_tv/data/models/live_channel_model.dart';
import 'package:haditv/features/live_tv/data/repositories/live_tv_repository_impl.dart';
import 'package:haditv/features/live_tv/domain/entities/live_channel.dart';
import 'package:mocktail/mocktail.dart';

class MockLiveTvRemoteDataSource extends Mock
    implements LiveTvRemoteDataSource {}

void main() {
  late MockLiveTvRemoteDataSource mockDataSource;
  late LiveTvRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockLiveTvRemoteDataSource();
    repository = LiveTvRepositoryImpl(mockDataSource);
  });

  group('LiveTvRepositoryImpl.getLiveChannels', () {
    const testModels = [
      LiveChannelModel(
        id: 1,
        channelName: 'Hadi TV 1',
        liveUrl1: 'https://stream1.example.com',
        logoUrl: 'https://example.com/logo1.png',
        currentProgram: 'Program A',
        upcomingProgram: 'Program B',
      ),
      LiveChannelModel(
        id: 2,
        channelName: 'Hadi TV 2',
      ),
    ];

    test('should return Right with List<LiveChannel> when data source succeeds', () async {
      when(() => mockDataSource.getLiveChannels()).thenAnswer((_) async => testModels);

      final result = await repository.getLiveChannels();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right, got Left($failure)'),
        (channels) {
          expect(channels, isA<List<LiveChannel>>());
          expect(channels.length, 2);
          expect(channels[0].id, 1);
          expect(channels[0].channelName, 'Hadi TV 1');
          expect(channels[0].streamUrls, ['https://stream1.example.com']);
          expect(channels[1].id, 2);
          expect(channels[1].streamUrls, isEmpty);
        },
      );
      verify(() => mockDataSource.getLiveChannels()).called(1);
    });

    test('should return Left with Failure when data source throws a Failure', () async {
      const expectedFailure = ServerFailure(message: 'Server error', statusCode: 500);
      when(() => mockDataSource.getLiveChannels()).thenThrow(expectedFailure);

      final result = await repository.getLiveChannels();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Server error');
        },
        (_) => fail('Expected Left, got Right'),
      );
      verify(() => mockDataSource.getLiveChannels()).called(1);
    });

    test('should return Left with UnexpectedFailure when data source throws generic exception', () async {
      when(() => mockDataSource.getLiveChannels()).thenThrow(Exception('Unknown DB crash'));

      final result = await repository.getLiveChannels();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<UnexpectedFailure>());
          expect(failure.message, contains('Unknown DB crash'));
        },
        (_) => fail('Expected Left, got Right'),
      );
      verify(() => mockDataSource.getLiveChannels()).called(1);
    });
  });
}
