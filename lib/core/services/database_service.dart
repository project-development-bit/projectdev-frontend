import 'dart:io';
import 'package:cointiply_app/features/user_profile/data/enum/user_level.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import '../error/failures.dart';
import '../enum/user_role.dart';
import 'secure_storage_service.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/data/models/user_model.dart';

// Flag to disable database operations in test environment
bool _isTestEnvironment = false;

/// Set whether we're in a test environment
void setTestEnvironment(bool isTest) {
  _isTestEnvironment = isTest;
}

/// Database service for managing local SQLite database operations
class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'burger_eats.db';
  static const int _databaseVersion = 1;
  static bool _isInitialized = false;
  static final Map<int, UserModel> _webUsers = {}; // In-memory storage for web

  // Table names
  static const String _usersTable = 'users';

  // User table columns
  static const String _columnId = 'id';
  static const String _columnName = 'name';
  static const String _columnEmail = 'email';
  static const String _columnRole = 'role';
  static const String _columnCreatedAt = 'created_at';
  static const String _columnUpdatedAt = 'updated_at';

  /// Initialize the database service - call this during app startup
  static Future<void> init() async {
    if (_isInitialized) return;

    try {
      debugPrint('📊 Initializing Database Service...');

      if (kIsWeb) {
        // For web platform, use in-memory storage
        debugPrint('🌐 Web platform detected - using in-memory storage');
        _isInitialized = true;
      } else {
        // For mobile platforms, use SQLite
        _database = await _initDatabase();
        _isInitialized = true;
      }

      // Insert sample users if database is empty (for testing)
      await insertSampleUsers();

      // Set up test authentication for development
      await setupTestAuth();

      debugPrint('✅ Database Service initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize Database Service: $e');
      rethrow;
    }
  }

  /// Get database instance (singleton pattern)
  static Future<Database> get database async {
    if (kIsWeb) {
      throw DatabaseFailure(
          message: 'SQLite database not available on web platform');
    }

    if (_database != null) return _database!;

    if (!_isInitialized) {
      await init();
    }

    return _database!;
  }

  /// Initialize the database
  static Future<Database> _initDatabase() async {
    if (kIsWeb) {
      throw DatabaseFailure(
          message: 'SQLite database initialization called on web platform');
    }

    try {
      final documentsDirectory = await getDatabasesPath();
      final path = join(documentsDirectory, _databaseName);

      debugPrint('📊 Initializing database at: $path');

      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _createTables,
        onUpgrade: _onUpgrade,
        onOpen: (db) {
          debugPrint('📊 Database opened successfully');
        },
      );
    } catch (e) {
      debugPrint('❌ Error initializing database: $e');
      throw DatabaseFailure(message: 'Failed to initialize database: $e');
    }
  }

  /// Create database tables
  static Future<void> _createTables(Database db, int version) async {
    try {
      debugPrint('📊 Creating database tables...');

      // Create users table
      await db.execute('''
        CREATE TABLE $_usersTable (
          $_columnId INTEGER PRIMARY KEY,
          $_columnName TEXT NOT NULL,
          $_columnEmail TEXT NOT NULL UNIQUE,
          $_columnRole TEXT NOT NULL,
          $_columnCreatedAt TEXT NOT NULL,
          $_columnUpdatedAt TEXT NOT NULL
        )
      ''');

      debugPrint('✅ Database tables created successfully');
    } catch (e) {
      debugPrint('❌ Error creating database tables: $e');
      throw DatabaseFailure(message: 'Failed to create database tables: $e');
    }
  }

  /// Handle database upgrades
  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    debugPrint('📊 Upgrading database from version $oldVersion to $newVersion');

    // Handle database migrations here in future versions
    // For now, we'll just recreate the tables
    if (oldVersion < newVersion) {
      // Drop existing tables
      await db.execute('DROP TABLE IF EXISTS $_usersTable');

      // Recreate tables with new schema
      await _createTables(db, newVersion);
    }
  }

  /// Insert or update user data
  static Future<void> saveUser(User user) async {
    // Skip database operations in test environment
    if (_isTestEnvironment) {
      debugPrint(
          '🧪 Test mode: Skipping database save for user: ${user.email}');
      return;
    }

    try {
      if (kIsWeb) {
        // For web, store in memory
        final userModel = user is UserModel ? user : UserModel.fromEntity(user);
        _webUsers[user.id] = userModel;
        debugPrint('🌐 User saved to web storage: ${user.email}');
        return;
      }

      final db = await database;
      final userData = {
        _columnId: user.id,
        _columnName: user.name,
        _columnEmail: user.email,
        _columnRole: user.role.name,
        _columnCreatedAt: DateTime.now().toIso8601String(),
        _columnUpdatedAt: DateTime.now().toIso8601String(),
      };

      debugPrint('📊 Saving user to database: ${user.email}');

      await db.insert(
        _usersTable,
        userData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      debugPrint('✅ User saved successfully: ${user.email}');
    } catch (e) {
      debugPrint('❌ Error saving user: $e');
      throw DatabaseFailure(message: 'Failed to save user: $e');
    }
  }

  /// Get user by ID
  static Future<UserModel?> getUserById(int userId) async {
    try {
      if (kIsWeb) {
        // For web, get from memory
        final user = _webUsers[userId];
        if (user != null) {
          debugPrint('🌐 User found in web storage: ${user.email}');
        } else {
          debugPrint('🔍 No user found with ID: $userId in web storage');
        }
        return user;
      }

      final db = await database;

      debugPrint('📊 Getting user by ID: $userId');

      final List<Map<String, dynamic>> results = await db.query(
        _usersTable,
        where: '$_columnId = ?',
        whereArgs: [userId],
        limit: 1,
      );

      if (results.isNotEmpty) {
        final userData = results.first;
        final user = UserModel.fromDatabaseJson(userData);
        debugPrint('✅ User found: ${user.email}');
        return user;
      }

      debugPrint('🔍 No user found with ID: $userId');
      return null;
    } catch (e) {
      debugPrint('❌ Error getting user by ID: $e');
      throw DatabaseFailure(message: 'Failed to get user: $e');
    }
  }

  /// Get user by email
  static Future<UserModel?> getUserByEmail(String email) async {
    try {
      final db = await database;

      debugPrint('📊 Getting user by email: $email');

      final List<Map<String, dynamic>> results = await db.query(
        _usersTable,
        where: '$_columnEmail = ?',
        whereArgs: [email],
        limit: 1,
      );

      if (results.isNotEmpty) {
        final userData = results.first;
        final user = UserModel.fromDatabaseJson(userData);
        debugPrint('✅ User found: ${user.email}');
        return user;
      }

      debugPrint('🔍 No user found with email: $email');
      return null;
    } catch (e) {
      debugPrint('❌ Error getting user by email: $e');
      throw DatabaseFailure(message: 'Failed to get user: $e');
    }
  }

  /// Get all users
  static Future<List<UserModel>> getAllUsers() async {
    try {
      final db = await database;

      debugPrint('📊 Getting all users');

      final List<Map<String, dynamic>> results = await db.query(
        _usersTable,
        orderBy: '$_columnCreatedAt DESC',
      );

      final users = results
          .map((userData) => UserModel.fromDatabaseJson(userData))
          .toList();

      debugPrint('✅ Found ${users.length} users');
      return users;
    } catch (e) {
      debugPrint('❌ Error getting all users: $e');
      throw DatabaseFailure(message: 'Failed to get users: $e');
    }
  }

  /// Update user data
  static Future<void> updateUser(User user) async {
    try {
      final db = await database;

      debugPrint('📊 Updating user: ${user.email}');

      final userData = {
        _columnName: user.name,
        _columnEmail: user.email,
        _columnRole: user.role.name,
        _columnUpdatedAt: DateTime.now().toIso8601String(),
      };

      final rowsAffected = await db.update(
        _usersTable,
        userData,
        where: '$_columnId = ?',
        whereArgs: [user.id],
      );

      if (rowsAffected > 0) {
        debugPrint('✅ User updated successfully: ${user.email}');
      } else {
        debugPrint('⚠️ No user found to update with ID: ${user.id}');
        throw DatabaseFailure(message: 'No user found to update');
      }
    } catch (e) {
      debugPrint('❌ Error updating user: $e');
      throw DatabaseFailure(message: 'Failed to update user: $e');
    }
  }

  /// Delete user by ID
  static Future<void> deleteUser(int userId) async {
    try {
      final db = await database;

      debugPrint('📊 Deleting user with ID: $userId');

      final rowsAffected = await db.delete(
        _usersTable,
        where: '$_columnId = ?',
        whereArgs: [userId],
      );

      if (rowsAffected > 0) {
        debugPrint('✅ User deleted successfully: $userId');
      } else {
        debugPrint('⚠️ No user found to delete with ID: $userId');
      }
    } catch (e) {
      debugPrint('❌ Error deleting user: $e');
      throw DatabaseFailure(message: 'Failed to delete user: $e');
    }
  }

  /// Clear all user data
  static Future<void> clearAllUsers() async {
    try {
      if (kIsWeb) {
        // For web, clear in-memory storage
        _webUsers.clear();
        debugPrint('🌐 Web user storage cleared successfully');
        return;
      }

      final db = await database;

      debugPrint('📊 Clearing all users');

      await db.delete(_usersTable);

      debugPrint('✅ All users cleared successfully');
    } catch (e) {
      debugPrint('❌ Error clearing users: $e');
      throw DatabaseFailure(message: 'Failed to clear users: $e');
    }
  }

  /// Check if database has any users
  static Future<bool> hasUsers() async {
    try {
      if (kIsWeb) {
        return _webUsers.isNotEmpty;
      }

      final db = await database;

      final List<Map<String, dynamic>> results = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $_usersTable',
      );

      final count = Sqflite.firstIntValue(results) ?? 0;
      return count > 0;
    } catch (e) {
      debugPrint('❌ Error checking if database has users: $e');
      return false;
    }
  }

  /// Insert sample users for testing (only if database is empty)
  static Future<void> insertSampleUsers() async {
    try {
      if (await hasUsers()) {
        debugPrint(
            '📊 Database already has users, skipping sample data insertion');
        return;
      }

      debugPrint('📊 Inserting sample users for testing...');

      final sampleUsers = [
        UserModel(
          id: 1,
          name: 'John Doe',
          email: 'john.doe@example.com',
          role: UserRole.normalUser,
          refreshToken: '',
          securityCode: '0000',
          twofaEnabled: 0,
          twofaSecret: '',
          securityPinEnabled: 0,
          isBanned: 0,
          isVerified: 1,
          avatarUrl: '',
          interestEnable: 0,
          riskScore: 0,
          showOnboarding: 0,
          notificationsEnabled: 1,
          showStatsEnabled: 1,
          anonymousInContests: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          currentStatus: UserLevel.bronze,
          countryID: 1,
          countryName: 'Thailand',
          coinBalance: 50.0,
          language: 'en',
        ),
        UserModel(
          id: 2,
          name: 'Jane Smith',
          email: 'jane.smith@example.com',
          role: UserRole.normalUser,
          refreshToken: '',
          securityCode: '0000',
          twofaEnabled: 0,
          twofaSecret: '',
          securityPinEnabled: 0,
          isBanned: 0,
          isVerified: 1,
          avatarUrl: '',
          interestEnable: 0,
          riskScore: 0,
          showOnboarding: 0,
          notificationsEnabled: 1,
          showStatsEnabled: 1,
          anonymousInContests: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          currentStatus: UserLevel.bronze,
          countryID: 1,
          countryName: 'Thailand',
          coinBalance: 50.0,
          language: 'en',
        ),
        UserModel(
          id: 3,
          name: 'Admin User',
          email: 'admin@burgerears.com',
          role: UserRole.admin,
          refreshToken: '',
          securityCode: '0000',
          twofaEnabled: 0,
          twofaSecret: '',
          securityPinEnabled: 0,
          isBanned: 0,
          isVerified: 1,
          avatarUrl: '',
          interestEnable: 0,
          riskScore: 0,
          showOnboarding: 0,
          notificationsEnabled: 1,
          showStatsEnabled: 1,
          anonymousInContests: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          currentStatus: UserLevel.bronze,
          countryID: 1,
          countryName: 'Thailand',
          coinBalance: 50.0,
          language: 'en',
        ),
      ];

      for (final user in sampleUsers) {
        await saveUser(user);
      }

      debugPrint('✅ Sample users inserted successfully');
    } catch (e) {
      debugPrint('❌ Error inserting sample users: $e');
    }
  }

  /// Set up test authentication for development (only if needed for testing)
  static Future<void> setupTestAuth() async {
    try {
      final secureStorage = SecureStorageService();
      final currentUserId = await secureStorage.getUserId();
      final currentToken = await secureStorage.getAuthToken();

      // Only set up test auth if explicitly needed for development and no auth exists
      // This prevents automatic login after logout
      if (currentUserId == null && currentToken == null) {
        // For now, don't automatically set up test auth
        // This should be manually triggered only when needed for testing
        debugPrint(
            '🧪 No existing authentication found - not setting up test auth automatically');
        debugPrint(
            '🧪 Use manual login or call setupTestAuthForced() if testing is needed');
      } else {
        debugPrint(
            '🧪 Existing authentication found - user ID: $currentUserId');
      }
    } catch (e) {
      debugPrint('❌ Error checking auth state: $e');
    }
  }

  /// Force set up test authentication (for manual testing only)
  static Future<void> setupTestAuthForced() async {
    try {
      final secureStorage = SecureStorageService();
      // Set user ID to 1 (John Doe) for testing
      await secureStorage.saveUserId('1');
      // Set a test auth token for development
      await secureStorage.saveAuthToken('dev_test_token_123');
      debugPrint('🧪 Test authentication forcefully set up with user ID: 1');
    } catch (e) {
      debugPrint('❌ Error setting up forced test auth: $e');
    }
  }

  /// Close database connection
  static Future<void> closeDatabase() async {
    try {
      if (_database != null) {
        await _database!.close();
        _database = null;
        debugPrint('📊 Database connection closed');
      }
    } catch (e) {
      debugPrint('❌ Error closing database: $e');
    }
  }

  /// Delete database file (for testing purposes)
  static Future<void> deleteDatabase() async {
    try {
      final documentsDirectory = await getDatabasesPath();
      final path = join(documentsDirectory, _databaseName);

      if (await File(path).exists()) {
        await File(path).delete();
        debugPrint('📊 Database file deleted: $path');
      }

      _database = null;
    } catch (e) {
      debugPrint('❌ Error deleting database: $e');
    }
  }

  /// Get database info for debugging
  static Future<Map<String, dynamic>> getDatabaseInfo() async {
    try {
      final db = await database;
      final userCount =
          await db.rawQuery('SELECT COUNT(*) as count FROM $_usersTable');
      final dbSize = await db.rawQuery('PRAGMA page_count');

      return {
        'database_name': _databaseName,
        'database_version': _databaseVersion,
        'user_count': Sqflite.firstIntValue(userCount) ?? 0,
        'page_count': Sqflite.firstIntValue(dbSize) ?? 0,
      };
    } catch (e) {
      debugPrint('❌ Error getting database info: $e');
      return {
        'error': e.toString(),
      };
    }
  }
}
