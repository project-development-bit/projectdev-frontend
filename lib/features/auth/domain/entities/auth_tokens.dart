import 'package:equatable/equatable.dart';

/// Token entity for authentication
/// 
/// Represents the authentication tokens received from the server
class AuthTokens extends Equatable {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.accessTokenExpiresIn,
    required this.refreshTokenExpiresIn,
  });

  /// JWT access token for API requests
  final String accessToken;

  /// JWT refresh token for token renewal
  final String refreshToken;

  /// Type of token (usually "Bearer")
  final String tokenType;

  /// Access token expiration duration (e.g., "15m")
  final String accessTokenExpiresIn;

  /// Refresh token expiration duration (e.g., "7d")
  final String refreshTokenExpiresIn;

  /// Create a copy of this AuthTokens with updated values
  AuthTokens copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    String? accessTokenExpiresIn,
    String? refreshTokenExpiresIn,
  }) {
    return AuthTokens(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      accessTokenExpiresIn: accessTokenExpiresIn ?? this.accessTokenExpiresIn,
      refreshTokenExpiresIn: refreshTokenExpiresIn ?? this.refreshTokenExpiresIn,
    );
  }

  @override
  List<Object> get props => [
    accessToken,
    refreshToken,
    tokenType,
    accessTokenExpiresIn,
    refreshTokenExpiresIn,
  ];

  @override
  String toString() => 'AuthTokens(tokenType: $tokenType, expiresIn: $accessTokenExpiresIn)';
}