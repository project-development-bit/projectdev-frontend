import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../models/theme_config_model.dart';
import '../../../services/database_service.dart';

/// Local database source for theme configuration using SQLite
/// Uses in-memory storage for web platform
abstract class ThemeDatabaseSource {
  /// Save theme configuration to database
  Future<void> saveThemeConfig(ThemeConfigModel config);

  /// Get cached theme configuration from database
  /// Returns null if no cached data found
  Future<ThemeConfigModel?> getThemeConfig();

  /// Get the version of currently stored theme
  /// Returns null if no theme is stored
  Future<String?> getStoredThemeVersion();

  /// Clear cached theme
  Future<void> clearTheme();
}

class ThemeDatabaseSourceImpl implements ThemeDatabaseSource {
  static const String _themeTable = 'app_theme';
  static const String _columnId = 'id';
  static const String _columnVersion = 'version';
  static const String _columnThemeData = 'theme_data';
  static const String _columnLastUpdated = 'last_updated';
  static const int _themeId = 1; // Single row for app theme

  // Web fallback storage
  static ThemeConfigModel? _webThemeCache;

  ThemeDatabaseSourceImpl();

  /// Initialize theme table in database
  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_themeTable (
        $_columnId INTEGER PRIMARY KEY,
        $_columnVersion TEXT NOT NULL,
        $_columnThemeData TEXT NOT NULL,
        $_columnLastUpdated TEXT NOT NULL
      )
    ''');
    debugPrint('✅ Theme table created');
  }

  @override
  Future<void> saveThemeConfig(ThemeConfigModel config) async {
    try {
      if (kIsWeb) {
        // Web: Use in-memory storage
        _webThemeCache = config;
        debugPrint('💾 Theme saved to web cache (version: ${config.version})');
        return;
      }

      // Mobile: Use SQLite
      final db = await DatabaseService.database;
      final themeJson = jsonEncode(config.toJson());
      final now = DateTime.now().toIso8601String();

      await db.insert(
        _themeTable,
        {
          _columnId: _themeId,
          _columnVersion: config.version,
          _columnThemeData: themeJson,
          _columnLastUpdated: now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      debugPrint('💾 Theme saved to database (version: ${config.version})');
    } catch (e) {
      debugPrint('❌ Error saving theme to database: $e');
      rethrow;
    }
  }

  @override
  Future<ThemeConfigModel?> getThemeConfig() async {
    try {
      if (kIsWeb) {
        // Web: Use in-memory storage
        if (_webThemeCache != null) {
          debugPrint('📖 Theme loaded from web cache (version: ${_webThemeCache!.version})');
        }
        return _webThemeCache;
      }

      // Mobile: Use SQLite
      final db = await DatabaseService.database;
      final results = await db.query(
        _themeTable,
        where: '$_columnId = ?',
        whereArgs: [_themeId],
      );

      if (results.isEmpty) {
        debugPrint('📖 No theme found in database');
        return null;
      }

      final row = results.first;
      final themeData = row[_columnThemeData] as String;
      final version = row[_columnVersion] as String;
      final lastUpdated = row[_columnLastUpdated] as String;

      final themeJson = jsonDecode(themeData) as Map<String, dynamic>;
      final config = ThemeConfigModel.fromJson(themeJson);

      debugPrint('📖 Theme loaded from database (version: $version, updated: $lastUpdated)');
      return config;
    } catch (e) {
      debugPrint('❌ Error loading theme from database: $e');
      return null;
    }
  }

  @override
  Future<String?> getStoredThemeVersion() async {
    try {
      if (kIsWeb) {
        // Web: Use in-memory storage
        return _webThemeCache?.version;
      }

      // Mobile: Use SQLite
      final db = await DatabaseService.database;
      final results = await db.query(
        _themeTable,
        columns: [_columnVersion],
        where: '$_columnId = ?',
        whereArgs: [_themeId],
      );

      if (results.isEmpty) {
        return null;
      }

      return results.first[_columnVersion] as String?;
    } catch (e) {
      debugPrint('❌ Error getting stored theme version: $e');
      return null;
    }
  }

  @override
  Future<void> clearTheme() async {
    try {
      if (kIsWeb) {
        // Web: Clear in-memory storage
        _webThemeCache = null;
        debugPrint('🗑️ Theme cleared from web cache');
        return;
      }

      // Mobile: Use SQLite
      final db = await DatabaseService.database;
      await db.delete(
        _themeTable,
        where: '$_columnId = ?',
        whereArgs: [_themeId],
      );

      debugPrint('🗑️ Theme cleared from database');
    } catch (e) {
      debugPrint('❌ Error clearing theme from database: $e');
      rethrow;
    }
  }
}
