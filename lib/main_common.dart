import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:gigafaucet/core/config/app_local_images.dart';
import 'package:gigafaucet/core/theme/presentation/providers/app_setting_providers.dart';
import 'package:gigafaucet/core/theme/presentation/providers/app_settings_norifier.dart';
import 'package:gigafaucet/features/localization/presentation/providers/get_languages_state.dart';
import 'package:gigafaucet/features/localization/presentation/providers/localization_notifier_provider.dart';
import 'package:croppy/croppy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:gigafaucet/firebase_options.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gigafaucet/core/services/database_service.dart';
import 'package:gigafaucet/features/localization/data/helpers/app_localizations.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/config/app_flavor.dart';
import 'core/config/flavor_manager.dart';
import 'core/widgets/flavor_banner.dart';
import 'core/services/platform_recaptcha_service.dart';
import 'routing/app_router.dart';
import 'package:gigafaucet/core/utils/web_helpers.dart'
    if (dart.library.io) 'package:gigafaucet/core/utils/web_helpers_stub.dart';

// Global key for ScaffoldMessenger to show snackbars above dialogs
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Common app initialization function for all flavors
Future<void> runAppWithFlavor(AppFlavor flavor) async {
  debugPrint('Starting app initialization for flavor: ${flavor.displayName}');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  // Set the flavor first so configuration is available
  debugPrint('Initializing app for flavor: ${flavor.displayName}');
  if (kIsWeb) {
    try {
      debugPrint('Initializing Facebook SDK for web platform...');
      // initialize the facebook javascript SDK
      FacebookAuth.i.webAndDesktopInitialize(
        appId: "2571210046580943",
        cookie: true,
        xfbml: true,
        version: "v15.0",
      );
    } catch (e) {
      debugPrint('Error initializing Facebook SDK for web: $e');
    }
  }
  debugPrint('Facebook SDK initialized for web platform.');
  FlavorManager.setFlavor(flavor);
  // Initialize reCAPTCHA for all platforms
  final recaptchaSiteKey = FlavorManager.recaptchaSiteKey;
  if (!kIsWeb) {
    // For some reason, the C++ implementation of the Cassowary solver is super
    // slow in debug mode. So we force the Dart implementation to be used in
    // debug mode. This only applies to Windows.
    croppyForceUseCassowaryDartImpl = true;
  }
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

class _MyAppState extends ConsumerState<MyApp>
    with SingleTickerProviderStateMixin {
  bool _splashImageLoaded = false;
  bool _hasStartedAnimation = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize fade animation with optimized timing
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Load app settings theme from server on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appSettingsThemeProvider.notifier).loadConfig();
      ref.read(getLanguagesNotifierProvider.notifier).fetchLanguages();
      ref.read(localizationNotifierProvider.notifier).init();
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_splashImageLoaded) {
      Future.wait([
        precacheImage(AssetImage(AppLocalImages.splashLogo), context),
        precacheImage(AssetImage(AppLocalImages.splashBackground), context),
        precacheImage(
            AssetImage(AppLocalImages.splashBackgroundMobile), context),
      ]).then((_) {
        if (mounted) {
          setState(() {
            _splashImageLoaded = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _removeSplash() {
    removeSplashFromWeb();
  }

  void _startFadeIn() {
    _fadeController.forward().then((_) {
      // Remove native splash after fade-in completes
      _removeSplash();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localizationNotifierProvider).currentLocale;
    final currentThemeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final currentFlavor = ref.watch(flavorProvider);
    final appSettingsThemeState = ref.watch(appSettingsThemeProvider);
    final languageState = ref.watch(getLanguagesNotifierProvider);

    debugPrint(
        'MyApp building with locale: ${currentLocale.languageCode}-${currentLocale.countryCode}');
    debugPrint('MyApp building with theme: ${currentThemeMode.name}');
    debugPrint('MyApp building with flavor: ${currentFlavor.displayName}');
    debugPrint(
        'App settings theme loading: ${appSettingsThemeState.isLoading}');

    // Show transparent container while theme is loading - native splash is underneath
    if (appSettingsThemeState.isLoading || languageState.isLoading) {
      return MaterialApp(
        color: Colors.transparent,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: SizedBox.shrink(),
        ),
      );
    }

    // Start fade-in when theme is loaded and images are ready
    if (!_hasStartedAnimation &&
        _splashImageLoaded &&
        !_fadeController.isAnimating &&
        _fadeController.value == 0) {
      _hasStartedAnimation = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startFadeIn();
      });
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: FlavorBanner(
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
          supportedLocales: languageState.localeList.isNotEmpty
              ? languageState.localeList
              : const [
                  Locale('en', 'US'),
                  Locale('my', 'MM'),
                ],
          localizationsDelegates: [
            AppLocalizationsDelegate(ref),
            CroppyLocalizations.delegate, // <- This here
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
      ),
    );
  }
}
