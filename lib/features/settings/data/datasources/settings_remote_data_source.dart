import 'package:haditv/core/error/api_call_handler.dart';
import 'package:haditv/core/network/api_client.dart';
import 'package:haditv/core/network/api_endpoints.dart';
import 'package:haditv/features/settings/data/models/app_settings_model.dart';
import 'package:haditv/features/settings/data/models/language_model.dart';

class SettingsRemoteDataSource {
  final ApiClient apiClient;

  SettingsRemoteDataSource(this.apiClient);

  Future<AppSettingsModel> getSettings() async {
    return safeApiCall<AppSettingsModel>(() async {
      final response = await apiClient.dio.get(ApiEndpoints.config);
      final configJson = response.data['config'] as Map<String, dynamic>? ?? {};

      if (response.data['config'] == null || response.data['config'].isEmpty) {
        return AppSettingsModel.empty();
      }
      return AppSettingsModel.fromJson(configJson);
    });
  }

  Future<List<LanguageModel>> getLanguages() async {
    return safeApiCall<List<LanguageModel>>(() async {
      final response = await apiClient.dio.get(ApiEndpoints.config);
      final list = response.data['languages'] as List<dynamic>? ?? [];
      final models = list
          .map((e) => LanguageModel.fromJson(e as Map<String, dynamic>))
          .toList();

      models.sort((a, b) => a.idShow.compareTo(b.idShow));
      return models;
    });
  }
}
