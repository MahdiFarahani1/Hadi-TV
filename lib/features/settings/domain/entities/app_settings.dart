import 'package:equatable/equatable.dart';

/// Domain entity for the app-wide config returned by /config → "config" key.
class AppSettings extends Equatable {
  final int id;

  /// Default language abbreviation set by the server, e.g. "FA"
  final String lang;

  final int dayDifference;
  final int monthDays;

  // Social / external links (nullable – not always provided)
  final String? youtube;
  final String? instagram;
  final String? telegram;
  final String? facebook;
  final String? twitter;
  final String? whatsapp;

  /// Aparat channel link (mapped from "special_url")
  final String? specialUrl;

  const AppSettings({
    required this.id,
    required this.lang,
    required this.dayDifference,
    required this.monthDays,
    this.youtube,
    this.instagram,
    this.telegram,
    this.facebook,
    this.twitter,
    this.whatsapp,
    this.specialUrl,
  });

  /// Returns a list of non-null social links as (label, url, icon-hint) tuples.
  List<({String label, String url, String icon})> get activeSocialLinks {
    return [
      if (youtube != null && youtube!.isNotEmpty)
        (label: 'YouTube', url: youtube!, icon: 'youtube'),
      if (instagram != null && instagram!.isNotEmpty)
        (label: 'Instagram', url: instagram!, icon: 'instagram'),
      if (telegram != null && telegram!.isNotEmpty)
        (label: 'Telegram', url: telegram!, icon: 'telegram'),
      if (facebook != null && facebook!.isNotEmpty)
        (label: 'Facebook', url: facebook!, icon: 'facebook'),
      if (twitter != null && twitter!.isNotEmpty)
        (label: 'Twitter / X', url: twitter!, icon: 'twitter'),
      if (whatsapp != null && whatsapp!.isNotEmpty)
        (label: 'WhatsApp', url: whatsapp!, icon: 'whatsapp'),
      if (specialUrl != null && specialUrl!.isNotEmpty)
        (label: 'Aparat', url: specialUrl!, icon: 'aparat'),
    ];
  }

  @override
  List<Object?> get props => [
    id,
    lang,
    dayDifference,
    monthDays,
    youtube,
    instagram,
    telegram,
    facebook,
    twitter,
    whatsapp,
    specialUrl,
  ];
}
