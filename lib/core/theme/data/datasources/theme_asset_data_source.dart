import 'dart:convert';
import 'package:gigafaucet/core/config/app_assets.dart';
import 'package:gigafaucet/core/theme/data/models/app_settings_model.dart';
import 'package:flutter/services.dart';

/// Data source for loading theme from asset files
abstract class ThemeAssetDataSource {
  /// Load default theme from JSON asset file
  Future<AppSettingsData> loadDefaultTheme();
}

class ThemeAssetDataSourceImpl implements ThemeAssetDataSource {
  static const String _defaultThemePath = AppAssets.defaultTheme;

  @override
  Future<AppSettingsData> loadDefaultTheme() async {
    try {
      // Load JSON file from assets
      final jsonString = await rootBundle.loadString(_defaultThemePath);

      // Parse JSON
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;

      // Convert to model
      return AppSettingsData.fromJson(jsonData);
    } catch (e) {
      throw Exception('Failed to load default theme from assets: $e');
    }
  }
}
