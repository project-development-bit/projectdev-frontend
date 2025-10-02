import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cointiply_app/core/hive/hive_helper.dart';
import 'package:cointiply_app/core/localization/app_localizations.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final currentThemeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    debugPrint(
        'MyApp building with locale: ${currentLocale.languageCode}-${currentLocale.countryCode}');
    debugPrint('MyApp building with theme: ${currentThemeMode.name}');
    
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      locale: currentLocale,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeNotifier.getEffectiveThemeMode(
        MediaQuery.platformBrightnessOf(context),
      ),
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('my', 'MM'), // Burmese
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        debugPrint(
            'Locale resolution - device: $locale, current: $currentLocale');

        // First check if the current locale from provider is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == currentLocale.languageCode) {
            debugPrint('Using provider locale: $currentLocale');
            return currentLocale;
          }
        }

        // Fallback to device locale if supported
        if (locale != null) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }

        debugPrint('Using default locale: ${supportedLocales.first}');
        return supportedLocales.first;
      },
    );
  }
}