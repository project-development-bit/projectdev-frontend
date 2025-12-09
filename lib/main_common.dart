import 'package:cointiply_app/core/theme/presentation/providers/app_setting_providers.dart';
import 'package:cointiply_app/core/theme/presentation/providers/app_settings_norifier.dart';
import 'package:cointiply_app/features/localization/presentation/providers/localization_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cointiply_app/core/services/database_service.dart';
import 'package:cointiply_app/features/localization/data/helpers/app_localizations.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/config/app_flavor.dart';
import 'core/config/flavor_manager.dart';
import 'core/widgets/flavor_banner.dart';
import 'core/services/platform_recaptcha_service.dart';
import 'routing/app_router.dart';

// Global key for ScaffoldMessenger to show snackbars above dialogs
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Common app initialization function for all flavors
Future<void> runAppWithFlavor(AppFlavor flavor) async {
  // Set the flavor first so configuration is available
  FlavorManager.setFlavor(flavor);

  // Initialize reCAPTCHA for all platforms
  final recaptchaSiteKey = FlavorManager.recaptchaSiteKey;
  if (recaptchaSiteKey != null) {
    try {
      if (kIsWeb) {
        debugPrint('🌐 Web platform detected - initializing g_recaptcha_v3');
        debugPrint(
            '🔑 Using web reCAPTCHA site key: ${recaptchaSiteKey.substring(0, 10)}...');

        // Configure URL strategy for web
        setPathUrlStrategy();
        debugPrint('🌐 Configured web URL strategy for clean URLs');
      } else {
        // Mobile platform detection using our platform service
        if (PlatformRecaptchaService.isAndroid) {
          debugPrint('📱 Android platform detected');
        } else if (PlatformRecaptchaService.isIOS) {
          debugPrint('📱 iOS platform detected');
        }

        if (PlatformRecaptchaService.isMobilePlatform) {
          debugPrint(
              '🔐 Initializing reCAPTCHA Enterprise for ${FlavorManager.flavorDisplayName}...');
          debugPrint(
              '🔑 Using mobile reCAPTCHA site key: ${recaptchaSiteKey.substring(0, 10)}...');
        }
      }

      // Initialize through the unified platform service
      final success = await PlatformRecaptchaService.initialize();
      if (success) {
        debugPrint(
            '✅ reCAPTCHA client initialized successfully for ${PlatformRecaptchaService.platformName}');
        debugPrint(
            '📋 Platform info: ${PlatformRecaptchaService.getPlatformErrorMessage()}');
      } else {
        debugPrint(
            '❌ reCAPTCHA initialization failed for ${PlatformRecaptchaService.platformName}');
      }
    } catch (e) {
      debugPrint('❌ reCAPTCHA initialization failed: $e');
    }
  } else {
    debugPrint(
        '⚠️ No reCAPTCHA site key configured for ${FlavorManager.flavorDisplayName}');
    if (kIsWeb) {
      // Still configure URL strategy even without reCAPTCHA
      setPathUrlStrategy();
      debugPrint('🌐 Configured web URL strategy for clean URLs');
    }
  }

  // Initialize SQLite database
  await DatabaseService.init();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Print flavor information for debugging
  debugPrint('🚀 Starting app with flavor: ${flavor.displayName}');
  debugPrint('📱 App Name: ${FlavorManager.appName}');
  debugPrint('🌐 API URL: ${FlavorManager.fullApiUrl}');
  debugPrint('🔧 Debug Features: ${FlavorManager.areDebugFeaturesEnabled}');
  debugPrint('📝 Logging: ${FlavorManager.isLoggingEnabled}');

  // Run the app with provider overrides
  runApp(
    ProviderScope(
      overrides: [
        // Override shared preferences for app settings theme
        sharedPreferencesProviderForAppSettings.overrideWithValue(
          sharedPreferences,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Load app settings theme from server on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appSettingsThemeProvider.notifier).loadConfig();
    });

    ref.listenManual<AppSettingsState>(
      appSettingsThemeProvider,
      (previous, next) {
        final oldVersion = previous?.config?.languageVersion;
        final newVersion = next.config?.languageVersion;

        if (oldVersion != newVersion) {
          ref.read(localizationNotifierProvider.notifier).init(
                languageVersion: newVersion,
              );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localizationNotifierProvider).currentLocale;
    final currentThemeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final currentFlavor = ref.watch(flavorProvider);
    final appSettingsThemeState = ref.watch(appSettingsThemeProvider);

    debugPrint(
        'MyApp building with locale: ${currentLocale.languageCode}-${currentLocale.countryCode}');
    debugPrint('MyApp building with theme: ${currentThemeMode.name}');
    debugPrint('MyApp building with flavor: ${currentFlavor.displayName}');
    debugPrint(
        'App settings theme loading: ${appSettingsThemeState.isLoading}');

    // Show splash screen while theme is loading
    if (appSettingsThemeState.isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xff1A1A1A),
          body: Container(
            decoration: BoxDecoration(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo/Icon
                  Icon(
                    Icons.restaurant_menu,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  // App Name
                  Text(
                    FlavorManager.appName,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Loading indicator
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Loading theme...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return FlavorBanner(
      child: MaterialApp.router(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        debugShowCheckedModeBanner:
            !FlavorManager.isProd, // Hide debug banner in production
        routerConfig: ref.read(goRouterProvider), // Using persistent router
        locale: currentLocale,
        title: FlavorManager.appName, // Use flavor-specific app name

        // Theme configuration - Use app settings theme from server, fallback to default theme
        theme: appSettingsThemeState.lightTheme ?? AppTheme.lightTheme,
        darkTheme: appSettingsThemeState.darkTheme ?? AppTheme.darkTheme,
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
