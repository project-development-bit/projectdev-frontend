import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify_login_2fa_request.g.dart';

/// Request model for verifying 2FA during login
///
/// Used for POST /2fa/verify-login endpoint
@JsonSerializable()
class VerifyLogin2FARequest extends Equatable {
  /// 6-digit verification token from authenticator app
  final String token;

  /// User ID returned from initial login response
  final int userId;

  /// Creates an instance of [VerifyLogin2FARequest]
  const VerifyLogin2FARequest({
    required this.token,
    required this.userId,
  });

  /// Creates [VerifyLogin2FARequest] from JSON
  factory VerifyLogin2FARequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyLogin2FARequestFromJson(json);

  /// Converts [VerifyLogin2FARequest] to JSON
  Map<String, dynamic> toJson() => _$VerifyLogin2FARequestToJson(this);

  @override
  List<Object?> get props => [token, userId];
}
