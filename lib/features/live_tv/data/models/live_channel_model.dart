import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:haditv/features/live_tv/domain/entities/live_channel.dart';

part 'live_channel_model.freezed.dart';
part 'live_channel_model.g.dart';

@freezed
class LiveChannelModel with _$LiveChannelModel {
  const LiveChannelModel._();

  const factory LiveChannelModel({
    required int id,
    @JsonKey(name: 'title') required String channelName,
    @JsonKey(name: 'live_url1') @Default('') String liveUrl1,
    @JsonKey(name: 'live_url2') @Default('') String liveUrl2,
    @JsonKey(name: 'live_url3') @Default('') String liveUrl3,
    @JsonKey(name: 'live_url4') @Default('') String liveUrl4,
    @Default('') String logoUrl,
    @Default('') String currentProgram,
    @Default('') String upcomingProgram,
  }) = _LiveChannelModel;

  factory LiveChannelModel.fromJson(Map<String, dynamic> json) =>
      _$LiveChannelModelFromJson(json);

  /// Collects non-empty stream URLs in order (url1 → url4).
  List<String> get streamUrls => [
    liveUrl1,
    liveUrl2,
    liveUrl3,
    liveUrl4,
  ].where((url) => url.isNotEmpty).toList();

  LiveChannel toEntity() => LiveChannel(
    id: id,
    channelName: channelName,
    logoUrl: logoUrl,
    streamUrls: streamUrls,
    currentProgram: currentProgram,
    upcomingProgram: upcomingProgram,
  );
}
