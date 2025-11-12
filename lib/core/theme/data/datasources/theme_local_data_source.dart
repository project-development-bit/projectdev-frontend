import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/theme_config_model.dart';

abstract class ThemeLocalDataSource {
  /// Cache theme configuration
  Future<void> cacheThemeConfig(ThemeConfigModel config);

  /// Get cached theme configuration
  /// Throws [CacheException] if no cached data found
  Future<ThemeConfigModel> getCachedThemeConfig();

  /// Clear cached theme
  Future<void> clearCache();
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedThemeKey = 'CACHED_THEME_CONFIG';

  ThemeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheThemeConfig(ThemeConfigModel config) async {
    final jsonString = jsonEncode(config.toJson());
    await sharedPreferences.setString(cachedThemeKey, jsonString);
  }

  @override
  Future<ThemeConfigModel> getCachedThemeConfig() async {
    final jsonString = sharedPreferences.getString(cachedThemeKey);
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return ThemeConfigModel.fromJson(jsonMap);
    } else {
      throw CacheException('No cached theme found');
    }
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(cachedThemeKey);
  }
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}
