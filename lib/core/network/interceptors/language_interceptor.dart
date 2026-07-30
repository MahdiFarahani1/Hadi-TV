import 'package:dio/dio.dart';
import 'package:haditv/features/settings/data/datasources/settings_local_data_source.dart';

/// Interceptor that dynamically attaches the user's active language code (`lang`)
/// as a query parameter to every outgoing Dio API request.
class LanguageInterceptor extends Interceptor {
  final SettingsLocalDataSource settingsLocalDataSource;

  LanguageInterceptor(this.settingsLocalDataSource);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final langCode = settingsLocalDataSource.getLanguageCode();
    options.queryParameters['lang'] = langCode;
    handler.next(options);
  }
}
