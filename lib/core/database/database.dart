import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Include the generated code
part 'database.g.dart';

// Define the Favorites table
class Favorites extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get description => text().nullable()();
  TextColumn get category => text().withLength(min: 1, max: 100)();
  RealColumn get rating => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// The main database class
@DriftDatabase(tables: [Favorites])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        // Enable foreign keys
        await customStatement('PRAGMA foreign_keys = ON');
      },
      onCreate: (Migrator m) async {
        await m.createAll();
        
        // Create indexes for better performance
        await customStatement(
          'CREATE INDEX idx_favorites_category ON favorites (category)'
        );
        await customStatement(
          'CREATE INDEX idx_favorites_rating ON favorites (rating)'
        );
        await customStatement(
          'CREATE INDEX idx_favorites_created_at ON favorites (created_at)'
        );
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future migrations here
      },
    );
  }

  // CRUD Operations for Favorites

  /// Get all favorites
  Future<List<Favorite>> getAllFavorites() => select(favorites).get();

  /// Get favorites as a stream (reactive)
  Stream<List<Favorite>> watchAllFavorites() => select(favorites).watch();

  /// Get favorite by ID
  Future<Favorite?> getFavoriteById(int id) => 
    (select(favorites)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  /// Watch favorite by ID
  Stream<Favorite?> watchFavoriteById(int id) =>
    (select(favorites)..where((tbl) => tbl.id.equals(id))).watchSingleOrNull();

  /// Add a new favorite
  Future<int> addFavorite(FavoritesCompanion entry) => 
    into(favorites).insert(entry);

  /// Update a favorite
  Future<bool> updateFavorite(Favorite favorite) => 
    update(favorites).replace(favorite);

  /// Delete a favorite by ID
  Future<int> deleteFavorite(int id) => 
    (delete(favorites)..where((tbl) => tbl.id.equals(id))).go();

  /// Delete all favorites
  Future<int> deleteAllFavorites() => delete(favorites).go();

  /// Search favorites by title or description
  Future<List<Favorite>> searchFavorites(String query) {
    final searchQuery = '%$query%';
    return (select(favorites)
      ..where((tbl) => 
        tbl.title.like(searchQuery) | 
        tbl.description.like(searchQuery)
      )).get();
  }

  /// Get favorites by category
  Future<List<Favorite>> getFavoritesByCategory(String category) => 
    (select(favorites)..where((tbl) => tbl.category.equals(category))).get();

  /// Watch favorites by category
  Stream<List<Favorite>> watchFavoritesByCategory(String category) =>
    (select(favorites)..where((tbl) => tbl.category.equals(category))).watch();

  /// Get favorites with minimum rating
  Future<List<Favorite>> getFavoritesWithMinRating(double minRating) =>
    (select(favorites)..where((tbl) => tbl.rating.isBiggerOrEqualValue(minRating))).get();

  /// Get count of favorites
  Future<int> getFavoritesCount() async {
    final result = await customSelect(
      'SELECT COUNT(*) as count FROM favorites'
    ).getSingle();
    return result.data['count'] as int;
  }

  /// Get count by category
  Future<int> getFavoritesCountByCategory(String category) async {
    final result = await customSelect(
      'SELECT COUNT(*) as count FROM favorites WHERE category = ?',
      variables: [Variable.withString(category)]
    ).getSingle();
    return result.data['count'] as int;
  }

  /// Update the updatedAt timestamp for a favorite
  Future<void> touchFavorite(int id) async {
    await (update(favorites)..where((tbl) => tbl.id.equals(id)))
      .write(FavoritesCompanion(updatedAt: Value(DateTime.now())));
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}