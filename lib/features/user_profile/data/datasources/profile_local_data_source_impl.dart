import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile_model.dart';
import 'profile_local_data_source.dart';

/// Implementation of [ProfileLocalDataSource] using SharedPreferences for local storage
/// 
/// This class handles caching user profile data locally for offline support
/// and improved performance. Uses SharedPreferences for simple key-value storage.
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  static const String _profileKeyPrefix = 'profile_';
  static const String _timestampKeyPrefix = 'profile_timestamp_';

  @override
  Future<UserProfileModel?> getCachedUserProfile(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString('$_profileKeyPrefix$userId');
      
      if (profileJson != null) {
        final Map<String, dynamic> profileData = json.decode(profileJson);
        return UserProfileModel.fromJson(profileData);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get cached user profile: $e');
    }
  }

  @override
  Future<void> cacheUserProfile(UserProfileModel profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = json.encode(profile.toJson());
      
      await prefs.setString('$_profileKeyPrefix${profile.id}', profileJson);
      await prefs.setInt(
        '$_timestampKeyPrefix${profile.id}',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw Exception('Failed to cache user profile: $e');
    }
  }

  @override
  Future<void> removeCachedUserProfile(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_profileKeyPrefix$userId');
      await prefs.remove('$_timestampKeyPrefix$userId');
    } catch (e) {
      throw Exception('Failed to remove cached user profile: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => 
          key.startsWith(_profileKeyPrefix) || 
          key.startsWith(_timestampKeyPrefix)
      ).toList();
      
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      throw Exception('Failed to clear profile cache: $e');
    }
  }

  @override
  Future<bool> isProfileCached(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey('$_profileKeyPrefix$userId');
    } catch (e) {
      throw Exception('Failed to check if profile is cached: $e');
    }
  }

  @override
  Future<DateTime?> getCacheTimestamp(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt('$_timestampKeyPrefix$userId');
      
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get cache timestamp: $e');
    }
  }
}