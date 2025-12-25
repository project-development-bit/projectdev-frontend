import 'package:gigafaucet/features/localization/data/datasource/local/localization_local_data_source.dart';
import 'package:gigafaucet/features/localization/presentation/providers/get_languages_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final WidgetRef ref;
  const AppLocalizationsDelegate(this.ref);

  @override
  bool isSupported(Locale locale) {
    final localeList = ref.read(getLanguagesNotifierProvider).localeList;
    return (localeList.isNotEmpty
            ? localeList
            : [
                Locale('en', 'US'),
                Locale('my', 'MM'),
              ])
        .contains(locale);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    await localizationService.load(
        locale, ref.read(localizationLocalDataSourceProvider));
    final appLocalizations = AppLocalizations(locale);
    return appLocalizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}
