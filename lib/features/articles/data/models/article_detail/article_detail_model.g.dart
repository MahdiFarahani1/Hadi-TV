// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArticleDetailModelImpl _$$ArticleDetailModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ArticleDetailModelImpl(
      id: (json['id'] as num).toInt(),
      categoryId: (json['category_id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String,
      content: json['content'] as String? ?? '',
      photoUrl: json['photo_url'] as String,
      articleDate: json['article_date'] as String? ?? '',
      articleUrl: json['article_url'] as String? ?? '',
      readTime: json['readTime'] as String? ?? '',
    );

Map<String, dynamic> _$$ArticleDetailModelImplToJson(
        _$ArticleDetailModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'title': instance.title,
      'content': instance.content,
      'photo_url': instance.photoUrl,
      'article_date': instance.articleDate,
      'article_url': instance.articleUrl,
      'readTime': instance.readTime,
    };
