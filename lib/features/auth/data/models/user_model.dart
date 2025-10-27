import '../../domain/entities/user.dart';
import '../../../../core/enum/user_role.dart';

/// User model for data layer
///
/// Extends the User entity with JSON serialization capabilities
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
  });

  /// Create UserModel from JSON response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRole.tryFromString(json['role'] as String?) ??
          UserRole.normalUser,
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.value,
    };
  }

  /// Create UserModel from User entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
    );
  }

  /// Create UserModel from database JSON (SQLite)
  factory UserModel.fromDatabaseJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRole.tryFromString(json['role'] as String?) ??
          UserRole.normalUser,
    );
  }

  /// Convert to User entity
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      role: role,
    );
  }

  /// Create a copy with updated values (returns UserModel)
  @override
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    UserRole? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }
}
