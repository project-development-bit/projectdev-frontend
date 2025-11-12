import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings_model.dart';

abstract class AppSettingsLocalDataSource {
  /// Get cached app settings
  Future<AppSettingsResponse?> getCachedAppSettings();
  
  /// Cache app settings
  Future<void> cacheAppSettings(AppSettingsResponse settings);
  
  /// Clear cached app settings
  Future<void> clearCachedAppSettings();
}

class AppSettingsLocalDataSourceImpl implements AppSettingsLocalDataSource {
  static const String _cacheKey = 'cached_app_settings';
  
  final SharedPreferences sharedPreferences;

  AppSettingsLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<AppSettingsResponse?> getCachedAppSettings() async {
    try {
      final cachedJson = sharedPreferences.getString(_cacheKey);
      
      if (cachedJson == null) {
        return null;
      }
      
      final jsonMap = json.decode(cachedJson) as Map<String, dynamic>;
      return AppSettingsResponse.fromJson(jsonMap);
    } catch (e) {
      // If there's any error reading cache, return null
      return null;
    }
  }

  @override
  Future<void> cacheAppSettings(AppSettingsResponse settings) async {
    try {
      final jsonString = json.encode(settings.toJson());
      await sharedPreferences.setString(_cacheKey, jsonString);
    } catch (e) {
      // Silently fail cache write - app can still work without cache
      throw Exception('Failed to cache app settings: $e');
    }
  }

  @override
  Future<void> clearCachedAppSettings() async {
    await sharedPreferences.remove(_cacheKey);
  }
}
