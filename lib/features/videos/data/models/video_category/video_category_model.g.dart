// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoCategoryModelImpl _$$VideoCategoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$VideoCategoryModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      parentId: (json['parent_id'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$VideoCategoryModelImplToJson(
        _$VideoCategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'parent_id': instance.parentId,
    };
