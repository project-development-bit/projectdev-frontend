import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';
import 'auth_tokens_model.dart';

part 'verify_2fa_response.g.dart';

/// Response model for 2FA verification API
@JsonSerializable(createFactory: true)
class Verify2FAResponse extends Equatable {
  /// Whether the verification was successful
  final bool success;

  /// Response message
  final String message;

  /// User data and tokens
  final Verify2FAData? data;

  const Verify2FAResponse({
    required this.success,
    required this.message,
    this.data,
  });

  /// Create Verify2FAResponse from JSON
  factory Verify2FAResponse.fromJson(Map<String, dynamic> json) =>
      _$Verify2FAResponseFromJson(json);

  /// Convert Verify2FAResponse to JSON
  Map<String, dynamic> toJson() => _$Verify2FAResponseToJson(this);

  @override
  List<Object?> get props => [success, message, data];

  @override
  String toString() =>
      'Verify2FAResponse(success: $success, message: $message, hasData: ${data != null})';
}

/// Data model for 2FA verification response
@JsonSerializable(createFactory: true)
class Verify2FAData extends Equatable {
  /// User information
  final UserModel user;

  /// Authentication tokens
  final AuthTokensModel tokens;

  const Verify2FAData({
    required this.user,
    required this.tokens,
  });

  /// Create Verify2FAData from JSON
  factory Verify2FAData.fromJson(Map<String, dynamic> json) =>
      _$Verify2FADataFromJson(json);

  /// Convert Verify2FAData to JSON
  Map<String, dynamic> toJson() => _$Verify2FADataToJson(this);

  @override
  List<Object?> get props => [user, tokens];

  @override
  String toString() => 'Verify2FAData(user: ${user.email}, tokens: present)';
}
