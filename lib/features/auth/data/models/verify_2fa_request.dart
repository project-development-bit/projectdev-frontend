import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify_2fa_request.g.dart';

/// Request model for verifying 2FA code
@JsonSerializable(createToJson: true)
class Verify2FARequest extends Equatable {
  /// User's email address
  final String email;

  /// 6-digit 2FA code from authenticator app
  @JsonKey(name: 'twoFactorCode')
  final String twoFactorCode;

  /// Optional session token from initial login
  final String? sessionToken;

  const Verify2FARequest({
    required this.email,
    required this.twoFactorCode,
    this.sessionToken,
  });

  /// Create Verify2FARequest from JSON
  factory Verify2FARequest.fromJson(Map<String, dynamic> json) =>
      _$Verify2FARequestFromJson(json);

  /// Convert Verify2FARequest to JSON
  Map<String, dynamic> toJson() => _$Verify2FARequestToJson(this);

  @override
  List<Object?> get props => [email, twoFactorCode, sessionToken];

  @override
  String toString() =>
      'Verify2FARequest(email: $email, twoFactorCode: $twoFactorCode, hasSessionToken: ${sessionToken != null})';
}
