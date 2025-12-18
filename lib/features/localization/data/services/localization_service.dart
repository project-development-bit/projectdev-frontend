import 'dart:convert';
import 'package:cointiply_app/core/config/app_assets.dart';
import 'package:cointiply_app/features/localization/data/datasource/local/localization_local_data_source.dart';
import 'package:cointiply_app/features/localization/data/model/response/localization_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService {
  static const String _localizationPath = AppAssets.localizationPath;
  static const List<String> supportedLocales = ['en', 'my'];

  Locale? _locale;
  Map<String, String>? _localizedStrings;
  Map<String, String>? _localizedFallbackStrings;

  Locale? get locale => _locale;
  bool get isInitialized => _locale != null && _localizedStrings != null;

  Future<LocalizationModel?> getCachedLocalization(String locale) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final jsonString = sharedPreferences.getString("localization_$locale");
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return LocalizationModel.fromJson(jsonMap);
  }

  Future<bool> load(
      Locale locale, LocalizationLocalDataSource localDataSource) async {
    _locale = locale;
    debugPrint('Load called for locale: ${locale.languageCode}');
    try {
      Map<String, dynamic>? jsonString =
          (await localDataSource.getCachedLocalization(locale.languageCode))
              ?.toJson();

      Map<String, dynamic> jsonMap = jsonString ?? {};
      if (jsonMap.isEmpty) {
        try {
          final languageCode =
              locale.languageCode == "my" || locale.languageCode == "mm"
                  ? "my"
                  : "en";
          final jsonString = await rootBundle.loadString(
            '$_localizationPath/$languageCode.json',
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
      await loadFallbackStrings(locale);
      return true;
    } catch (e) {
      debugPrint('Failed to load localization: $e');
      return false;
    }
  }

  String translate(String key, {List<String>? args}) {
    if (_localizedStrings == null) {
      debugPrint('Translation failed: No localized strings loaded');
      return key; // Return the key itself if no localization is loaded
    }

    String? value = _localizedStrings![key];

    // If the key is not found in the current locale
    if (value == null) {
      debugPrint(
          'Translation failed: Key "$key" not found in locale ${_locale?.languageCode}');

      // Check if fallback strings exist
      if (_localizedFallbackStrings != null) {
        value = _localizedFallbackStrings![key];
        if (value != null) {
          debugPrint(
              'Translation for key "$key" not found in locale ${_locale?.languageCode}, using fallback locale en');
        }
      } else {
        debugPrint(
            'Fallback locale not loaded, returning the key "$key" as is');
        return key; // Return the key if no translation is found in both locales
      }
    }

    // If arguments are provided, format the string
    if (args != null && args.isNotEmpty) {
      for (int i = 0; i < args.length; i++) {
        value = value!.replaceAll('{$i}', args[i]);
      }
    }

    // If we reach here and the value is null, return the key itself to prevent any null issues
    return value ?? key;
  }

  // Load fallback strings from en.json
  Future<bool> loadFallbackStrings(Locale locale) async {
    debugPrint('Loading fallback localization for en');
    try {
      final languageCode =
          locale.languageCode == "my" || locale.languageCode == "mm"
              ? "my"
              : "en";
      final jsonString =
          await rootBundle.loadString('$_localizationPath/$languageCode.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      _localizedFallbackStrings = {};
      jsonMap.forEach((key, value) {
        _localizedFallbackStrings![key] = value.toString();
      });

      debugPrint(
          'Successfully loaded ${_localizedFallbackStrings!.length} strings for fallback locale en');
      return true;
    } catch (e) {
      debugPrint('Failed to load fallback localization: $e');
      return false;
    }
  }

  // Get the current locale
  Locale getCurrentLocale() {
    return _locale ?? const Locale('en', 'US');
  }

  // Change locale
  Future<void> changeLocale(Locale locale, Ref ref) async {
    await load(locale, ref.read(localizationLocalDataSourceProvider));
  }
}

// Singleton instance
final localizationService = LocalizationService();
