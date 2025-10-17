import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify_code_response.g.dart';

/// Response model for verify code API
@JsonSerializable(createFactory: true)
class VerifyCodeResponse extends Equatable {
  /// Whether the verification was successful
  final bool success;
  
  /// Response message
  final String message;
  
  /// User data and tokens
  final VerifyCodeData? data;

  const VerifyCodeResponse({
    required this.success,
    required this.message,
    this.data,
  });

  /// Create VerifyCodeResponse from JSON
  factory VerifyCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyCodeResponseFromJson(json);

  /// Convert VerifyCodeResponse to JSON
  Map<String, dynamic> toJson() => _$VerifyCodeResponseToJson(this);

  @override
  List<Object?> get props => [success, message, data];

  @override
  String toString() => 'VerifyCodeResponse(success: $success, message: $message, data: $data)';
}

/// Data model for verify code response
@JsonSerializable(createFactory: true)
class VerifyCodeData extends Equatable {
  /// User information
  final User user;
  
  /// Authentication tokens
  final Tokens tokens;

  const VerifyCodeData({
    required this.user,
    required this.tokens,
  });

  /// Create VerifyCodeData from JSON
  factory VerifyCodeData.fromJson(Map<String, dynamic> json) =>
      _$VerifyCodeDataFromJson(json);

  /// Convert VerifyCodeData to JSON
  Map<String, dynamic> toJson() => _$VerifyCodeDataToJson(this);

  @override
  List<Object?> get props => [user, tokens];

  @override
  String toString() => 'VerifyCodeData(user: $user, tokens: $tokens)';
}

/// User model from verify code response
@JsonSerializable(createFactory: true)
class User extends Equatable {
  /// User ID
  final int id;
  
  /// User name
  final String name;
  
  /// User email
  final String email;
  
  /// User role
  final String role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  /// Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  /// Convert User to JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [id, name, email, role];

  @override
  String toString() => 'User(id: $id, name: $name, email: $email, role: $role)';
}

/// Tokens model from verify code response
@JsonSerializable(createFactory: true)
class Tokens extends Equatable {
  /// Access token
  final String accessToken;
  
  /// Refresh token
  final String refreshToken;
  
  /// Token type (usually "Bearer")
  final String tokenType;
  
  /// Access token expiration time
  final String accessTokenExpiresIn;
  
  /// Refresh token expiration time
  final String refreshTokenExpiresIn;

  const Tokens({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.accessTokenExpiresIn,
    required this.refreshTokenExpiresIn,
  });

  /// Create Tokens from JSON
  factory Tokens.fromJson(Map<String, dynamic> json) =>
      _$TokensFromJson(json);

  /// Convert Tokens to JSON
  Map<String, dynamic> toJson() => _$TokensToJson(this);

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        tokenType,
        accessTokenExpiresIn,
        refreshTokenExpiresIn,
      ];

  @override
  String toString() => 'Tokens(accessToken: ${accessToken.substring(0, 20)}..., refreshToken: ${refreshToken.substring(0, 20)}..., tokenType: $tokenType, accessTokenExpiresIn: $accessTokenExpiresIn, refreshTokenExpiresIn: $refreshTokenExpiresIn)';
}