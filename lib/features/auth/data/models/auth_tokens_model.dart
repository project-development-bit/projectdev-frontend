import '../../domain/entities/auth_tokens.dart';

/// AuthTokens model for data layer
/// 
/// Extends the AuthTokens entity with JSON serialization capabilities
class AuthTokensModel extends AuthTokens {
  const AuthTokensModel({
    required super.accessToken,
    required super.refreshToken,
    required super.tokenType,
    required super.accessTokenExpiresIn,
    required super.refreshTokenExpiresIn,
  });

  /// Create AuthTokensModel from JSON response
  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenType: json['tokenType'] as String,
      accessTokenExpiresIn: json['accessTokenExpiresIn'] as String,
      refreshTokenExpiresIn: json['refreshTokenExpiresIn'] as String,
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'accessTokenExpiresIn': accessTokenExpiresIn,
      'refreshTokenExpiresIn': refreshTokenExpiresIn,
    };
  }

  /// Create AuthTokensModel from AuthTokens entity
  factory AuthTokensModel.fromEntity(AuthTokens tokens) {
    return AuthTokensModel(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      tokenType: tokens.tokenType,
      accessTokenExpiresIn: tokens.accessTokenExpiresIn,
      refreshTokenExpiresIn: tokens.refreshTokenExpiresIn,
    );
  }

  /// Convert to AuthTokens entity
  AuthTokens toEntity() {
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
      accessTokenExpiresIn: accessTokenExpiresIn,
      refreshTokenExpiresIn: refreshTokenExpiresIn,
    );
  }

  /// Create a copy with updated values (returns AuthTokensModel)
  @override
  AuthTokensModel copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    String? accessTokenExpiresIn,
    String? refreshTokenExpiresIn,
  }) {
    return AuthTokensModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      accessTokenExpiresIn: accessTokenExpiresIn ?? this.accessTokenExpiresIn,
      refreshTokenExpiresIn: refreshTokenExpiresIn ?? this.refreshTokenExpiresIn,
    );
  }
}