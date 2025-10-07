import 'package:cointiply_app/core/database/database.dart';
import 'package:drift/drift.dart';

/// High-level database service that provides a clean API for database operations.
/// This replaces the previous SQLite-based DatabaseService with Drift operations.
class DatabaseService {
  static AppDatabase? _database;

  /// Initialize the database
  static Future<void> init() async {
    _database = AppDatabase();
  }

  /// Get the database instance
  static AppDatabase get instance {
    if (_database == null) {
      throw Exception('DatabaseService not initialized. Call init() first.');
    }
    return _database!;
  }

  /// Close the database
  static Future<void> close() async {
    await _database?.close();
    _database = null;
  }

  // Favorite operations

  /// Add a new favorite
  static Future<int> addFavorite({
    required String title,
    required String description,
    required String category,
    double rating = 0.0,
  }) async {
    final companion = FavoritesCompanion(
      title: Value(title),
      description: Value(description),
      category: Value(category),
      rating: Value(rating),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );

    return await instance.addFavorite(companion);
  }

  /// Get all favorites
  static Future<List<Favorite>> getAllFavorites() async {
    return await instance.getAllFavorites();
  }

  /// Watch all favorites (reactive stream)
  static Stream<List<Favorite>> watchAllFavorites() {
    return instance.watchAllFavorites();
  }

  /// Get a favorite by ID
  static Future<Favorite?> getFavoriteById(int id) async {
    return await instance.getFavoriteById(id);
  }

  /// Watch a favorite by ID (reactive stream)
  static Stream<Favorite?> watchFavoriteById(int id) {
    return instance.watchFavoriteById(id);
  }

  /// Update a favorite
  static Future<bool> updateFavorite(Favorite favorite) async {
    final updatedFavorite = favorite.copyWith(updatedAt: DateTime.now());
    return await instance.updateFavorite(updatedFavorite);
  }

  /// Delete a favorite by ID
  static Future<int> deleteFavorite(int id) async {
    return await instance.deleteFavorite(id);
  }

  /// Delete all favorites
  static Future<int> deleteAllFavorites() async {
    return await instance.deleteAllFavorites();
  }

  /// Search favorites by title or description
  static Future<List<Favorite>> searchFavorites(String query) async {
    return await instance.searchFavorites(query);
  }

  /// Get favorites by category
  static Future<List<Favorite>> getFavoritesByCategory(String category) async {
    return await instance.getFavoritesByCategory(category);
  }

  /// Watch favorites by category (reactive stream)
  static Stream<List<Favorite>> watchFavoritesByCategory(String category) {
    return instance.watchFavoritesByCategory(category);
  }

  /// Get favorites with minimum rating
  static Future<List<Favorite>> getFavoritesWithMinRating(
      double minRating) async {
    return await instance.getFavoritesWithMinRating(minRating);
  }

  /// Get total count of favorites
  static Future<int> getFavoritesCount() async {
    return await instance.getFavoritesCount();
  }

  /// Get count of favorites by category
  static Future<int> getFavoritesCountByCategory(String category) async {
    return await instance.getFavoritesCountByCategory(category);
  }

  /// Touch a favorite (update its updatedAt timestamp)
  static Future<void> touchFavorite(int id) async {
    await instance.touchFavorite(id);
  }

  // Helper methods to maintain compatibility with previous API

  /// Check if a favorite exists
  static Future<bool> favoriteExists(int id) async {
    final favorite = await getFavoriteById(id);
    return favorite != null;
  }

  /// Get all categories
  static Future<List<String>> getAllCategories() async {
    final favorites = await getAllFavorites();
    final categories = favorites.map((f) => f.category).toSet().toList();
    categories.sort();
    return categories;
  }

  /// Get favorites sorted by rating (descending)
  static Future<List<Favorite>> getFavoritesByRating() async {
    final favorites = await getAllFavorites();
    favorites.sort((a, b) => b.rating.compareTo(a.rating));
    return favorites;
  }

  /// Get recent favorites (sorted by creation date)
  static Future<List<Favorite>> getRecentFavorites({int limit = 10}) async {
    final favorites = await getAllFavorites();
    favorites.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return favorites.take(limit).toList();
  }
}
