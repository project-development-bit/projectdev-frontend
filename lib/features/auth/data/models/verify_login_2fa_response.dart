import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';
import 'auth_tokens_model.dart';

part 'verify_login_2fa_response.g.dart';

/// Response model for verifying 2FA during login
///
/// Used for POST /2fa/verify-login endpoint
/// Returns the same structure as regular login response
@JsonSerializable()
class VerifyLogin2FAResponse extends Equatable {
  /// Success status
  final bool success;

  /// Response message
  final String message;

  /// Response data containing user and tokens
  final VerifyLogin2FAData? data;

  /// Creates an instance of [VerifyLogin2FAResponse]
  const VerifyLogin2FAResponse({
    required this.success,
    required this.message,
    this.data,
  });

  /// Creates [VerifyLogin2FAResponse] from JSON
  factory VerifyLogin2FAResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyLogin2FAResponseFromJson(json);

  /// Converts [VerifyLogin2FAResponse] to JSON
  Map<String, dynamic> toJson() => _$VerifyLogin2FAResponseToJson(this);

  @override
  List<Object?> get props => [success, message, data];
}

/// Data model for verify login 2FA response
@JsonSerializable()
class VerifyLogin2FAData extends Equatable {
  /// Authenticated user information
  final UserModel user;

  /// Authentication tokens
  final AuthTokensModel tokens;

  /// Creates an instance of [VerifyLogin2FAData]
  const VerifyLogin2FAData({
    required this.user,
    required this.tokens,
  });

  /// Creates [VerifyLogin2FAData] from JSON
  factory VerifyLogin2FAData.fromJson(Map<String, dynamic> json) =>
      _$VerifyLogin2FADataFromJson(json);

  /// Converts [VerifyLogin2FAData] to JSON
  Map<String, dynamic> toJson() => _$VerifyLogin2FADataToJson(this);

  @override
  List<Object?> get props => [user, tokens];
}
