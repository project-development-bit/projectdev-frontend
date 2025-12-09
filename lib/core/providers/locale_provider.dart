// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LocaleNotifier extends StateNotifier<Locale> {
//   LocaleNotifier() : super(const Locale('en', 'US')) {
//     _loadLocale();
//   }

//   static const String _languageKey = 'selected_language_code';
//   static const String _countryKey = 'selected_country_code';

//   Future<void> _loadLocale() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final languageCode = prefs.getString(_languageKey) ?? 'en';
//       final countryCode = prefs.getString(_countryKey) ?? 'US';
//       final newLocale = Locale(languageCode, countryCode);
//       debugPrint('Loading saved locale: $languageCode-$countryCode');
//       state = newLocale;
//     } catch (e) {
//       // If there's an error, keep the default locale
//       state = const Locale('en', 'US');
//       debugPrint('Error loading locale: $e');
//     }
//   }

//   Future<void> setLocale(Locale locale) async {
//     try {
//       debugPrint(
//           'Setting locale to: ${locale.languageCode}-${locale.countryCode}');
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(_languageKey, locale.languageCode);
//       await prefs.setString(_countryKey, locale.countryCode ?? 'US');
//       state = locale;
//       debugPrint(
//           'Locale set successfully to: ${state.languageCode}-${state.countryCode}');
//     } catch (e) {
//       // Handle error gracefully
//       debugPrint('Error saving locale: $e');
//     }
//   }

//   // Supported locales
//   static const List<Locale> supportedLocales = [
//     Locale('en', 'US'), // English
//     Locale('my', 'MM'), // Myanmar
//   ];

//   // Get locale display name
//   String getLocaleDisplayName(Locale locale) {
//     switch (locale.languageCode) {
//       case 'en':
//         return 'English';
//       case 'my':
//         return 'မြန်မာ';
//       default:
//         return 'English';
//     }
//   }

//   // Get locale flag emoji
//   String getLocaleFlag(Locale locale) {
//     switch (locale.languageCode) {
//       case 'en':
//         return '🇺🇸';
//       case 'my':
//         return '🇲🇲';
//       default:
//         return '🇺🇸';
//     }
//   }

//   // Get current locale display name
//   String get currentLocaleDisplayName => getLocaleDisplayName(state);

//   // Get current locale flag
//   String get currentLocaleFlag => getLocaleFlag(state);

//   // Toggle between locales
//   Future<void> toggleLocale() async {
//     if (state.languageCode == 'en') {
//       await setLocale(const Locale('my', 'MM'));
//     } else {
//       await setLocale(const Locale('en', 'US'));
//     }
//   }
// }

// // Provider for locale management
// final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
//   return LocaleNotifier();
// });

// // Provider for getting locale display names
// final localeDisplayNameProvider = Provider<String>((ref) {
//   final locale = ref.watch(localeProvider);
//   final notifier = ref.read(localeProvider.notifier);
//   return notifier.getLocaleDisplayName(locale);
// });

// // Provider for getting locale flags
// final localeFlagProvider = Provider<String>((ref) {
//   final locale = ref.watch(localeProvider);
//   final notifier = ref.read(localeProvider.notifier);
//   return notifier.getLocaleFlag(locale);
// });
