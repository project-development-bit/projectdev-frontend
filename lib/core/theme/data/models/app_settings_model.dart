import 'package:flutter/material.dart';

/// Response model for app settings API
class AppSettingsResponse {
  final bool success;
  final String message;
  final List<AppSettingsData> data;

  AppSettingsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AppSettingsResponse.fromJson(Map<String, dynamic> json) {
    return AppSettingsResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((e) => AppSettingsData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

/// App settings data model
class AppSettingsData {
  final int id;
  final String configKey;
  final AppConfigData configData;
  final String version;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppSettingsData({
    required this.id,
    required this.configKey,
    required this.configData,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppSettingsData.fromJson(Map<String, dynamic> json) {
    return AppSettingsData(
      id: json['id'] as int,
      configKey: json['config_key'] as String,
      configData:
          AppConfigData.fromJson(json['config_data'] as Map<String, dynamic>),
      version: json['version'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'config_key': configKey,
      'config_data': configData.toJson(),
      'version': version,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// App configuration data model
class AppConfigData {
  final FontsConfig fonts;
  final TextsConfig texts;
  final ColorsConfig colors;
  final List<BannerConfig> banners;
  final TypographyConfig typography;
  final String colorScheme;
  final String configVersion;

  AppConfigData({
    required this.fonts,
    required this.texts,
    required this.colors,
    required this.banners,
    required this.typography,
    required this.colorScheme,
    required this.configVersion,
  });

  factory AppConfigData.fromJson(Map<String, dynamic> json) {
    return AppConfigData(
      fonts: FontsConfig.fromJson(json['fonts'] as Map<String, dynamic>),
      texts: TextsConfig.fromJson(json['texts'] as Map<String, dynamic>),
      colors: ColorsConfig.fromJson(json['colors'] as Map<String, dynamic>),
      banners: (json['banners'] as List)
          .map((e) => BannerConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
      typography:
          TypographyConfig.fromJson(json['typography'] as Map<String, dynamic>),
      colorScheme: json['colorScheme'] as String,
      configVersion: json['config_version'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fonts': fonts.toJson(),
      'texts': texts.toJson(),
      'colors': colors.toJson(),
      'banners': banners.map((e) => e.toJson()).toList(),
      'typography': typography.toJson(),
      'colorScheme': colorScheme,
      'config_version': configVersion,
    };
  }
}

/// Fonts configuration
class FontsConfig {
  final String body;
  final String heading;

  FontsConfig({
    required this.body,
    required this.heading,
  });

  factory FontsConfig.fromJson(Map<String, dynamic> json) {
    return FontsConfig(
      body: json['body'] as String,
      heading: json['heading'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'body': body,
      'heading': heading,
    };
  }
}

/// Texts configuration
class TextsConfig {
  final String ctaButton;
  final String homeTitle;

  TextsConfig({
    required this.ctaButton,
    required this.homeTitle,
  });

  factory TextsConfig.fromJson(Map<String, dynamic> json) {
    return TextsConfig(
      ctaButton: json['cta_button'] as String,
      homeTitle: json['home_title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cta_button': ctaButton,
      'home_title': homeTitle,
    };
  }
}

/// Colors configuration
class ColorsConfig {
  final ThemeColorsConfig dark;
  final ThemeColorsConfig light;

  ColorsConfig({
    required this.dark,
    required this.light,
  });

  factory ColorsConfig.fromJson(Map<String, dynamic> json) {
    return ColorsConfig(
      dark: ThemeColorsConfig.fromJson(json['dark'] as Map<String, dynamic>),
      light: ThemeColorsConfig.fromJson(json['light'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dark': dark.toJson(),
      'light': light.toJson(),
    };
  }
}

/// Theme colors configuration (for both light and dark)
class ThemeColorsConfig {
  final BoxColors box;
  final String body;
  final String border;
  final String button;
  final StatusColors status;
  final HeadingColors heading;
  final String primary;
  final ParagraphColors paragraph;
  final String secondary;

  ThemeColorsConfig({
    required this.box,
    required this.body,
    required this.border,
    required this.button,
    required this.status,
    required this.heading,
    required this.primary,
    required this.paragraph,
    required this.secondary,
  });

  factory ThemeColorsConfig.fromJson(Map<String, dynamic> json) {
    return ThemeColorsConfig(
      box: BoxColors.fromJson(json['box'] as Map<String, dynamic>),
      body: json['body'] as String,
      border: json['border'] as String,
      button: json['button'] as String,
      status: StatusColors.fromJson(json['status'] as Map<String, dynamic>),
      heading: HeadingColors.fromJson(json['heading'] as Map<String, dynamic>),
      primary: json['primary'] as String,
      paragraph:
          ParagraphColors.fromJson(json['paragraph'] as Map<String, dynamic>),
      secondary: json['secondary'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'box': box.toJson(),
      'body': body,
      'border': border,
      'button': button,
      'status': status.toJson(),
      'heading': heading.toJson(),
      'primary': primary,
      'paragraph': paragraph.toJson(),
      'secondary': secondary,
    };
  }

  // Helper methods to get Color objects
  Color get bodyColor => _parseColor(body);
  Color get borderColor => _parseColor(border);
  Color get buttonColor => _parseColor(button);
  Color get primaryColor => _parseColor(primary);
  Color get secondaryColor => _parseColor(secondary);
}

/// Box colors configuration
class BoxColors {
  final String first;
  final String second;

  BoxColors({
    required this.first,
    required this.second,
  });

  factory BoxColors.fromJson(Map<String, dynamic> json) {
    return BoxColors(
      first: json['first'] as String,
      second: json['second'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'second': second,
    };
  }

  // Helper methods to get Color objects
  Color get firstColor => _parseColor(first);
  Color get secondColor => _parseColor(second);
}

/// Status colors configuration
class StatusColors {
  final String info;
  final String success;
  final String warning;
  final String destructive;
  final String seriousWarning;

  StatusColors({
    required this.info,
    required this.success,
    required this.warning,
    required this.destructive,
    required this.seriousWarning,
  });

  factory StatusColors.fromJson(Map<String, dynamic> json) {
    return StatusColors(
      info: json['info'] as String,
      success: json['success'] as String,
      warning: json['warning'] as String,
      destructive: json['destructive'] as String,
      seriousWarning: json['seriousWarning'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'info': info,
      'success': success,
      'warning': warning,
      'destructive': destructive,
      'seriousWarning': seriousWarning,
    };
  }

  // Helper methods to get Color objects
  Color get infoColor => _parseColor(info);
  Color get successColor => _parseColor(success);
  Color get warningColor => _parseColor(warning);
  Color get destructiveColor => _parseColor(destructive);
  Color get seriousWarningColor => _parseColor(seriousWarning);
}

/// Heading colors configuration
class HeadingColors {
  final String first;
  final String third;
  final String second;

  HeadingColors({
    required this.first,
    required this.third,
    required this.second,
  });

  factory HeadingColors.fromJson(Map<String, dynamic> json) {
    return HeadingColors(
      first: json['first'] as String,
      third: json['third'] as String,
      second: json['second'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'third': third,
      'second': second,
    };
  }

  // Helper methods to get Color objects
  Color get firstColor => _parseColor(first);
  Color get secondColor => _parseColor(second);
  Color get thirdColor => _parseColor(third);
}

/// Paragraph colors configuration
class ParagraphColors {
  final String first;
  final String third;
  final String second;

  ParagraphColors({
    required this.first,
    required this.third,
    required this.second,
  });

  factory ParagraphColors.fromJson(Map<String, dynamic> json) {
    return ParagraphColors(
      first: json['first'] as String,
      third: json['third'] as String,
      second: json['second'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'third': third,
      'second': second,
    };
  }

  // Helper methods to get Color objects
  Color get firstColor => _parseColor(first);
  Color get secondColor => _parseColor(second);
  Color get thirdColor => _parseColor(third);
}

/// Banner configuration
class BannerConfig {
  final String label;
  final String title;
  final String description;
  final String link;
  final String imageWeb;
  final String imageMobile;
  final String btnText;

  BannerConfig({
    required this.label,
    required this.title,
    required this.description,
    required this.link,
    required this.imageWeb,
    required this.imageMobile,
    required this.btnText,
  });

  factory BannerConfig.fromJson(Map<String, dynamic> json) {
    return BannerConfig(
      label: (json['label'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      link: (json['link'] as String?) ?? '',
      imageWeb: (json['image_web'] as String?) ?? '',
      imageMobile: (json['image_mobile'] as String?) ?? '',
      btnText: (json['btnText'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'title': title,
      'description': description,
      'link': link,
      'image_web': imageWeb,
      'image_mobile': imageMobile,
      'btnText': btnText,
    };
  }
}

/// Typography configuration
class TypographyConfig {
  final TypographyStyle h1;
  final TypographyStyle h2;
  final TypographyStyle h3;
  final TypographyStyle body;

  TypographyConfig({
    required this.h1,
    required this.h2,
    required this.h3,
    required this.body,
  });

  factory TypographyConfig.fromJson(Map<String, dynamic> json) {
    return TypographyConfig(
      h1: TypographyStyle.fromJson(json['h1'] as Map<String, dynamic>),
      h2: TypographyStyle.fromJson(json['h2'] as Map<String, dynamic>),
      h3: TypographyStyle.fromJson(json['h3'] as Map<String, dynamic>),
      body: TypographyStyle.fromJson(json['body'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'h1': h1.toJson(),
      'h2': h2.toJson(),
      'h3': h3.toJson(),
      'body': body.toJson(),
    };
  }
}

/// Typography style configuration
class TypographyStyle {
  final String usage;
  final String fontSize;
  final dynamic fontWeight; // Can be int or String like "500-700"

  TypographyStyle({
    required this.usage,
    required this.fontSize,
    required this.fontWeight,
  });

  factory TypographyStyle.fromJson(Map<String, dynamic> json) {
    return TypographyStyle(
      usage: json['usage'] as String,
      fontSize: json['fontSize'] as String,
      fontWeight: json['fontWeight'], // Can be int or String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usage': usage,
      'fontSize': fontSize,
      'fontWeight': fontWeight,
    };
  }

  // Helper to parse fontSize to double (removes 'px')
  double get fontSizeValue {
    return double.tryParse(fontSize.replaceAll('px', '')) ?? 16.0;
  }

  // Helper to get FontWeight
  FontWeight get fontWeightValue {
    if (fontWeight is int) {
      return FontWeight.values.firstWhere(
        (w) => w.value == fontWeight,
        orElse: () => FontWeight.normal,
      );
    } else if (fontWeight is String) {
      // Handle cases like "500-700", use the first value
      final weightStr = (fontWeight as String).split('-').first;
      final weightInt = int.tryParse(weightStr) ?? 400;
      return FontWeight.values.firstWhere(
        (w) => w.value == weightInt,
        orElse: () => FontWeight.normal,
      );
    }
    return FontWeight.normal;
  }
}

/// Helper function to parse color strings
Color _parseColor(String colorString) {
  try {
    // Handle rgba() format
    if (colorString.startsWith('rgba(')) {
      final values = colorString
          .replaceAll('rgba(', '')
          .replaceAll(')', '')
          .split(',')
          .map((e) => e.trim())
          .toList();

      if (values.length >= 4) {
        final r = int.parse(values[0]);
        final g = int.parse(values[1]);
        final b = int.parse(values[2]);
        final a = double.parse(values[3]);
        return Color.fromRGBO(r, g, b, a);
      }
    }

    // Handle hex format
    if (colorString.startsWith('#')) {
      final hexColor = colorString.replaceAll('#', '');
      if (hexColor.length == 6) {
        return Color(int.parse('FF$hexColor', radix: 16));
      } else if (hexColor.length == 8) {
        return Color(int.parse(hexColor, radix: 16));
      }
    }

    // Default fallback
    return Colors.grey;
  } catch (e) {
    debugPrint('Error parsing color: $colorString - $e');
    return Colors.grey;
  }
}
