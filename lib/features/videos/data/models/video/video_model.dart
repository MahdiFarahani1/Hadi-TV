import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:haditv/features/videos/data/models/speaker/speaker_model.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';

part 'video_model.freezed.dart';
part 'video_model.g.dart';

@freezed
class VideoModel with _$VideoModel {
  const VideoModel._();
  const factory VideoModel({
    required int id,
    @JsonKey(name: 'category_id') required int categoryId,
    required String title,
    String? img,
    @JsonKey(name: 'date_time') required int dateTime,
    String? description,
    @JsonKey(name: 'speaker_id') required int speakerId,
    @JsonKey(name: 'show_counter') required int showCounter,
    @JsonKey(name: 'video_url') required String videoUrl,
    @JsonKey(name: 'photo_url') required String photoUrl,
    @JsonKey(name: 'speaker_name') required String speakerName,
    required SpeakerModel speaker,
  }) = _VideoModel;

  factory VideoModel.fromJson(Map<String, dynamic> json) =>
      _$VideoModelFromJson(json);

  Video toEntity() => Video(
    id: id,
    categoryId: categoryId,
    title: title,
    photoUrl: photoUrl,
    dateTime: dateTime,
    description: description,
    img: img,
    showCounter: showCounter,
    speaker: speaker.toEntity(),
    speakerId: speakerId,
    speakerName: speakerName,
    videoUrl: videoUrl,
  );
}
