import 'package:flutter/material.dart';

/// Entity representing theme configuration
class ThemeConfig {
  final String version;
  final DateTime lastUpdated;
  final FontConfig fonts;
  final CustomColorsConfig customColors;
  final ThemeVariantConfig lightTheme;
  final ThemeVariantConfig darkTheme;

  const ThemeConfig({
    required this.version,
    required this.lastUpdated,
    required this.fonts,
    required this.customColors,
    required this.lightTheme,
    required this.darkTheme,
  });
}

/// Font configuration
class FontConfig {
  final String primary;
  final String title;
  final List<String> fallback;

  const FontConfig({
    required this.primary,
    required this.title,
    required this.fallback,
  });
}

/// Custom colors configuration
class CustomColorsConfig {
  final Color websiteGold;
  final Color websiteGreen;
  final Color linkBlue;

  const CustomColorsConfig({
    required this.websiteGold,
    required this.websiteGreen,
    required this.linkBlue,
  });
}

/// Theme variant (light or dark)
class ThemeVariantConfig {
  final ColorSchemeConfig colorScheme;
  final ComponentsConfig components;
  final TypographyConfig typography;

  const ThemeVariantConfig({
    required this.colorScheme,
    required this.components,
    required this.typography,
  });
}

/// Color scheme configuration
class ColorSchemeConfig {
  final Brightness brightness;
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color surface;
  final Color onSurface;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color onInverseSurface;
  final Color inversePrimary;

  const ColorSchemeConfig({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.surface,
    required this.onSurface,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.inversePrimary,
  });

  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerLowest: surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow,
      surfaceContainer: surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: onInverseSurface,
      inversePrimary: inversePrimary,
    );
  }
}

/// Components styling configuration
class ComponentsConfig {
  final AppBarConfig appBar;
  final ButtonConfig button;
  final ButtonConfig textButton;
  final InputFieldConfig inputField;
  final CardConfig card;
  final DialogConfig dialog;
  final NavigationConfig bottomNavigation;
  final FABConfig floatingActionButton;
  final CheckboxConfig checkbox;

  const ComponentsConfig({
    required this.appBar,
    required this.button,
    required this.textButton,
    required this.inputField,
    required this.card,
    required this.dialog,
    required this.bottomNavigation,
    required this.floatingActionButton,
    required this.checkbox,
  });
}

class AppBarConfig {
  final double elevation;
  final double scrolledUnderElevation;

  const AppBarConfig({
    required this.elevation,
    required this.scrolledUnderElevation,
  });
}

class ButtonConfig {
  final double borderRadius;
  final double elevation;
  final EdgeInsetsConfig padding;

  const ButtonConfig({
    required this.borderRadius,
    required this.elevation,
    required this.padding,
  });
}

class InputFieldConfig {
  final double borderRadius;
  final double fillOpacity;
  final EdgeInsetsConfig contentPadding;
  final double focusedBorderWidth;

  const InputFieldConfig({
    required this.borderRadius,
    required this.fillOpacity,
    required this.contentPadding,
    required this.focusedBorderWidth,
  });
}

class CardConfig {
  final double borderRadius;
  final double elevation;
  final double margin;

  const CardConfig({
    required this.borderRadius,
    required this.elevation,
    required this.margin,
  });
}

class DialogConfig {
  final double borderRadius;
  final double elevation;

  const DialogConfig({
    required this.borderRadius,
    required this.elevation,
  });
}

class NavigationConfig {
  final double elevation;
  final String type;

  const NavigationConfig({
    required this.elevation,
    required this.type,
  });
}

class FABConfig {
  final double borderRadius;
  final double elevation;

  const FABConfig({
    required this.borderRadius,
    required this.elevation,
  });
}

class CheckboxConfig {
  final double borderRadius;
  final double borderWidth;

  const CheckboxConfig({
    required this.borderRadius,
    required this.borderWidth,
  });
}

class EdgeInsetsConfig {
  final double horizontal;
  final double vertical;

  const EdgeInsetsConfig({
    required this.horizontal,
    required this.vertical,
  });

  EdgeInsets toEdgeInsets() {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }
}

/// Typography configuration
class TypographyConfig {
  final TextStyleConfig displayLarge;
  final TextStyleConfig displayMedium;
  final TextStyleConfig displaySmall;
  final TextStyleConfig headlineLarge;
  final TextStyleConfig headlineMedium;
  final TextStyleConfig headlineSmall;
  final TextStyleConfig titleLarge;
  final TextStyleConfig titleMedium;
  final TextStyleConfig titleSmall;
  final TextStyleConfig bodyLarge;
  final TextStyleConfig bodyMedium;
  final TextStyleConfig bodySmall;
  final TextStyleConfig labelLarge;
  final TextStyleConfig labelMedium;
  final TextStyleConfig labelSmall;

  const TypographyConfig({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });
}

class TextStyleConfig {
  final double fontSize;
  final int fontWeight;
  final double lineHeight;
  final double? letterSpacing;

  const TextStyleConfig({
    required this.fontSize,
    required this.fontWeight,
    required this.lineHeight,
    this.letterSpacing,
  });

  TextStyle toTextStyle(String fontFamily) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: _fontWeightFromValue(fontWeight),
      height: lineHeight,
      letterSpacing: letterSpacing,
    );
  }

  static FontWeight _fontWeightFromValue(int value) {
    switch (value) {
      case 100:
        return FontWeight.w100;
      case 200:
        return FontWeight.w200;
      case 300:
        return FontWeight.w300;
      case 400:
        return FontWeight.w400;
      case 500:
        return FontWeight.w500;
      case 600:
        return FontWeight.w600;
      case 700:
        return FontWeight.w700;
      case 800:
        return FontWeight.w800;
      case 900:
        return FontWeight.w900;
      default:
        return FontWeight.w400;
    }
  }
}
