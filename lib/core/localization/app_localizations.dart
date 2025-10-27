import 'package:flutter/material.dart';
import 'localization_service.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    final localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    debugPrint(
        'AppLocalizations.of() called - returning locale: ${localizations?.locale.languageCode}');
    return localizations;
  }

  String translate(String key, {List<String>? args}) {
    debugPrint(
        'AppLocalizations.translate() called for key: $key in locale: ${locale.languageCode}');
    return localizationService.translate(key, args: args);
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return LocalizationService.supportedLocales.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    debugPrint(
        'AppLocalizationsDelegate.load() called for locale: ${locale.languageCode}');
    await localizationService.load(locale);
    final appLocalizations = AppLocalizations(locale);
    debugPrint(
        'AppLocalizationsDelegate.load() completed for locale: ${locale.languageCode}');
    return appLocalizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}
