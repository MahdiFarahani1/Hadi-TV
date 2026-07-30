// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoModelImpl _$$VideoModelImplFromJson(Map<String, dynamic> json) =>
    _$VideoModelImpl(
      id: (json['id'] as num).toInt(),
      categoryId: (json['category_id'] as num).toInt(),
      categoryName: json['category_name'] as String?,
      categoryTitle: json['category_title'] as String?,
      groupName: json['group_name'] as String?,
      title: json['title'] as String,
      img: json['img'] as String?,
      dateTime: (json['date_time'] as num).toInt(),
      description: json['description'] as String?,
      speakerId: (json['speaker_id'] as num).toInt(),
      showCounter: (json['show_counter'] as num).toInt(),
      videoUrl: json['video_url'] as String,
      photoUrl: json['photo_url'] as String,
      speakerName: json['speaker_name'] as String,
      speaker: SpeakerModel.fromJson(json['speaker'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$VideoModelImplToJson(_$VideoModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'category_title': instance.categoryTitle,
      'group_name': instance.groupName,
      'title': instance.title,
      'img': instance.img,
      'date_time': instance.dateTime,
      'description': instance.description,
      'speaker_id': instance.speakerId,
      'show_counter': instance.showCounter,
      'video_url': instance.videoUrl,
      'photo_url': instance.photoUrl,
      'speaker_name': instance.speakerName,
      'speaker': instance.speaker,
    };
