import 'dart:convert';
import 'package:cointiply_app/features/localization/data/datasource/local/localization_local_data_source.dart';
import 'package:cointiply_app/features/localization/data/model/response/localization_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService {
  static const String _localizationPath = 'assets/l10n';
  // static const List<String> supportedLocales = ['en', 'my', 'fr'];

  Locale? _locale;
  Map<String, String>? _localizedStrings;

  Locale? get locale => _locale;
  bool get isInitialized => _locale != null && _localizedStrings != null;

  Future<LocalizationModel?> getCachedLocalization(String locale) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final jsonString = sharedPreferences.getString("localization_$locale");
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return LocalizationModel.fromJson(jsonMap);
  }

  Future<bool> load(Locale locale, WidgetRef ref) async {
    _locale = locale;
    debugPrint('Load called for locale: ${locale.languageCode}');
    try {
      Map<String, dynamic>? jsonString = (await ref
              .read(localizationLocalDataSourceProvider)
              .getCachedLocalization(locale.languageCode))
          ?.toJson();

      Map<String, dynamic> jsonMap = jsonString ?? {};
      if (jsonMap.isEmpty) {
        try {
          final jsonString = await rootBundle.loadString(
            '$_localizationPath/${locale.languageCode}.json',
          );
          jsonMap = json.decode(jsonString);
        } catch (e) {
          debugPrint(
            'Localization file not found for ${locale.languageCode}, falling back to en',
          );
          // Fallback to English
          final fallbackString = await rootBundle.loadString(
            '$_localizationPath/en.json',
          );
          jsonMap = json.decode(fallbackString);
        }
      }

      _localizedStrings = {};
      jsonMap.forEach((key, value) {
        _localizedStrings![key] = value.toString();
      });
      debugPrint(
          'Successfully loaded ${_localizedStrings!.length} strings for locale: ${locale.languageCode}');
      return true;
    } catch (e) {
      debugPrint('Failed to load localization: $e');
      return false;
    }
  }

  String translate(String key, {List<String>? args}) {
    if (_localizedStrings == null) {
      debugPrint('Translation failed: No localized strings loaded');
      return key;
    }

    String? value = _localizedStrings![key];
    if (value == null) {
      debugPrint(
          'Translation failed: Key "$key" not found in locale ${_locale?.languageCode}');
      return key;
    }

    // If arguments are provided, format the string
    if (args != null && args.isNotEmpty) {
      for (int i = 0; i < args.length; i++) {
        value = value!.replaceAll('{$i}', args[i]);
      }
    }

    return value!;
  }

  // Get the current locale
  Locale getCurrentLocale() {
    return _locale ?? const Locale('en', 'US');
  }

  // Change locale
  Future<void> changeLocale(String languageCode, WidgetRef ref) async {
    await load(Locale(languageCode), ref);
  }
}

// Singleton instance
final localizationService = LocalizationService();
