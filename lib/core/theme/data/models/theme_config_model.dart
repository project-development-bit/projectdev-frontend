import 'package:flutter/material.dart';
import '../../domain/entities/theme_config.dart';

/// Model for theme configuration with JSON serialization
class ThemeConfigModel extends ThemeConfig {
  const ThemeConfigModel({
    required super.version,
    required super.lastUpdated,
    required super.fonts,
    required super.customColors,
    required super.lightTheme,
    required super.darkTheme,
  });

  factory ThemeConfigModel.fromJson(Map<String, dynamic> json) {
    return ThemeConfigModel(
      version: json['version'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      fonts: FontConfigModel.fromJson(json['fonts'] as Map<String, dynamic>),
      customColors: CustomColorsConfigModel.fromJson(
          json['customColors'] as Map<String, dynamic>),
      lightTheme: ThemeVariantConfigModel.fromJson(
          json['themes']['light'] as Map<String, dynamic>),
      darkTheme: ThemeVariantConfigModel.fromJson(
          json['themes']['dark'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'lastUpdated': lastUpdated.toIso8601String(),
      'fonts': (fonts as FontConfigModel).toJson(),
      'customColors': (customColors as CustomColorsConfigModel).toJson(),
      'themes': {
        'light': (lightTheme as ThemeVariantConfigModel).toJson(),
        'dark': (darkTheme as ThemeVariantConfigModel).toJson(),
      },
    };
  }
}

class FontConfigModel extends FontConfig {
  const FontConfigModel({
    required super.primary,
    required super.title,
    required super.fallback,
  });

  factory FontConfigModel.fromJson(Map<String, dynamic> json) {
    return FontConfigModel(
      primary: json['primary'] as String,
      title: json['title'] as String,
      fallback: (json['fallback'] as List).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primary': primary,
      'title': title,
      'fallback': fallback,
    };
  }
}

class CustomColorsConfigModel extends CustomColorsConfig {
  const CustomColorsConfigModel({
    required super.websiteGold,
    required super.websiteGreen,
    required super.linkBlue,
  });

  factory CustomColorsConfigModel.fromJson(Map<String, dynamic> json) {
    return CustomColorsConfigModel(
      websiteGold: _colorFromHex(json['websiteGold'] as String),
      websiteGreen: _colorFromHex(json['websiteGreen'] as String),
      linkBlue: _colorFromHex(json['linkBlue'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'websiteGold': _colorToHex(websiteGold),
      'websiteGreen': _colorToHex(websiteGreen),
      'linkBlue': _colorToHex(linkBlue),
    };
  }
}

class ThemeVariantConfigModel extends ThemeVariantConfig {
  const ThemeVariantConfigModel({
    required super.colorScheme,
    required super.components,
    required super.typography,
  });

  factory ThemeVariantConfigModel.fromJson(Map<String, dynamic> json) {
    return ThemeVariantConfigModel(
      colorScheme: ColorSchemeConfigModel.fromJson(
          json['colorScheme'] as Map<String, dynamic>),
      components: ComponentsConfigModel.fromJson(
          json['components'] as Map<String, dynamic>),
      typography: TypographyConfigModel.fromJson(
          json['typography'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'colorScheme': (colorScheme as ColorSchemeConfigModel).toJson(),
      'components': (components as ComponentsConfigModel).toJson(),
      'typography': (typography as TypographyConfigModel).toJson(),
    };
  }
}

class ColorSchemeConfigModel extends ColorSchemeConfig {
  const ColorSchemeConfigModel({
    required super.brightness,
    required super.primary,
    required super.onPrimary,
    required super.primaryContainer,
    required super.onPrimaryContainer,
    required super.secondary,
    required super.onSecondary,
    required super.secondaryContainer,
    required super.onSecondaryContainer,
    required super.tertiary,
    required super.onTertiary,
    required super.tertiaryContainer,
    required super.onTertiaryContainer,
    required super.error,
    required super.onError,
    required super.errorContainer,
    required super.onErrorContainer,
    required super.surface,
    required super.onSurface,
    required super.surfaceContainerLowest,
    required super.surfaceContainerLow,
    required super.surfaceContainer,
    required super.surfaceContainerHigh,
    required super.surfaceContainerHighest,
    required super.onSurfaceVariant,
    required super.outline,
    required super.outlineVariant,
    required super.shadow,
    required super.scrim,
    required super.inverseSurface,
    required super.onInverseSurface,
    required super.inversePrimary,
  });

  factory ColorSchemeConfigModel.fromJson(Map<String, dynamic> json) {
    return ColorSchemeConfigModel(
      brightness: json['brightness'] == 'dark'
          ? Brightness.dark
          : Brightness.light,
      primary: _colorFromHex(json['primary'] as String),
      onPrimary: _colorFromHex(json['onPrimary'] as String),
      primaryContainer: _colorFromHex(json['primaryContainer'] as String),
      onPrimaryContainer: _colorFromHex(json['onPrimaryContainer'] as String),
      secondary: _colorFromHex(json['secondary'] as String),
      onSecondary: _colorFromHex(json['onSecondary'] as String),
      secondaryContainer: _colorFromHex(json['secondaryContainer'] as String),
      onSecondaryContainer:
          _colorFromHex(json['onSecondaryContainer'] as String),
      tertiary: _colorFromHex(json['tertiary'] as String),
      onTertiary: _colorFromHex(json['onTertiary'] as String),
      tertiaryContainer: _colorFromHex(json['tertiaryContainer'] as String),
      onTertiaryContainer:
          _colorFromHex(json['onTertiaryContainer'] as String),
      error: _colorFromHex(json['error'] as String),
      onError: _colorFromHex(json['onError'] as String),
      errorContainer: _colorFromHex(json['errorContainer'] as String),
      onErrorContainer: _colorFromHex(json['onErrorContainer'] as String),
      surface: _colorFromHex(json['surface'] as String),
      onSurface: _colorFromHex(json['onSurface'] as String),
      surfaceContainerLowest:
          _colorFromHex(json['surfaceContainerLowest'] as String),
      surfaceContainerLow:
          _colorFromHex(json['surfaceContainerLow'] as String),
      surfaceContainer: _colorFromHex(json['surfaceContainer'] as String),
      surfaceContainerHigh:
          _colorFromHex(json['surfaceContainerHigh'] as String),
      surfaceContainerHighest:
          _colorFromHex(json['surfaceContainerHighest'] as String),
      onSurfaceVariant: _colorFromHex(json['onSurfaceVariant'] as String),
      outline: _colorFromHex(json['outline'] as String),
      outlineVariant: _colorFromHex(json['outlineVariant'] as String),
      shadow: _colorFromHex(json['shadow'] as String),
      scrim: _colorFromHex(json['scrim'] as String),
      inverseSurface: _colorFromHex(json['inverseSurface'] as String),
      onInverseSurface: _colorFromHex(json['onInverseSurface'] as String),
      inversePrimary: _colorFromHex(json['inversePrimary'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brightness': brightness.name,
      'primary': _colorToHex(primary),
      'onPrimary': _colorToHex(onPrimary),
      'primaryContainer': _colorToHex(primaryContainer),
      'onPrimaryContainer': _colorToHex(onPrimaryContainer),
      'secondary': _colorToHex(secondary),
      'onSecondary': _colorToHex(onSecondary),
      'secondaryContainer': _colorToHex(secondaryContainer),
      'onSecondaryContainer': _colorToHex(onSecondaryContainer),
      'tertiary': _colorToHex(tertiary),
      'onTertiary': _colorToHex(onTertiary),
      'tertiaryContainer': _colorToHex(tertiaryContainer),
      'onTertiaryContainer': _colorToHex(onTertiaryContainer),
      'error': _colorToHex(error),
      'onError': _colorToHex(onError),
      'errorContainer': _colorToHex(errorContainer),
      'onErrorContainer': _colorToHex(onErrorContainer),
      'surface': _colorToHex(surface),
      'onSurface': _colorToHex(onSurface),
      'surfaceContainerLowest': _colorToHex(surfaceContainerLowest),
      'surfaceContainerLow': _colorToHex(surfaceContainerLow),
      'surfaceContainer': _colorToHex(surfaceContainer),
      'surfaceContainerHigh': _colorToHex(surfaceContainerHigh),
      'surfaceContainerHighest': _colorToHex(surfaceContainerHighest),
      'onSurfaceVariant': _colorToHex(onSurfaceVariant),
      'outline': _colorToHex(outline),
      'outlineVariant': _colorToHex(outlineVariant),
      'shadow': _colorToHex(shadow),
      'scrim': _colorToHex(scrim),
      'inverseSurface': _colorToHex(inverseSurface),
      'onInverseSurface': _colorToHex(onInverseSurface),
      'inversePrimary': _colorToHex(inversePrimary),
    };
  }
}

class ComponentsConfigModel extends ComponentsConfig {
  const ComponentsConfigModel({
    required super.appBar,
    required super.button,
    required super.textButton,
    required super.inputField,
    required super.card,
    required super.dialog,
    required super.bottomNavigation,
    required super.floatingActionButton,
    required super.checkbox,
  });

  factory ComponentsConfigModel.fromJson(Map<String, dynamic> json) {
    return ComponentsConfigModel(
      appBar:
          AppBarConfigModel.fromJson(json['appBar'] as Map<String, dynamic>),
      button:
          ButtonConfigModel.fromJson(json['button'] as Map<String, dynamic>),
      textButton: ButtonConfigModel.fromJson(
          json['textButton'] as Map<String, dynamic>),
      inputField: InputFieldConfigModel.fromJson(
          json['inputField'] as Map<String, dynamic>),
      card: CardConfigModel.fromJson(json['card'] as Map<String, dynamic>),
      dialog:
          DialogConfigModel.fromJson(json['dialog'] as Map<String, dynamic>),
      bottomNavigation: NavigationConfigModel.fromJson(
          json['bottomNavigation'] as Map<String, dynamic>),
      floatingActionButton: FABConfigModel.fromJson(
          json['floatingActionButton'] as Map<String, dynamic>),
      checkbox: CheckboxConfigModel.fromJson(
          json['checkbox'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appBar': (appBar as AppBarConfigModel).toJson(),
      'button': (button as ButtonConfigModel).toJson(),
      'textButton': (textButton as ButtonConfigModel).toJson(),
      'inputField': (inputField as InputFieldConfigModel).toJson(),
      'card': (card as CardConfigModel).toJson(),
      'dialog': (dialog as DialogConfigModel).toJson(),
      'bottomNavigation': (bottomNavigation as NavigationConfigModel).toJson(),
      'floatingActionButton':
          (floatingActionButton as FABConfigModel).toJson(),
      'checkbox': (checkbox as CheckboxConfigModel).toJson(),
    };
  }
}

class AppBarConfigModel extends AppBarConfig {
  const AppBarConfigModel({
    required super.elevation,
    required super.scrolledUnderElevation,
  });

  factory AppBarConfigModel.fromJson(Map<String, dynamic> json) {
    return AppBarConfigModel(
      elevation: (json['elevation'] as num).toDouble(),
      scrolledUnderElevation:
          (json['scrolledUnderElevation'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'elevation': elevation,
      'scrolledUnderElevation': scrolledUnderElevation,
    };
  }
}

class ButtonConfigModel extends ButtonConfig {
  const ButtonConfigModel({
    required super.borderRadius,
    required super.elevation,
    required super.padding,
  });

  factory ButtonConfigModel.fromJson(Map<String, dynamic> json) {
    return ButtonConfigModel(
      borderRadius: (json['borderRadius'] as num).toDouble(),
      elevation: (json['elevation'] as num).toDouble(),
      padding: EdgeInsetsConfigModel.fromJson(
          json['padding'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'borderRadius': borderRadius,
      'elevation': elevation,
      'padding': (padding as EdgeInsetsConfigModel).toJson(),
    };
  }
}

class InputFieldConfigModel extends InputFieldConfig {
  const InputFieldConfigModel({
    required super.borderRadius,
    required super.fillOpacity,
    required super.contentPadding,
    required super.focusedBorderWidth,
  });

  factory InputFieldConfigModel.fromJson(Map<String, dynamic> json) {
    return InputFieldConfigModel(
      borderRadius: (json['borderRadius'] as num).toDouble(),
      fillOpacity: (json['fillOpacity'] as num).toDouble(),
      contentPadding: EdgeInsetsConfigModel.fromJson(
          json['contentPadding'] as Map<String, dynamic>),
      focusedBorderWidth: (json['focusedBorderWidth'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'borderRadius': borderRadius,
      'fillOpacity': fillOpacity,
      'contentPadding': (contentPadding as EdgeInsetsConfigModel).toJson(),
      'focusedBorderWidth': focusedBorderWidth,
    };
  }
}

class CardConfigModel extends CardConfig {
  const CardConfigModel({
    required super.borderRadius,
    required super.elevation,
    required super.margin,
  });

  factory CardConfigModel.fromJson(Map<String, dynamic> json) {
    return CardConfigModel(
      borderRadius: (json['borderRadius'] as num).toDouble(),
      elevation: (json['elevation'] as num).toDouble(),
      margin: (json['margin'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'borderRadius': borderRadius,
      'elevation': elevation,
      'margin': margin,
    };
  }
}

class DialogConfigModel extends DialogConfig {
  const DialogConfigModel({
    required super.borderRadius,
    required super.elevation,
  });

  factory DialogConfigModel.fromJson(Map<String, dynamic> json) {
    return DialogConfigModel(
      borderRadius: (json['borderRadius'] as num).toDouble(),
      elevation: (json['elevation'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'borderRadius': borderRadius,
      'elevation': elevation,
    };
  }
}

class NavigationConfigModel extends NavigationConfig {
  const NavigationConfigModel({
    required super.elevation,
    required super.type,
  });

  factory NavigationConfigModel.fromJson(Map<String, dynamic> json) {
    return NavigationConfigModel(
      elevation: (json['elevation'] as num).toDouble(),
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'elevation': elevation,
      'type': type,
    };
  }
}

class FABConfigModel extends FABConfig {
  const FABConfigModel({
    required super.borderRadius,
    required super.elevation,
  });

  factory FABConfigModel.fromJson(Map<String, dynamic> json) {
    return FABConfigModel(
      borderRadius: (json['borderRadius'] as num).toDouble(),
      elevation: (json['elevation'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'borderRadius': borderRadius,
      'elevation': elevation,
    };
  }
}

class CheckboxConfigModel extends CheckboxConfig {
  const CheckboxConfigModel({
    required super.borderRadius,
    required super.borderWidth,
  });

  factory CheckboxConfigModel.fromJson(Map<String, dynamic> json) {
    return CheckboxConfigModel(
      borderRadius: (json['borderRadius'] as num).toDouble(),
      borderWidth: (json['borderWidth'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'borderRadius': borderRadius,
      'borderWidth': borderWidth,
    };
  }
}

class EdgeInsetsConfigModel extends EdgeInsetsConfig {
  const EdgeInsetsConfigModel({
    required super.horizontal,
    required super.vertical,
  });

  factory EdgeInsetsConfigModel.fromJson(Map<String, dynamic> json) {
    return EdgeInsetsConfigModel(
      horizontal: (json['horizontal'] as num).toDouble(),
      vertical: (json['vertical'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'horizontal': horizontal,
      'vertical': vertical,
    };
  }
}

class TypographyConfigModel extends TypographyConfig {
  const TypographyConfigModel({
    required super.displayLarge,
    required super.displayMedium,
    required super.displaySmall,
    required super.headlineLarge,
    required super.headlineMedium,
    required super.headlineSmall,
    required super.titleLarge,
    required super.titleMedium,
    required super.titleSmall,
    required super.bodyLarge,
    required super.bodyMedium,
    required super.bodySmall,
    required super.labelLarge,
    required super.labelMedium,
    required super.labelSmall,
  });

  factory TypographyConfigModel.fromJson(Map<String, dynamic> json) {
    return TypographyConfigModel(
      displayLarge: TextStyleConfigModel.fromJson(
          json['displayLarge'] as Map<String, dynamic>),
      displayMedium: TextStyleConfigModel.fromJson(
          json['displayMedium'] as Map<String, dynamic>),
      displaySmall: TextStyleConfigModel.fromJson(
          json['displaySmall'] as Map<String, dynamic>),
      headlineLarge: TextStyleConfigModel.fromJson(
          json['headlineLarge'] as Map<String, dynamic>),
      headlineMedium: TextStyleConfigModel.fromJson(
          json['headlineMedium'] as Map<String, dynamic>),
      headlineSmall: TextStyleConfigModel.fromJson(
          json['headlineSmall'] as Map<String, dynamic>),
      titleLarge: TextStyleConfigModel.fromJson(
          json['titleLarge'] as Map<String, dynamic>),
      titleMedium: TextStyleConfigModel.fromJson(
          json['titleMedium'] as Map<String, dynamic>),
      titleSmall: TextStyleConfigModel.fromJson(
          json['titleSmall'] as Map<String, dynamic>),
      bodyLarge: TextStyleConfigModel.fromJson(
          json['bodyLarge'] as Map<String, dynamic>),
      bodyMedium: TextStyleConfigModel.fromJson(
          json['bodyMedium'] as Map<String, dynamic>),
      bodySmall: TextStyleConfigModel.fromJson(
          json['bodySmall'] as Map<String, dynamic>),
      labelLarge: TextStyleConfigModel.fromJson(
          json['labelLarge'] as Map<String, dynamic>),
      labelMedium: TextStyleConfigModel.fromJson(
          json['labelMedium'] as Map<String, dynamic>),
      labelSmall: TextStyleConfigModel.fromJson(
          json['labelSmall'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayLarge': (displayLarge as TextStyleConfigModel).toJson(),
      'displayMedium': (displayMedium as TextStyleConfigModel).toJson(),
      'displaySmall': (displaySmall as TextStyleConfigModel).toJson(),
      'headlineLarge': (headlineLarge as TextStyleConfigModel).toJson(),
      'headlineMedium': (headlineMedium as TextStyleConfigModel).toJson(),
      'headlineSmall': (headlineSmall as TextStyleConfigModel).toJson(),
      'titleLarge': (titleLarge as TextStyleConfigModel).toJson(),
      'titleMedium': (titleMedium as TextStyleConfigModel).toJson(),
      'titleSmall': (titleSmall as TextStyleConfigModel).toJson(),
      'bodyLarge': (bodyLarge as TextStyleConfigModel).toJson(),
      'bodyMedium': (bodyMedium as TextStyleConfigModel).toJson(),
      'bodySmall': (bodySmall as TextStyleConfigModel).toJson(),
      'labelLarge': (labelLarge as TextStyleConfigModel).toJson(),
      'labelMedium': (labelMedium as TextStyleConfigModel).toJson(),
      'labelSmall': (labelSmall as TextStyleConfigModel).toJson(),
    };
  }
}

class TextStyleConfigModel extends TextStyleConfig {
  const TextStyleConfigModel({
    required super.fontSize,
    required super.fontWeight,
    required super.lineHeight,
    super.letterSpacing,
  });

  factory TextStyleConfigModel.fromJson(Map<String, dynamic> json) {
    return TextStyleConfigModel(
      fontSize: (json['fontSize'] as num).toDouble(),
      fontWeight: json['fontWeight'] as int,
      lineHeight: (json['lineHeight'] as num).toDouble(),
      letterSpacing: json['letterSpacing'] != null
          ? (json['letterSpacing'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fontSize': fontSize,
      'fontWeight': fontWeight,
      'lineHeight': lineHeight,
      if (letterSpacing != null) 'letterSpacing': letterSpacing,
    };
  }
}

// Helper functions
Color _colorFromHex(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex';
  }
  return Color(int.parse(hex, radix: 16));
}

String _colorToHex(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
}
