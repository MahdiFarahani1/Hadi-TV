import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app_localizations.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      'fa', // Persian
      'en', // English
      'ar', // Arabic
      'ur', // Urdu
      'az', // Azerbaijani
      'id', // Indonesian
      'ps', // Pashto
      'fr', // French
      'th', // Thai
      'tr', // Turkish
      'ha', // Hausa
      'ku', // Kurdish
      'sw', // Swahili
      'de', // German
      'es', // Spanish
      'fd', // dari persian
      'ru', // Russian
      'ff', // Fulfulde
      'ma', // Mandingue
    ].contains(locale.languageCode.toLowerCase());
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
