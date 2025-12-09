import 'package:flutter/material.dart';
import '../services/localization_service.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    final localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    return localizations;
  }

  String translate(String key, {List<String>? args}) {
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
    await localizationService.load(locale);
    final appLocalizations = AppLocalizations(locale);
    return appLocalizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}
