import 'package:flutter/material.dart';

/// User role enumeration for different user types in the application
enum UserRole {
  /// Developer role - typically for development and testing purposes
  dev('Dev'),

  /// Administrator role - has administrative privileges
  admin('Admin'),

  /// Super user role - has the highest level of privileges
  superUser('SuperUser'),

  /// Normal user role - standard user with basic privileges
  normalUser('NormalUser');

  /// The string value of the role as it appears in the API
  const UserRole(this.value);

  /// The string representation of the role
  final String value;

  /// Create UserRole from string value
  static UserRole fromString(String value) {
    // Handle case variations and common server response formats
    final normalizedValue = value.trim();

    switch (normalizedValue) {
      case 'Dev':
      case 'dev':
        return UserRole.dev;
      case 'Admin':
      case 'admin':
        return UserRole.admin;
      case 'SuperUser':
      case 'superUser':
      case 'super_user':
      case 'SUPER_USER':
        return UserRole.superUser;
      case 'NormalUser':
      case 'normalUser':
      case 'normal_user':
      case 'NORMAL_USER':
      case 'user':
      case 'User':
        return UserRole.normalUser;
      default:
        // Log the invalid value for debugging
        debugPrint(
            '⚠️ Invalid user role received: "$value". Defaulting to normalUser.');
        return UserRole
            .normalUser; // Default to normal user instead of throwing
    }
  }

  /// Try to create UserRole from string value, returns null if invalid
  static UserRole? tryFromString(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    try {
      return fromString(value);
    } catch (e) {
      // Log the error for debugging
      debugPrint('⚠️ Failed to parse user role: "$value". Error: $e');
      return UserRole.normalUser; // Default to normal user instead of null
    }
  }

  /// Get all available user roles
  static List<UserRole> get allRoles => UserRole.values;

  /// Get roles with administrative privileges
  static List<UserRole> get adminRoles => [
        UserRole.admin,
        UserRole.superUser,
      ];

  /// Get roles with elevated privileges (admin and dev)
  static List<UserRole> get elevatedRoles => [
        UserRole.dev,
        UserRole.admin,
        UserRole.superUser,
      ];
}

/// Extension methods for UserRole enum
extension UserRoleExtension on UserRole {
  /// Check if the role has administrative privileges
  bool get isAdmin => this == UserRole.admin || this == UserRole.superUser;

  /// Check if the role is a super user
  bool get isSuperUser => this == UserRole.superUser;

  /// Check if the role is a developer
  bool get isDev => this == UserRole.dev;

  /// Check if the role is a normal user
  bool get isNormalUser => this == UserRole.normalUser;

  /// Check if the role has elevated privileges (dev, admin, or super user)
  bool get hasElevatedPrivileges =>
      this == UserRole.dev ||
      this == UserRole.admin ||
      this == UserRole.superUser;

  /// Check if the role can access admin features
  bool get canAccessAdminFeatures => isAdmin;

  /// Check if the role can access developer features
  bool get canAccessDevFeatures => isDev || isSuperUser;

  /// Check if the role can manage users
  bool get canManageUsers => isSuperUser;

  /// Check if the role can modify system settings
  bool get canModifySystemSettings => isAdmin || isSuperUser;

  /// Get the display name for the role
  String get displayName {
    switch (this) {
      case UserRole.dev:
        return 'Developer';
      case UserRole.admin:
        return 'Administrator';
      case UserRole.superUser:
        return 'Super User';
      case UserRole.normalUser:
        return 'User';
    }
  }

  /// Get a short description of the role
  String get description {
    switch (this) {
      case UserRole.dev:
        return 'Developer with testing and debugging privileges';
      case UserRole.admin:
        return 'Administrator with management privileges';
      case UserRole.superUser:
        return 'Super user with full system access';
      case UserRole.normalUser:
        return 'Standard user with basic access';
    }
  }

  /// Get the priority level of the role (higher number = more privileges)
  int get priorityLevel {
    switch (this) {
      case UserRole.normalUser:
        return 1;
      case UserRole.dev:
        return 2;
      case UserRole.admin:
        return 3;
      case UserRole.superUser:
        return 4;
    }
  }

  /// Check if this role has higher or equal privileges than another role
  bool hasHigherOrEqualPrivilegesThan(UserRole other) {
    return priorityLevel >= other.priorityLevel;
  }

  /// Check if this role has higher privileges than another role
  bool hasHigherPrivilegesThan(UserRole other) {
    return priorityLevel > other.priorityLevel;
  }

  /// Convert to JSON serializable format
  String toJson() => value;

  /// Create from JSON
  static UserRole fromJson(String json) => UserRole.fromString(json);
}

/// Extension for nullable UserRole
extension NullableUserRoleExtension on UserRole? {
  /// Check if the role is null or normal user
  bool get isNullOrNormalUser => this == null || this == UserRole.normalUser;

  /// Check if the role has any administrative privileges (null-safe)
  bool get hasAdminPrivileges => this?.isAdmin ?? false;

  /// Check if the role has elevated privileges (null-safe)
  bool get hasElevatedPrivileges => this?.hasElevatedPrivileges ?? false;

  /// Get display name with fallback for null
  String get safeDisplayName => this?.displayName ?? 'Unknown';

  /// Get priority level with fallback for null (lowest priority)
  int get safePriorityLevel => this?.priorityLevel ?? 0;
}
