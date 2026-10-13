import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/core/network/api_endpoints.dart';
import 'package:haditv/features/live_tv/data/datasources/live_tv_remote_data_source.dart';
import 'package:haditv/features/live_tv/data/models/live_channel_model.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helper/mock_apiclient.dart';
import '../../../../helper/mock_dio.dart';

void main() {
  late MockDio mockDio;
  late MockApiClient mockApiClient;
  late LiveTvRemoteDataSource remoteDataSource;

  setUp(() {
    mockDio = MockDio();
    mockApiClient = MockApiClient();
    when(() => mockApiClient.dio).thenReturn(mockDio);
    remoteDataSource = LiveTvRemoteDataSource(mockApiClient);
  });

  group('LiveTvRemoteDataSource.getLiveChannels', () {
    test('should return list of LiveChannelModels and merge live stream URLs for active channel', () async {
      final responsePayload = {
        'tv_list': [
          {
            'id': 1,
            'title': 'Hadi TV 1',
            'live_url1': '',
            'live_url2': '',
            'live_url3': '',
            'live_url4': '',
            'logoUrl': 'https://example.com/logo1.png',
            'currentProgram': 'Program 1',
            'upcomingProgram': 'Next 1',
          },
          {
            'id': 2,
            'title': 'Hadi TV 2',
            'live_url1': '',
            'live_url2': '',
            'live_url3': '',
            'live_url4': '',
            'logoUrl': 'https://example.com/logo2.png',
            'currentProgram': '',
            'upcomingProgram': '',
          },
        ],
        'live': {
          'id': 1,
          'live_url1': 'https://stream1.example.com',
          'live_url2': 'https://stream2.example.com',
          'live_url3': null,
          'live_url4': null,
        },
      };

      when(() => mockDio.get(ApiEndpoints.live)).thenAnswer(
        (_) async => Response(
          data: responsePayload,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.live),
        ),
      );

      final result = await remoteDataSource.getLiveChannels();

      expect(result, isA<List<LiveChannelModel>>());
      expect(result.length, 2);

      // Channel 1 matched live object -> live URLs merged
      final channel1 = result.firstWhere((c) => c.id == 1);
      expect(channel1.liveUrl1, 'https://stream1.example.com');
      expect(channel1.liveUrl2, 'https://stream2.example.com');
      expect(channel1.liveUrl3, '');
      expect(channel1.liveUrl4, '');
      expect(channel1.channelName, 'Hadi TV 1');
      expect(channel1.streamUrls, [
        'https://stream1.example.com',
        'https://stream2.example.com',
      ]);

      // Channel 2 did not match live object -> stream URLs remain empty
      final channel2 = result.firstWhere((c) => c.id == 2);
      expect(channel2.liveUrl1, '');
      expect(channel2.liveUrl2, '');
      expect(channel2.streamUrls, isEmpty);
    });

    test('should return list of models correctly when live object is null', () async {
      final responsePayload = {
        'tv_list': [
          {
            'id': 5,
            'title': 'Hadi TV 5',
            'live_url1': 'https://static.example.com',
          },
        ],
        'live': null,
      };

      when(() => mockDio.get(ApiEndpoints.live)).thenAnswer(
        (_) async => Response(
          data: responsePayload,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.live),
        ),
      );

      final result = await remoteDataSource.getLiveChannels();

      expect(result.length, 1);
      expect(result.first.id, 5);
      expect(result.first.liveUrl1, 'https://static.example.com');
    });

    test('should return empty list when response data is null', () async {
      when(() => mockDio.get(ApiEndpoints.live)).thenAnswer(
        (_) async => Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.live),
        ),
      );

      final result = await remoteDataSource.getLiveChannels();

      expect(result, isEmpty);
    });

    test('should return empty list when tv_list is empty or missing', () async {
      when(() => mockDio.get(ApiEndpoints.live)).thenAnswer(
        (_) async => Response(
          data: {'tv_list': []},
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.live),
        ),
      );

      final result = await remoteDataSource.getLiveChannels();

      expect(result, isEmpty);
    });

    test('should throw ServerFailure when dio returns 500 error', () async {
      when(() => mockDio.get(ApiEndpoints.live)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.live),
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: ApiEndpoints.live),
          ),
        ),
      );

      expect(
        () => remoteDataSource.getLiveChannels(),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('should throw NetworkFailure on connection error', () async {
      when(() => mockDio.get(ApiEndpoints.live)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.live),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(
        () => remoteDataSource.getLiveChannels(),
        throwsA(isA<NetworkFailure>()),
      );
    });
  });
}
