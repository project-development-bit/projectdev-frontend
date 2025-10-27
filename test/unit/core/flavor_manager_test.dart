import 'package:flutter_test/flutter_test.dart';
import 'package:cointiply_app/core/config/app_flavor.dart';
import 'package:cointiply_app/core/config/app_config.dart';
import 'package:cointiply_app/core/config/flavor_manager.dart';

void main() {
  group('FlavorManager Tests', () {
    setUp(() {
      // Reset flavor manager before each test
      FlavorManager.initialize(AppFlavor.dev);
    });

    test('should initialize with dev flavor', () {
      FlavorManager.initialize(AppFlavor.dev);

      expect(FlavorManager.currentFlavor, AppFlavor.dev);
      expect(FlavorManager.appName, 'Gigafaucet (Dev)');
      expect(FlavorManager.apiBaseUrl, 'https://api-dev.burgereats.com');
      expect(FlavorManager.areDebugFeaturesEnabled, true);
      expect(FlavorManager.isLoggingEnabled, true);
    });

    test('should initialize with staging flavor', () {
      FlavorManager.initialize(AppFlavor.staging);

      expect(FlavorManager.currentFlavor, AppFlavor.staging);
      expect(FlavorManager.appName, 'Gigafaucet (Staging)');
      expect(FlavorManager.apiBaseUrl, 'https://api-staging.burgereats.com');
      expect(FlavorManager.areDebugFeaturesEnabled,
          true); // Staging has debug features enabled
      expect(FlavorManager.isLoggingEnabled, true);
    });

    test('should initialize with prod flavor', () {
      FlavorManager.initialize(AppFlavor.prod);

      expect(FlavorManager.currentFlavor, AppFlavor.prod);
      expect(FlavorManager.appName, 'Gigafaucet');
      expect(FlavorManager.apiBaseUrl, 'https://api.burgereats.com');
      expect(FlavorManager.areDebugFeaturesEnabled, false);
      expect(FlavorManager.isLoggingEnabled, false);
    });

    test('should generate correct full API URL', () {
      FlavorManager.initialize(AppFlavor.dev);
      expect(FlavorManager.fullApiUrl, 'https://api-dev.burgereats.com/v1');

      FlavorManager.initialize(AppFlavor.staging);
      expect(FlavorManager.fullApiUrl, 'https://api-staging.burgereats.com/v1');

      FlavorManager.initialize(AppFlavor.prod);
      expect(FlavorManager.fullApiUrl, 'https://api.burgereats.com/v1');
    });

    test('should have correct display names', () {
      expect(AppFlavor.dev.displayName, 'Development');
      expect(AppFlavor.staging.displayName, 'Staging');
      expect(AppFlavor.prod.displayName, 'Production');
    });

    test('should have correct flavor check methods', () {
      FlavorManager.initialize(AppFlavor.dev);
      expect(FlavorManager.isDev, true);
      expect(FlavorManager.isStaging, false);
      expect(FlavorManager.isProd, false);

      FlavorManager.initialize(AppFlavor.staging);
      expect(FlavorManager.isDev, false);
      expect(FlavorManager.isStaging, true);
      expect(FlavorManager.isProd, false);

      FlavorManager.initialize(AppFlavor.prod);
      expect(FlavorManager.isDev, false);
      expect(FlavorManager.isStaging, false);
      expect(FlavorManager.isProd, true);
    });
  });

  group('AppConfig Tests', () {
    test('should return correct config for each flavor', () {
      final configs = {
        AppFlavor.dev: AppConfig.dev,
        AppFlavor.staging: AppConfig.staging,
        AppFlavor.prod: AppConfig.prod,
      };

      for (final entry in configs.entries) {
        final flavor = entry.key;
        final config = entry.value;

        expect(config.apiBaseUrl, isNotEmpty);
        expect(config.appName, isNotEmpty);
        expect(config.enableDebugFeatures, isA<bool>());
        expect(config.enableLogging, isA<bool>());

        // Verify that dev has debug features enabled
        if (flavor == AppFlavor.dev) {
          expect(config.enableDebugFeatures, true);
          expect(config.enableLogging, true);
        }

        // Verify that staging has debug features enabled but different settings
        if (flavor == AppFlavor.staging) {
          expect(config.enableDebugFeatures, true);
          expect(config.enableLogging, true);
          expect(config.enableCrashReporting, true);
        }

        // Verify that prod has debug features disabled
        if (flavor == AppFlavor.prod) {
          expect(config.enableDebugFeatures, false);
          expect(config.enableLogging, false);
          expect(config.enableCrashReporting, true);
          expect(config.enableAnalytics, true);
        }
      }
    });

    test('should have valid API URLs', () {
      final configs = [AppConfig.dev, AppConfig.staging, AppConfig.prod];

      for (final config in configs) {
        expect(config.apiBaseUrl, startsWith('https://'));
        expect(config.apiBaseUrl, contains('burgereats.com'));
      }
    });

    test('should have correct timeout configurations', () {
      final devConfig = AppConfig.dev;
      expect(devConfig.connectTimeout, const Duration(seconds: 10));
      expect(devConfig.receiveTimeout, const Duration(seconds: 10));
      expect(devConfig.sendTimeout, const Duration(seconds: 10));

      final prodConfig = AppConfig.prod;
      expect(prodConfig.connectTimeout, const Duration(seconds: 30));
      expect(prodConfig.receiveTimeout, const Duration(seconds: 30));
      expect(prodConfig.sendTimeout, const Duration(seconds: 30));
    });

    test('should have correct feature flags', () {
      final devConfig = AppConfig.dev;
      expect(devConfig.enableDebugFeatures, true);
      expect(devConfig.enableLogging, true);
      expect(devConfig.enableCrashReporting, false);
      expect(devConfig.enableAnalytics, false);

      final prodConfig = AppConfig.prod;
      expect(prodConfig.enableDebugFeatures, false);
      expect(prodConfig.enableLogging, false);
      expect(prodConfig.enableCrashReporting, true);
      expect(prodConfig.enableAnalytics, true);
    });
  });
}
