import 'package:flutter/material.dart';
import 'package:haditv/config/localization/translations/az.dart';
import 'package:haditv/config/localization/translations/de.dart';
import 'package:haditv/config/localization/translations/es.dart';
import 'package:haditv/config/localization/translations/fd.dart';
import 'package:haditv/config/localization/translations/ff.dart';
import 'package:haditv/config/localization/translations/fr.dart';
import 'package:haditv/config/localization/translations/ha.dart';
import 'package:haditv/config/localization/translations/id.dart';
import 'package:haditv/config/localization/translations/ku.dart';
import 'package:haditv/config/localization/translations/ma.dart';
import 'package:haditv/config/localization/translations/ps.dart';
import 'package:haditv/config/localization/translations/ru.dart';
import 'package:haditv/config/localization/translations/sw.dart';
import 'package:haditv/config/localization/translations/th.dart';
import 'package:haditv/config/localization/translations/tr.dart';
import 'translations/fa.dart';
import 'translations/en.dart';
import 'translations/ar.dart';
import 'translations/ur.dart';

/// Clean Architecture localization manager for Hadi TV.
/// Supported languages: Persian ('fa'), English ('en'), Arabic ('ar'), Urdu ('ur').
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// Combined translation dictionaries for all supported languages
  static const Map<String, Map<String, String>> _localizedValues = {
    'fa': faTranslations,
    'en': enTranslations,
    'ar': arTranslations,
    'ur': urTranslations,
    'az': azTranslations,
    'id': idTranslations,
    'ps': psTranslations,
    'fr': frTranslations,
    'th': thTranslations,
    'tr': trTranslations,
    'ha': haTranslations,
    'ku': kuTranslations,
    'sw': swTranslations,
    'de': deTranslations,
    'es': esTranslations,
    'fd': fdTranslations,
    'ru': ruTranslations,
    'ff': ffTranslations,
    'ma': maTranslations,
  };

  /// Translate a string key. Falls back to Persian (fa) dictionary, then key itself.
  String translate(String key) {
    final langCode = locale.languageCode.toLowerCase();
    final dict = _localizedValues[langCode] ?? _localizedValues['fa']!;
    return dict[key] ?? _localizedValues['fa']![key] ?? key;
  }
}
