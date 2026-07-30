import 'package:haditv/core/error/api_call_handler.dart';
import 'package:haditv/core/network/api_client.dart';
import 'package:haditv/core/network/api_endpoints.dart';
import 'package:haditv/features/live_tv/data/models/live_channel_model.dart';

class LiveTvRemoteDataSource {
  final ApiClient apiClient;

  LiveTvRemoteDataSource(this.apiClient);

  Future<List<LiveChannelModel>> getLiveChannels() async {
    return safeApiCall<List<LiveChannelModel>>(() async {
      final response = await apiClient.dio.get(ApiEndpoints.live);

      final data = response.data;
      if (data == null) return <LiveChannelModel>[];

      final tvList = data['tv_list'] as List<dynamic>? ?? [];
      final liveJson = data['live'] as Map<String, dynamic>?;

      return tvList.map((e) {
        final map = Map<String, dynamic>.from(e as Map);

        // Merge the live-object URLs into the matching channel entry.
        // Only the single channel that is currently on-air will have
        // non-empty urls in the 'live' object; all others remain empty
        // → correctly treated as offline by the entity.
        if (liveJson != null && map['id'] == liveJson['id']) {
          map['live_url1'] = liveJson['live_url1'] ?? '';
          map['live_url2'] = liveJson['live_url2'] ?? '';
          map['live_url3'] = liveJson['live_url3'] ?? '';
          map['live_url4'] = liveJson['live_url4'] ?? '';
        }

        return LiveChannelModel.fromJson(map);
      }).toList();
    });
  }
}
