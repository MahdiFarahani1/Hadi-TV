// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArticleCategoryModelImpl _$$ArticleCategoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ArticleCategoryModelImpl(
      id: (json['id'] as num).toInt(),
      parentId: (json['parent_id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String,
    );

Map<String, dynamic> _$$ArticleCategoryModelImplToJson(
        _$ArticleCategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'title': instance.title,
    };
