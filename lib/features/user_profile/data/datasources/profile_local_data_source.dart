import 'package:cointiply_app/features/auth/data/models/user_model.dart';


/// Abstract class for profile local data source
///
/// This defines the contract for caching and managing user profile data
/// locally using Hive or SharedPreferences. Used for offline support
/// and performance optimization.
abstract class ProfileLocalDataSource {
  /// Gets cached user profile
  Future<UserModel> getCachedUserProfile(String userId);

  /// Caches user profile locally
  Future<void> cacheUserProfile(UserModel profile);

  /// Removes cached user profile
  Future<void> removeCachedUserProfile(String userId);

  /// Clears all cached profile data
  Future<void> clearCache();

  /// Checks if profile data is cached
  Future<bool> isProfileCached(String userId);

  /// Gets cache timestamp for profile
  Future<DateTime?> getCacheTimestamp(String userId);
}
