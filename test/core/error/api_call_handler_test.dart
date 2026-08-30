import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haditv/core/error/api_call_handler.dart';
import 'package:haditv/core/error/failure.dart';

void main() {
  group('safeApiCall', () {
    // =========================================================
    // SUCCESS
    // =========================================================

    test('should return result when call succeeds', () async {
      final result = await safeApiCall<String>(() async {
        return 'success';
      });

      expect(result, 'success');
    });

    // =========================================================
    // FAILURE
    // =========================================================

    test('should rethrow existing Failure', () async {
      const failure = NetworkFailure();

      expect(
        () => safeApiCall<String>(() async {
          throw failure;
        }),
        throwsA(same(failure)),
      );
    });

    // =========================================================
    // DIO - TIMEOUT
    // =========================================================

    test('should return TimeoutFailure on connection timeout', () async {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      expect(
        () => safeApiCall<String>(() async {
          throw exception;
        }),
        throwsA(isA<TimeoutFailure>()),
      );
    });

    test('should return TimeoutFailure on send timeout', () async {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.sendTimeout,
      );

      expect(
        () => safeApiCall<String>(() async {
          throw exception;
        }),
        throwsA(isA<TimeoutFailure>()),
      );
    });

    test('should return TimeoutFailure on receive timeout', () async {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.receiveTimeout,
      );

      expect(
        () => safeApiCall<String>(() async {
          throw exception;
        }),
        throwsA(isA<TimeoutFailure>()),
      );
    });

    // =========================================================
    // DIO - NETWORK
    // =========================================================

    test('should return NetworkFailure on connection error', () async {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
      );

      expect(
        () => safeApiCall<String>(() async {
          throw exception;
        }),
        throwsA(isA<NetworkFailure>()),
      );
    });

    // =========================================================
    // DIO - HTTP ERRORS
    // =========================================================

    test('should return ServerFailure for 400', () async {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
        ),
      );

      expect(
        () => safeApiCall<String>(() async {
          throw exception;
        }),
        throwsA(
          isA<ServerFailure>().having((e) => e.statusCode, 'statusCode', 400),
        ),
      );
    });

    test('should return ServerFailure for 401', () async {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
        ),
      );

      expect(
        () => safeApiCall<String>(() async {
          throw exception;
        }),
        throwsA(
          isA<ServerFailure>().having((e) => e.statusCode, 'statusCode', 401),
        ),
      );
    });

    test('should return ServerFailure for 403', () async {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 403,
        ),
      );

      expect(
        () => safeApiCall<String>(() async {
          throw exception;
        }),
        throwsA(
          isA<ServerFailure>().having((e) => e.statusCode, 'statusCode', 403),
        ),
      );
    });

    test('should return ServerFailure for 404', () async {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 404,
        ),
      );

      expect(
        () => safeApiCall<String>(() async {
          throw exception;
        }),
        throwsA(
          isA<ServerFailure>().having((e) => e.statusCode, 'statusCode', 404),
        ),
      );
    });

    test('should return ServerFailure for 500', () async {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
        ),
      );

      expect(
        () => safeApiCall<String>(() async {
          throw exception;
        }),
        throwsA(
          isA<ServerFailure>().having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
    });

    // =========================================================
    // DIO - CANCEL
    // =========================================================

    test('should return UnexpectedFailure when request is cancelled', () async {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.cancel,
      );

      expect(
        () => safeApiCall<String>(() async {
          throw exception;
        }),
        throwsA(
          isA<UnexpectedFailure>().having(
            (e) => e.message,
            'message',
            'request_cancelled_msg',
          ),
        ),
      );
    });

    // =========================================================
    // SOCKET
    // =========================================================

    test('should return NetworkFailure on SocketException', () async {
      expect(
        () => safeApiCall<String>(() async {
          throw const SocketException('No internet');
        }),
        throwsA(isA<NetworkFailure>()),
      );
    });

    // =========================================================
    // UNKNOWN ERROR
    // =========================================================

    test('should return UnexpectedFailure on unknown exception', () async {
      expect(
        () => safeApiCall<String>(() async {
          throw Exception('Something unexpected');
        }),
        throwsA(
          isA<UnexpectedFailure>().having(
            (e) => e.message,
            'message',
            contains('Something unexpected'),
          ),
        ),
      );
    });
  });
}
