import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../localization/localization_service.dart';
import 'locale_provider.dart';

// Provider that combines locale and translation service
final translationProvider =
    Provider<String Function(String, {List<String>? args})>((ref) {
  final locale = ref.watch(localeProvider);

  // This provider will rebuild whenever locale changes
  return (String key, {List<String>? args}) {
    debugPrint(
        'TranslationProvider called for key: $key in locale: ${locale.languageCode}');
    return localizationService.translate(key, args: args);
  };
});

// Provider for getting the current locale and ensuring translation service is in sync
final translationServiceProvider =
    FutureProvider<LocalizationService>((ref) async {
  final locale = ref.watch(localeProvider);

  // Ensure the localization service is loaded with the current locale
  await localizationService.load(locale);
  debugPrint(
      'TranslationServiceProvider loaded for locale: ${locale.languageCode}');
  return localizationService;
});
