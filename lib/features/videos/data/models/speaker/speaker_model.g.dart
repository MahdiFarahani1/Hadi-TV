// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speaker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpeakerModelImpl _$$SpeakerModelImplFromJson(Map<String, dynamic> json) =>
    _$SpeakerModelImpl(
      id: (json['id'] as num).toInt(),
      lang: json['lang'] as String?,
      name: json['name'] as String,
      email: json['email'] as String?,
      description: json['description'] as String?,
      slug: json['slug'] as String?,
      idShow: (json['id_show'] as num?)?.toInt(),
      photoUrl: json['photo_url'] as String,
    );

Map<String, dynamic> _$$SpeakerModelImplToJson(_$SpeakerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lang': instance.lang,
      'name': instance.name,
      'email': instance.email,
      'description': instance.description,
      'slug': instance.slug,
      'id_show': instance.idShow,
      'photo_url': instance.photoUrl,
    };
