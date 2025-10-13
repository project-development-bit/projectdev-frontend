import 'package:equatable/equatable.dart';

/// Login request model for API calls
class LoginRequest extends Equatable {
  const LoginRequest({
    required this.email,
    required this.password,
  });

  /// User's email address
  final String email;

  /// User's password
  final String password;

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  /// Create from JSON response (if needed)
  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  /// Create a copy with updated values
  LoginRequest copyWith({
    String? email,
    String? password,
  }) {
    return LoginRequest(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'LoginRequest(email: $email)';
}