import 'package:cointiply_app/features/user_profile/presentation/providers/change_language_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cointiply_app/features/localization/domain/usecases/get_localization_use_case.dart';
import 'package:cointiply_app/features/localization/presentation/providers/localization_state.dart';

class LocalizationController extends StateNotifier<LocalizationState> {
  final GetLocalizationUseCase _useCase;
  final Ref _ref;

  LocalizationController(this._useCase, this._ref)
      : super(const LocalizationState()) {
    _init(); // load saved locale + load translations
  }

  static const String _languageKey = 'selected_language_code';
  static const String _countryKey = 'selected_country_code';

  // --------------------------
  // INIT: Load saved locale + translation
  // --------------------------
  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();

    final language = prefs.getString(_languageKey) ?? "en";
    final country = prefs.getString(_countryKey) ?? "US";

    final locale = Locale(language, country);
    state = state.copyWith(currentLocale: locale);

    await _loadLocalizationFromApi(locale.languageCode);
  }

  // --------------------------
  // LOAD TRANSLATION API + CACHE
  // --------------------------
  Future<void> _loadLocalizationFromApi(String locale, {String? userid}) async {
    state = state.copyWith(
      status: LocalizationStatus.loading,
      error: "",
    );

    final result = await _useCase(locale);

    result.fold(
      (failure) {
        debugPrint("❌ Failed to load localization: ${failure.message}");
        state = state.copyWith(
          status: LocalizationStatus.error,
          error: failure.message,
        );
      },
      (localization) {
        state = state.copyWith(
          status: LocalizationStatus.success,
          localization: localization,
        );
        if (userid != null) {
          debugPrint("🌐 Translations loaded for user: $userid");
          _ref.read(changeLanguageProvider.notifier).changeLanguage(
                languageCode: locale,
                languageName: locale.toUpperCase(),
                userid: userid,
              );
        }
      },
    );
  }

  // --------------------------
  // CHANGE LOCALE (user action)
  // --------------------------
  Future<void> changeLocale(Locale locale, {String? userid}) async {
    // Save locale to device
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
    await prefs.setString(_countryKey, locale.countryCode ?? "US");

    debugPrint("🌐 Locale switched → ${locale.languageCode}");

    // Update state
    state = state.copyWith(
        currentLocale: locale, error: "", status: LocalizationStatus.loading);

    // Fetch translations
    await _loadLocalizationFromApi(locale.languageCode, userid: userid);
  }

  // --------------------------
  // TOGGLE EN/MY (optional)
  // --------------------------
  Future<void> toggleLocale() async {
    if (state.currentLocale.languageCode == "en") {
      await changeLocale(const Locale("my", "MM"));
    } else {
      await changeLocale(const Locale("en", "US"));
    }
  }

  // --------------------------
  // TRANSLATE
  // --------------------------
  String t(String key, {List<String>? args}) {
    String value = state.localization?.get(key) ?? key;

    if (args != null && args.isNotEmpty) {
      for (int i = 0; i < args.length; i++) {
        value = value.replaceAll('{$i}', args[i]);
      }
    }

    return value;
  }

  // Helpers
  static const supportedLocales = [
    Locale("en", "US"),
    Locale("my", "MM"),
  ];

  String getLocaleName(Locale code) {
    switch (code.languageCode) {
      case "my":
        return "မြန်မာ";
      default:
        return "English";
    }
  }

  String getFlag(Locale code) {
    switch (code.languageCode) {
      case "my":
        return "🇲🇲";
      default:
        return "🇺🇸";
    }
  }
}
