// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsModelImpl _$$AppSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AppSettingsModelImpl(
      id: (json['id'] as num).toInt(),
      lang: json['lang'] as String? ?? 'FA',
      dayDifferenceStr: json['DayDifference'] as String? ?? '0',
      monthDays: (json['MonthDays'] as num?)?.toInt() ?? 29,
      facebook: json['facebook'] as String?,
      twitter: json['twitter'] as String?,
      youtube: json['youtube'] as String?,
      whatsapp: json['whatsapp'] as String?,
      instagram: json['instagram'] as String?,
      telegram: json['telegram'] as String?,
      specialUrl: json['special_url'] as String?,
    );

Map<String, dynamic> _$$AppSettingsModelImplToJson(
        _$AppSettingsModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lang': instance.lang,
      'DayDifference': instance.dayDifferenceStr,
      'MonthDays': instance.monthDays,
      'facebook': instance.facebook,
      'twitter': instance.twitter,
      'youtube': instance.youtube,
      'whatsapp': instance.whatsapp,
      'instagram': instance.instagram,
      'telegram': instance.telegram,
      'special_url': instance.specialUrl,
    };
