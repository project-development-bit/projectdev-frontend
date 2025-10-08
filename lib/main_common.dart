import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:url_strategy/url_strategy.dart';
// import 'package:cointiply_app/core/database/database_service.dart';
import 'package:cointiply_app/core/localization/app_localizations.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/config/app_flavor.dart';
import 'core/config/flavor_manager.dart';
import 'core/widgets/flavor_banner.dart';
import 'routing/app_router.dart';

/// Common app initialization function for all flavors
Future<void> runAppWithFlavor(AppFlavor flavor) async {
  // Configure URL strategy for web
  if (kIsWeb) {
    // This enables the use of clean URLs on web (without #)
    setPathUrlStrategy();
    debugPrint('🌐 Configuring web URL strategy for clean URLs');
  }
  
  // Initialize Drift database
  // await DatabaseService.init();
  
  // Print flavor information for debugging
  debugPrint('🚀 Starting app with flavor: ${flavor.displayName}');
  debugPrint('📱 App Name: ${FlavorManager.appName}');
  debugPrint('🌐 API URL: ${FlavorManager.fullApiUrl}');
  debugPrint('🔧 Debug Features: ${FlavorManager.areDebugFeaturesEnabled}');
  debugPrint('📝 Logging: ${FlavorManager.isLoggingEnabled}');
  
  // Run the app
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final currentThemeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final currentFlavor = ref.watch(flavorProvider);
    
    // Use the new router provider (fallback to simple router for now)
    // final appRouter = router; // ref.read(routerProvider).routerConfig;

    debugPrint(
        'MyApp building with locale: ${currentLocale.languageCode}-${currentLocale.countryCode}');
    debugPrint('MyApp building with theme: ${currentThemeMode.name}');
    debugPrint('MyApp building with flavor: ${currentFlavor.displayName}');
    
    return FlavorBanner(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: !FlavorManager.isProd, // Hide debug banner in production
        routerConfig: router, // Using the simple router for now
        locale: currentLocale,
        title: FlavorManager.appName, // Use flavor-specific app name

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
      ),
    );
  }
}