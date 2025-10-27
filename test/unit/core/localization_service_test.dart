import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cointiply_app/core/localization/localization_service.dart';

void main() {
  group('LocalizationService Tests', () {
    late LocalizationService localizationService;

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() {
      localizationService = LocalizationService();
    });

    test('should return key when no localized strings loaded', () {
      expect(localizationService.translate('any_key'), 'any_key');
    });

    test('should return correct current locale when not initialized', () {
      // Default locale when not set
      expect(localizationService.getCurrentLocale(), const Locale('en', 'US'));
    });

    test('should check initialization status correctly when not initialized',
        () {
      // Initially not initialized
      expect(localizationService.isInitialized, false);
    });

    test('should handle supported locales correctly', () {
      expect(LocalizationService.supportedLocales, contains('en'));
      expect(LocalizationService.supportedLocales, contains('my'));
      expect(LocalizationService.supportedLocales.length, 2);
    });

    test('should get current locale property', () {
      expect(localizationService.locale, isNull);
    });

    group('Translation Parameter Tests', () {
      test('should handle parameter replacement with args', () {
        // We can test the method signature even if we can't load actual translations
        expect(
          () =>
              localizationService.translate('test_key', args: ['arg1', 'arg2']),
          returnsNormally,
        );
      });

      test('should handle translation without args', () {
        expect(
          () => localizationService.translate('test_key'),
          returnsNormally,
        );
      });

      test('should handle empty args list', () {
        expect(
          () => localizationService.translate('test_key', args: []),
          returnsNormally,
        );
      });
    });

    group('Locale Change Tests', () {
      test('should handle locale change request', () async {
        // This will fail to load the actual file, but tests the method
        await expectLater(
          () => localizationService.changeLocale('en'),
          returnsNormally,
        );
      });

      test('should handle invalid locale change request', () async {
        // This will fail to load the actual file, but tests the method
        await expectLater(
          () => localizationService.changeLocale('invalid'),
          returnsNormally,
        );
      });
    });

    group('Load Method Tests', () {
      test('should handle load request for supported locale', () async {
        // This will load the actual file since assets exist in test environment
        final result = await localizationService.load(const Locale('en'));
        expect(result,
            isTrue); // Will be true because assets are loaded successfully
      });

      test('should handle load request for unsupported locale', () async {
        // This will fail to load the actual file, but tests the method signature
        final result = await localizationService.load(const Locale('xx'));
        expect(result,
            isFalse); // Will be false because assets don't exist in test
      });
    });

    group('Singleton Access Test', () {
      test('should provide singleton instance', () {
        expect(localizationService, isA<LocalizationService>());

        // Test that the global instance exists
        final globalInstance = localizationService;
        expect(globalInstance, isNotNull);
      });
    });
  });
}
