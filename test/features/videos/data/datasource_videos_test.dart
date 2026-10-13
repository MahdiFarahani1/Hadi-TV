import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/core/error/failure.dart';
import 'package:haditv/core/network/api_endpoints.dart';
import 'package:haditv/features/videos/data/datasources/video_remote_data_source.dart';
import 'package:haditv/features/videos/data/models/speaker/speaker_model.dart';
import 'package:haditv/features/videos/data/models/video/video_model.dart';
import 'package:haditv/features/videos/data/models/video_category/video_category_model.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helper/mock_apiclient.dart';
import '../../../helper/mock_dio.dart';

void main() {
  late MockDio mockDio;
  late MockApiClient mockApiClient;
  late VideoRemoteDataSource videoRemoteDataSource;

  setUp(() {
    mockDio = MockDio();
    mockApiClient = MockApiClient();
    when(() => mockApiClient.dio).thenReturn(mockDio);
    videoRemoteDataSource = VideoRemoteDataSource(mockApiClient);
  });

  group('getVideos', () {
    test('should get all videos success', () async {
      when(
        () => mockDio.get(
          ApiEndpoints.videos,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {
            "video": [
              {
                "id": 36085,
                "category_id": 982,
                "title": "Islam & life 48",
                "img": null,
                "date_time": 1745993040,
                "description": null,
                "speaker_id": 923,
                "show_counter": 235,
                "video_url":
                    "https://haditv.co.uk/upload_list/source/Videos/EN/vd/Islam%20and%20Life/EN373-1511UKL-IEG048_out.mp4",
                "photo_url": "",
                "speaker_name": "Sayed Ali Razavi",
                "speaker": {
                  "id": 923,
                  "lang": "EN",
                  "name": "Sayed Ali Razavi",
                  "email": null,
                  "description": null,
                  "slug": "Sayed-Ali-Razavi",
                  "id_show": 21,
                  "photo_url": "",
                },
              },
              {
                "id": 36084,
                "category_id": 982,
                "title": "Islam & life 47",
                "img": null,
                "date_time": 1745993040,
                "description": null,
                "speaker_id": 923,
                "show_counter": 168,
                "video_url":
                    "https://haditv.co.uk/upload_list/source/Videos/EN/vd/Islam%20and%20Life/EN373-1511UKL-IEG047_out.mp4",
                "photo_url": "",
                "speaker_name": "Sayed Ali Razavi",
                "speaker": {
                  "id": 923,
                  "lang": "EN",
                  "name": "Sayed Ali Razavi",
                  "email": null,
                  "description": null,
                  "slug": "Sayed-Ali-Razavi",
                  "id_show": 21,
                  "photo_url": "",
                },
              },
            ],
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.videos),
        ),
      );

      final res = await videoRemoteDataSource.getVideos();

      expect(res, isA<List<VideoModel>>());
      expect(res, hasLength(2));
      expect(res[0].id, 36085);
      expect(res[0].title, 'Islam & life 48');
      expect(res[0].speakerName, 'Sayed Ali Razavi');

      verify(
        () => mockDio.get(
          ApiEndpoints.videos,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).called(1);
    });

    test('should pass correct query parameters when filters are provided', () async {
      when(
        () => mockDio.get(
          ApiEndpoints.videos,
          queryParameters: {
            'lang': 'fa',
            'start': 10,
            'limit': 20,
            'gid': 982,
            'speaker_id': 923,
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {'video': []},
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.videos),
        ),
      );

      final res = await videoRemoteDataSource.getVideos(
        lang: 'fa',
        start: 10,
        limit: 20,
        gid: 982,
        speakerId: 923,
      );

      expect(res, isEmpty);
      verify(
        () => mockDio.get(
          ApiEndpoints.videos,
          queryParameters: {
            'lang': 'fa',
            'start': 10,
            'limit': 20,
            'gid': 982,
            'speaker_id': 923,
          },
        ),
      ).called(1);
    });

    test("should throw exception when getVideos fails (500)", () async {
      when(
        () => mockDio.get(
          ApiEndpoints.videos,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.videos),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: ApiEndpoints.videos),
            statusCode: 500,
          ),
        ),
      );

      final result = videoRemoteDataSource.getVideos();

      await expectLater(result, throwsA(isA<ServerFailure>()));

      verify(
        () => mockDio.get(
          ApiEndpoints.videos,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).called(1);
    });
  });

  group('getCategories', () {
    test('should return list of VideoCategoryModel when getCategories succeeds', () async {
      when(
        () => mockDio.get(
          ApiEndpoints.videoCategory,
          queryParameters: {'lang': 'en'},
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {
            'videogroup': [
              {
                'id': 982,
                'parent_id': 0,
                'title': 'Islam & Life',
              },
              {
                'id': 983,
                'parent_id': 0,
                'title': 'Documentary',
              },
            ],
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.videoCategory),
        ),
      );

      final res = await videoRemoteDataSource.getCategories();

      expect(res, isA<List<VideoCategoryModel>>());
      expect(res, hasLength(2));
      expect(res[0].id, 982);
      expect(res[0].title, 'Islam & Life');
      expect(res[0].parentId, 0);

      verify(
        () => mockDio.get(
          ApiEndpoints.videoCategory,
          queryParameters: {'lang': 'en'},
        ),
      ).called(1);
    });

    test('should throw ServerFailure when getCategories fails (500)', () async {
      when(
        () => mockDio.get(
          ApiEndpoints.videoCategory,
          queryParameters: {'lang': 'en'},
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.videoCategory),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: ApiEndpoints.videoCategory),
            statusCode: 500,
          ),
        ),
      );

      final result = videoRemoteDataSource.getCategories();

      await expectLater(result, throwsA(isA<ServerFailure>()));

      verify(
        () => mockDio.get(
          ApiEndpoints.videoCategory,
          queryParameters: {'lang': 'en'},
        ),
      ).called(1);
    });
  });

  group('getSpeakers', () {
    test('should return list of SpeakerModel when getSpeakers succeeds', () async {
      when(
        () => mockDio.get(
          ApiEndpoints.speakers,
          queryParameters: {'lang': 'en'},
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {
            'speakers': [
              {
                'id': 923,
                'name': 'Sayed Ali Razavi',
                'photo_url': 'https://example.com/photo.jpg',
                'lang': 'EN',
                'slug': 'Sayed-Ali-Razavi',
              },
            ],
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.speakers),
        ),
      );

      final res = await videoRemoteDataSource.getSpeakers();

      expect(res, isA<List<SpeakerModel>>());
      expect(res, hasLength(1));
      expect(res[0].id, 923);
      expect(res[0].name, 'Sayed Ali Razavi');
      expect(res[0].photoUrl, 'https://example.com/photo.jpg');

      verify(
        () => mockDio.get(
          ApiEndpoints.speakers,
          queryParameters: {'lang': 'en'},
        ),
      ).called(1);
    });

    test('should throw ServerFailure when getSpeakers fails (500)', () async {
      when(
        () => mockDio.get(
          ApiEndpoints.speakers,
          queryParameters: {'lang': 'en'},
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.speakers),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: ApiEndpoints.speakers),
            statusCode: 500,
          ),
        ),
      );

      final result = videoRemoteDataSource.getSpeakers();

      await expectLater(result, throwsA(isA<ServerFailure>()));

      verify(
        () => mockDio.get(
          ApiEndpoints.speakers,
          queryParameters: {'lang': 'en'},
        ),
      ).called(1);
    });
  });
}
