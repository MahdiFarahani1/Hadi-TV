import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:haditv/core/error/failure.dart';

Future<T> safeApiCall<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on Failure {
    rethrow;
  } on DioException catch (e, stackTrace) {
    log(
      '''
❌ DioException
Type: ${e.type}
Path: ${e.requestOptions.path}
Method: ${e.requestOptions.method}
Status: ${e.response?.statusCode}
Message: ${e.message}

Response:
${e.response?.data}
''',
      error: e,
      stackTrace: stackTrace,
    );

    throw _mapDioException(e);
  } on SocketException catch (e, stackTrace) {
    log(
      '''
🌐 SocketException

'''
          .replaceFirst(r'$message', e.message),
      error: e,
      stackTrace: stackTrace,
    );

    throw const NetworkFailure();
  } catch (e, stackTrace) {
    log(
      '''
🔥 Unexpected Exception

Type:
${e.runtimeType}

Message:
$e
''',
      error: e,
      stackTrace: stackTrace,
    );

    throw UnexpectedFailure(e.toString());
  }
}

Failure _mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutFailure();

    case DioExceptionType.connectionError:
      return const NetworkFailure();

    case DioExceptionType.badResponse:
      return ServerFailure(
        message: _getServerErrorMessage(e.response?.statusCode),
        statusCode: e.response?.statusCode,
      );

    case DioExceptionType.cancel:
      return const UnexpectedFailure('request_cancelled_msg');

    default:
      return const UnexpectedFailure('connection_error_msg');
  }
}

String _getServerErrorMessage(int? statusCode) {
  switch (statusCode) {
    case 400:
      return 'error_bad_request';
    case 401:
      return 'error_unauthorized';
    case 403:
      return 'error_forbidden';
    case 404:
      return 'error_not_found';
    case 500:
      return 'server_error_msg';
    default:
      return 'unexpected_error_msg';
  }
}
