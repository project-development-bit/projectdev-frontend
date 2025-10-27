import 'package:equatable/equatable.dart';
import '../../../../core/enum/user_role.dart';

/// User entity for authentication
///
/// Represents the authenticated user's basic information
class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  /// Unique user identifier
  final int id;

  /// User's full name
  final String name;

  /// User's email address
  final String email;

  /// User's role in the system
  final UserRole role;

  /// Create a copy of this User with updated values
  User copyWith({
    int? id,
    String? name,
    String? email,
    UserRole? role,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  @override
  List<Object> get props => [id, name, email, role];

  @override
  String toString() => 'User(id: $id, name: $name, email: $email, role: $role)';
}
