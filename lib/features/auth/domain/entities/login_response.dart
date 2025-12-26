import 'package:equatable/equatable.dart';
import 'user.dart';
import 'auth_tokens.dart';

/// Login response entity
///
/// Represents the complete login response from the server
class LoginResponse extends Equatable {
  const LoginResponse({
    required this.success,
    required this.message,
    this.user,
    this.tokens,
    this.userId,
  });

  /// Whether the login was successful
  final bool success;

  /// Response message from server
  final String message;

  /// Authenticated user information (nullable when 2FA is required)
  final User? user;

  /// Authentication tokens (nullable when 2FA is required)
  final AuthTokens? tokens;

  /// if userID is not empty, we can say this user is enabled for 2FA
  final int? userId;

  /// Create a copy of this LoginResponse with updated values
  LoginResponse copyWith({
    bool? success,
    String? message,
    User? user,
    AuthTokens? tokens,
    int? userId,
  }) {
    return LoginResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      user: user ?? this.user,
      tokens: tokens ?? this.tokens,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [success, message, user, tokens, userId];

  @override
  String toString() =>
      'LoginResponse(success: $success, message: $message, user: $user , userId: $userId)';
}
