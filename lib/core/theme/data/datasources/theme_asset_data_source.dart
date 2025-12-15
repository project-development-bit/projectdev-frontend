import 'dart:convert';
import 'package:cointiply_app/core/config/app_assets.dart';
import 'package:flutter/services.dart';
import '../models/theme_config_model.dart';

/// Data source for loading theme from asset files
abstract class ThemeAssetDataSource {
  /// Load default theme from JSON asset file
  Future<ThemeConfigModel> loadDefaultTheme();
}

class ThemeAssetDataSourceImpl implements ThemeAssetDataSource {
  static const String _defaultThemePath = AppAssets.defaultTheme;

  @override
  Future<ThemeConfigModel> loadDefaultTheme() async {
    try {
      // Load JSON file from assets
      final jsonString = await rootBundle.loadString(_defaultThemePath);

      // Parse JSON
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;

      // Convert to model
      return ThemeConfigModel.fromJson(jsonData);
    } catch (e) {
      throw Exception('Failed to load default theme from assets: $e');
    }
  }
}
