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
    required this.user,
    required this.tokens,
  });

  /// Whether the login was successful
  final bool success;

  /// Response message from server
  final String message;

  /// Authenticated user information
  final User user;

  /// Authentication tokens
  final AuthTokens tokens;

  /// Create a copy of this LoginResponse with updated values
  LoginResponse copyWith({
    bool? success,
    String? message,
    User? user,
    AuthTokens? tokens,
  }) {
    return LoginResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      user: user ?? this.user,
      tokens: tokens ?? this.tokens,
    );
  }

  @override
  List<Object> get props => [success, message, user, tokens];

  @override
  String toString() =>
      'LoginResponse(success: $success, message: $message, user: $user)';
}
