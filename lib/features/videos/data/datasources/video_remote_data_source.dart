import 'package:haditv/core/error/api_call_handler.dart';
import 'package:haditv/core/network/api_client.dart';
import 'package:haditv/core/network/api_endpoints.dart';
import 'package:haditv/features/videos/data/models/speaker/speaker_model.dart';
import 'package:haditv/features/videos/data/models/video_category/video_category_model.dart';
import 'package:haditv/features/videos/data/models/video/video_model.dart';

class VideoRemoteDataSource {
  final ApiClient apiClient;

  VideoRemoteDataSource(this.apiClient);

  Future<List<VideoCategoryModel>> getCategories({String lang = 'en'}) async {
    return safeApiCall<List<VideoCategoryModel>>(() async {
      final response = await apiClient.dio.get(
        ApiEndpoints.videoCategory,
        queryParameters: {'lang': lang},
      );
      return (response.data['videogroup'] as List)
          .map((e) => VideoCategoryModel.fromJson(e))
          .toList();
    });
  }

  Future<List<VideoModel>> getVideos({
    String lang = 'en',
    int start = 0,
    int limit = 15,
    int? gid,
    int? speakerId,
  }) async {
    return safeApiCall<List<VideoModel>>(() async {
      final queryParams = <String, dynamic>{
        'lang': lang,
        'start': start,
        'limit': limit,
        if (gid != null && gid > 0) 'gid': gid,
        if (speakerId != null && speakerId > 0) 'speaker_id': speakerId,
      };

      final response = await apiClient.dio.get(
        ApiEndpoints.videos,
        queryParameters: queryParams,
      );
      return (response.data['video'] as List)
          .map((e) => VideoModel.fromJson(e))
          .toList();
    });
  }

  Future<List<SpeakerModel>> getSpeakers({String lang = 'en'}) async {
    return safeApiCall<List<SpeakerModel>>(() async {
      final response = await apiClient.dio.get(
        ApiEndpoints.speakers,
        queryParameters: {'lang': lang},
      );
      return (response.data['speakers'] as List)
          .map((e) => SpeakerModel.fromJson(e))
          .toList();
    });
  }
}
