import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:haditv/features/settings/domain/entities/app_settings.dart';

part 'app_settings_model.freezed.dart';
part 'app_settings_model.g.dart';

@freezed
class AppSettingsModel with _$AppSettingsModel {
  const AppSettingsModel._();

  const factory AppSettingsModel({
    required int id,
    @Default('FA') String lang,
    @JsonKey(name: 'DayDifference') @Default('0') String dayDifferenceStr,
    @JsonKey(name: 'MonthDays') @Default(29) int monthDays,
    String? facebook,
    String? twitter,
    String? youtube,
    String? whatsapp,
    String? instagram,
    String? telegram,
    @JsonKey(name: 'special_url') String? specialUrl,
  }) = _AppSettingsModel;

  factory AppSettingsModel.empty() {
    return const AppSettingsModel(
      id: 0,
      lang: 'en',
      dayDifferenceStr: '',
      monthDays: 30,
      youtube: null,
      instagram: null,
      facebook: null,
      specialUrl: null,
      telegram: null,

      twitter: null,
      whatsapp: null,
    );
  }
  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsModelFromJson(json);

  AppSettings toEntity() => AppSettings(
    id: id,
    lang: lang,
    dayDifference: int.tryParse(dayDifferenceStr) ?? 0,
    monthDays: monthDays,
    youtube: youtube,
    instagram: instagram,
    telegram: telegram,
    facebook: facebook,
    twitter: twitter,
    whatsapp: whatsapp,
    specialUrl: specialUrl,
  );
}
