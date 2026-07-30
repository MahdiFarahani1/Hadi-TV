// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LiveChannelModelImpl _$$LiveChannelModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LiveChannelModelImpl(
      id: (json['id'] as num).toInt(),
      channelName: json['title'] as String,
      liveUrl1: json['live_url1'] as String? ?? '',
      liveUrl2: json['live_url2'] as String? ?? '',
      liveUrl3: json['live_url3'] as String? ?? '',
      liveUrl4: json['live_url4'] as String? ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      currentProgram: json['currentProgram'] as String? ?? '',
      upcomingProgram: json['upcomingProgram'] as String? ?? '',
    );

Map<String, dynamic> _$$LiveChannelModelImplToJson(
        _$LiveChannelModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.channelName,
      'live_url1': instance.liveUrl1,
      'live_url2': instance.liveUrl2,
      'live_url3': instance.liveUrl3,
      'live_url4': instance.liveUrl4,
      'logoUrl': instance.logoUrl,
      'currentProgram': instance.currentProgram,
      'upcomingProgram': instance.upcomingProgram,
    };
