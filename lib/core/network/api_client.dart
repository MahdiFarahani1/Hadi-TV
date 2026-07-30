import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:haditv/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:logger/logger.dart';

import 'package:haditv/core/network/interceptors/language_interceptor.dart';

class ApiClient {
  final Dio dio;
  final SettingsLocalDataSource settingsLocalDataSource;

  final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  ApiClient(this.settingsLocalDataSource) : dio = Dio() {
    dio.options.baseUrl = 'https://haditv.co.uk/api/';
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);
    dio.options.sendTimeout = const Duration(seconds: 15);

    // ── Language interceptor ────────────────────────────────────────────────
    // Automatically attaches the user's selected language code as a `lang`
    // query parameter to every outgoing request.
    dio.interceptors.add(LanguageInterceptor(settingsLocalDataSource));

    // ── Debug logger ────────────────────────────────────────────────────────
    if (kDebugMode) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            logger.i('''
➡️ ${options.method} ${options.uri}

Headers:
${options.headers}

Query:
${options.queryParameters}

Body:
${options.data}
''');
            handler.next(options);
          },

          onResponse: (response, handler) {
            logger.d('''
✅ ${response.statusCode} ${response.requestOptions.uri}

Response:
${response.data}
''');
            handler.next(response);
          },

          onError: (error, handler) {
            logger.e('''
❌ ${error.requestOptions.method} ${error.requestOptions.uri}

Status:
${error.response?.statusCode}

Message:
${error.message}

Response:
${error.response?.data}
''');
            handler.next(error);
          },
        ),
      );
    }
  }
}
