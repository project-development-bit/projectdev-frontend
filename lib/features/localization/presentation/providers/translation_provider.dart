import 'package:cointiply_app/features/localization/presentation/providers/localization_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/localization_service.dart';

// Provider that combines locale and translation service
final translationProvider =
    Provider<String Function(String, {List<String>? args})>((ref) {
  final locale = ref.watch(localizationNotifierProvider);

  // This provider will rebuild whenever locale changes
  return (String key, {List<String>? args}) {
    debugPrint(
        'TranslationProvider called for key: $key in locale: ${locale.currentLocale.languageCode}');
    return localizationService.translate(key, args: args);
  };
});

// Provider for getting the current locale and ensuring translation service is in sync
final translationServiceProvider =
    FutureProvider<LocalizationService>((ref) async {
  final locale = ref.watch(localizationNotifierProvider).currentLocale;

  // Ensure the localization service is loaded with the current locale
  await localizationService.load(locale);
  debugPrint(
      'TranslationServiceProvider loaded for locale: ${locale.languageCode}');
  return localizationService;
});
