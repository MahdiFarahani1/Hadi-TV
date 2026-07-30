import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:haditv/features/videos/domain/entities/speaker.dart';

part 'speaker_model.freezed.dart';
part 'speaker_model.g.dart';

@freezed
class SpeakerModel with _$SpeakerModel {
  const SpeakerModel._();
  const factory SpeakerModel({
    required int id,
    String? lang,
    required String name,
    String? email,
    String? description,
    String? slug,
    @JsonKey(name: 'id_show') int? idShow,
    @JsonKey(name: 'photo_url') required String photoUrl,
  }) = _SpeakerModel;

  factory SpeakerModel.fromJson(Map<String, dynamic> json) =>
      _$SpeakerModelFromJson(json);

  Speaker toEntity() => Speaker(
    id: id,
    name: name,
    photoUrl: photoUrl,
    description: description,
    slug: slug,
    idShow: idShow,
    lang: lang,
    email: email,
  );
}
