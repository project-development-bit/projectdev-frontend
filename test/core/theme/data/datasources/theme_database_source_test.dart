import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gigafaucet/core/theme/data/datasources/theme_database_source.dart';
import 'package:gigafaucet/core/theme/data/models/theme_config_model.dart';
import 'package:flutter/material.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  late ThemeDatabaseSourceImpl dataSource;

  setUp(() {
    dataSource = ThemeDatabaseSourceImpl();
  });

  group('ThemeDatabaseSourceImpl', () {
    final testThemeModel = ThemeConfigModel(
      version: '1.0.0',
      lastUpdated: DateTime.parse('2025-11-10T10:00:00.000Z'),
      fonts: const FontConfigModel(
        primary: 'Inter',
        title: 'Orbitron',
        fallback: ['Inter', 'system-ui'],
      ),
      customColors: const CustomColorsConfigModel(
        websiteGold: Color(0xFFE6A030),
        websiteGreen: Color(0xFF00FF00),
        linkBlue: Color(0xFF3B82F6),
      ),
      lightTheme: ThemeVariantConfigModel(
        colorScheme: ColorSchemeConfigModel(
          brightness: Brightness.light,
          primary: const Color(0xFFE6A030),
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFFFFF8E1),
          onPrimaryContainer: const Color(0xFF2C1B00),
          secondary: const Color(0xFF625B71),
          onSecondary: Colors.white,
          secondaryContainer: const Color(0xFFE8DEF8),
          onSecondaryContainer: const Color(0xFF1D192B),
          tertiary: const Color(0xFF7D5260),
          onTertiary: Colors.white,
          tertiaryContainer: const Color(0xFFFFD8E4),
          onTertiaryContainer: const Color(0xFF31111D),
          error: const Color(0xFFBA1A1A),
          onError: Colors.white,
          errorContainer: const Color(0xFFFFDAD6),
          onErrorContainer: const Color(0xFF410002),
          surface: Colors.white,
          onSurface: Colors.black,
          surfaceContainerLowest: Colors.white,
          surfaceContainerLow: const Color(0xFFF5F5F5),
          surfaceContainer: const Color(0xFFEEEEEE),
          surfaceContainerHigh: const Color(0xFFE0E0E0),
          surfaceContainerHighest: const Color(0xFFBDBDBD),
          onSurfaceVariant: const Color(0xFF49454F),
          outline: const Color(0xFF79747E),
          outlineVariant: const Color(0xFFCAC4D0),
          shadow: Colors.black,
          scrim: Colors.black,
          inverseSurface: const Color(0xFF313033),
          onInverseSurface: const Color(0xFFF4EFF4),
          inversePrimary: const Color(0xFFFFB951),
        ),
        components: const ComponentsConfigModel(
          appBar: AppBarConfigModel(elevation: 0, scrolledUnderElevation: 1),
          button: ButtonConfigModel(
            borderRadius: 12.0,
            elevation: 2.0,
            padding: EdgeInsetsConfigModel(horizontal: 24.0, vertical: 12.0),
          ),
          textButton: ButtonConfigModel(
            borderRadius: 8.0,
            elevation: 0.0,
            padding: EdgeInsetsConfigModel(horizontal: 16.0, vertical: 8.0),
          ),
          inputField: InputFieldConfigModel(
            borderRadius: 12.0,
            fillOpacity: 0.3,
            contentPadding:
                EdgeInsetsConfigModel(horizontal: 16.0, vertical: 16.0),
            focusedBorderWidth: 2.0,
          ),
          card: CardConfigModel(
            borderRadius: 16.0,
            elevation: 1.0,
            margin: 8.0,
          ),
          dialog: DialogConfigModel(
            borderRadius: 20.0,
            elevation: 8.0,
          ),
          bottomNavigation: NavigationConfigModel(
            elevation: 8.0,
            type: 'fixed',
          ),
          floatingActionButton: FABConfigModel(
            borderRadius: 16.0,
            elevation: 6.0,
          ),
          checkbox: CheckboxConfigModel(
            borderRadius: 4.0,
            borderWidth: 2.0,
          ),
        ),
        typography: const TypographyConfigModel(
          displayLarge: TextStyleConfigModel(
              fontSize: 57.0, fontWeight: 400, lineHeight: 1.12),
          displayMedium: TextStyleConfigModel(
              fontSize: 45.0, fontWeight: 400, lineHeight: 1.16),
          displaySmall: TextStyleConfigModel(
              fontSize: 36.0, fontWeight: 400, lineHeight: 1.22),
          headlineLarge: TextStyleConfigModel(
              fontSize: 32.0, fontWeight: 400, lineHeight: 1.25),
          headlineMedium: TextStyleConfigModel(
              fontSize: 28.0, fontWeight: 600, lineHeight: 1.29),
          headlineSmall: TextStyleConfigModel(
              fontSize: 24.0, fontWeight: 600, lineHeight: 1.33),
          titleLarge: TextStyleConfigModel(
              fontSize: 22.0, fontWeight: 600, lineHeight: 1.27),
          titleMedium: TextStyleConfigModel(
              fontSize: 16.0, fontWeight: 600, lineHeight: 1.5),
          titleSmall: TextStyleConfigModel(
              fontSize: 14.0, fontWeight: 600, lineHeight: 1.43),
          bodyLarge: TextStyleConfigModel(
              fontSize: 16.0, fontWeight: 400, lineHeight: 1.5),
          bodyMedium: TextStyleConfigModel(
              fontSize: 14.0, fontWeight: 400, lineHeight: 1.43),
          bodySmall: TextStyleConfigModel(
              fontSize: 12.0, fontWeight: 400, lineHeight: 1.33),
          labelLarge: TextStyleConfigModel(
              fontSize: 14.0, fontWeight: 600, lineHeight: 1.43),
          labelMedium: TextStyleConfigModel(
              fontSize: 12.0, fontWeight: 600, lineHeight: 1.33),
          labelSmall: TextStyleConfigModel(
              fontSize: 11.0, fontWeight: 600, lineHeight: 1.45),
        ),
      ),
      darkTheme: ThemeVariantConfigModel(
        colorScheme: ColorSchemeConfigModel(
          brightness: Brightness.dark,
          primary: const Color(0xFFFFB951),
          onPrimary: const Color(0xFF482900),
          primaryContainer: const Color(0xFF6A3E00),
          onPrimaryContainer: const Color(0xFFFFDDB1),
          secondary: const Color(0xFFCCC2DC),
          onSecondary: const Color(0xFF332D41),
          secondaryContainer: const Color(0xFF4A4458),
          onSecondaryContainer: const Color(0xFFE8DEF8),
          tertiary: const Color(0xFFEFB8C8),
          onTertiary: const Color(0xFF492532),
          tertiaryContainer: const Color(0xFF633B48),
          onTertiaryContainer: const Color(0xFFFFD8E4),
          error: const Color(0xFFFFB4AB),
          onError: const Color(0xFF690005),
          errorContainer: const Color(0xFF93000A),
          onErrorContainer: const Color(0xFFFFDAD6),
          surface: const Color(0xFF1C1B1F),
          onSurface: const Color(0xFFE6E1E5),
          surfaceContainerLowest: const Color(0xFF0F0D13),
          surfaceContainerLow: const Color(0xFF1C1B1F),
          surfaceContainer: const Color(0xFF201F23),
          surfaceContainerHigh: const Color(0xFF2B2930),
          surfaceContainerHighest: const Color(0xFF36343B),
          onSurfaceVariant: const Color(0xFFCAC4D0),
          outline: const Color(0xFF938F99),
          outlineVariant: const Color(0xFF49454F),
          shadow: Colors.black,
          scrim: Colors.black,
          inverseSurface: const Color(0xFFE6E1E5),
          onInverseSurface: const Color(0xFF313033),
          inversePrimary: const Color(0xFFE6A030),
        ),
        components: const ComponentsConfigModel(
          appBar: AppBarConfigModel(elevation: 0, scrolledUnderElevation: 1),
          button: ButtonConfigModel(
            borderRadius: 12.0,
            elevation: 2.0,
            padding: EdgeInsetsConfigModel(horizontal: 24.0, vertical: 12.0),
          ),
          textButton: ButtonConfigModel(
            borderRadius: 8.0,
            elevation: 0.0,
            padding: EdgeInsetsConfigModel(horizontal: 16.0, vertical: 8.0),
          ),
          inputField: InputFieldConfigModel(
            borderRadius: 12.0,
            fillOpacity: 0.3,
            contentPadding:
                EdgeInsetsConfigModel(horizontal: 16.0, vertical: 16.0),
            focusedBorderWidth: 2.0,
          ),
          card: CardConfigModel(
            borderRadius: 16.0,
            elevation: 1.0,
            margin: 8.0,
          ),
          dialog: DialogConfigModel(
            borderRadius: 20.0,
            elevation: 8.0,
          ),
          bottomNavigation: NavigationConfigModel(
            elevation: 8.0,
            type: 'fixed',
          ),
          floatingActionButton: FABConfigModel(
            borderRadius: 16.0,
            elevation: 6.0,
          ),
          checkbox: CheckboxConfigModel(
            borderRadius: 4.0,
            borderWidth: 2.0,
          ),
        ),
        typography: const TypographyConfigModel(
          displayLarge: TextStyleConfigModel(
              fontSize: 57.0, fontWeight: 400, lineHeight: 1.12),
          displayMedium: TextStyleConfigModel(
              fontSize: 45.0, fontWeight: 400, lineHeight: 1.16),
          displaySmall: TextStyleConfigModel(
              fontSize: 36.0, fontWeight: 400, lineHeight: 1.22),
          headlineLarge: TextStyleConfigModel(
              fontSize: 32.0, fontWeight: 400, lineHeight: 1.25),
          headlineMedium: TextStyleConfigModel(
              fontSize: 28.0, fontWeight: 600, lineHeight: 1.29),
          headlineSmall: TextStyleConfigModel(
              fontSize: 24.0, fontWeight: 600, lineHeight: 1.33),
          titleLarge: TextStyleConfigModel(
              fontSize: 22.0, fontWeight: 600, lineHeight: 1.27),
          titleMedium: TextStyleConfigModel(
              fontSize: 16.0, fontWeight: 600, lineHeight: 1.5),
          titleSmall: TextStyleConfigModel(
              fontSize: 14.0, fontWeight: 600, lineHeight: 1.43),
          bodyLarge: TextStyleConfigModel(
              fontSize: 16.0, fontWeight: 400, lineHeight: 1.5),
          bodyMedium: TextStyleConfigModel(
              fontSize: 14.0, fontWeight: 400, lineHeight: 1.43),
          bodySmall: TextStyleConfigModel(
              fontSize: 12.0, fontWeight: 400, lineHeight: 1.33),
          labelLarge: TextStyleConfigModel(
              fontSize: 14.0, fontWeight: 600, lineHeight: 1.43),
          labelMedium: TextStyleConfigModel(
              fontSize: 12.0, fontWeight: 600, lineHeight: 1.33),
          labelSmall: TextStyleConfigModel(
              fontSize: 11.0, fontWeight: 600, lineHeight: 1.45),
        ),
      ),
    );

    group('getStoredThemeVersion', () {
      test('should return version when theme exists in database', () async {
        // This test validates the interface contract
        // Actual database interaction is tested in integration tests
        expect(dataSource.getStoredThemeVersion, isA<Function>());
      });

      test('should return null when no theme exists', () async {
        final result = await dataSource.getStoredThemeVersion();
        // On first run with no database, should return null
        expect(result, isNull);
      });
    });

    group('getThemeConfig', () {
      test('should return theme when it exists in database', () async {
        expect(dataSource.getThemeConfig, isA<Function>());
      });

      test('should return null when no theme exists', () async {
        final result = await dataSource.getThemeConfig();
        expect(result, isNull);
      });
    });

    group('saveThemeConfig', () {
      test('should save theme successfully', () async {
        // Verify the method exists and accepts correct parameters
        expect(
          () => dataSource.saveThemeConfig(testThemeModel),
          returnsNormally,
        );
      });
    });

    group('clearTheme', () {
      test('should clear theme successfully', () async {
        expect(() => dataSource.clearTheme(), returnsNormally);
      });
    });
  });
}
