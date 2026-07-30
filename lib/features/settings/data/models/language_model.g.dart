// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LanguageModelImpl _$$LanguageModelImplFromJson(Map<String, dynamic> json) =>
    _$LanguageModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      mainTitle: json['main_title'] as String? ?? '',
      abbr: json['abbr'] as String,
      direction: json['direction'] as String? ?? 'ltr',
      idShow: (json['id_show'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$LanguageModelImplToJson(_$LanguageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'main_title': instance.mainTitle,
      'abbr': instance.abbr,
      'direction': instance.direction,
      'id_show': instance.idShow,
    };
