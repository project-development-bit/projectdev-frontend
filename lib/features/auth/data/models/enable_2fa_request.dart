import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'enable_2fa_request.g.dart';

/// Request model for enabling 2FA after setup
///
/// This request is sent to verify the authenticator app setup
/// by providing the 6-digit token and the secret key
@JsonSerializable(createToJson: true)
class Enable2FARequest extends Equatable {
  /// The 6-digit verification token from authenticator app
  final String token;

  /// The secret key that was provided during setup
  final String secret;

  const Enable2FARequest({
    required this.token,
    required this.secret,
  });

  /// Convert Enable2FARequest to JSON
  Map<String, dynamic> toJson() => _$Enable2FARequestToJson(this);
  factory Enable2FARequest.fromJson(Map<String, dynamic> json) =>
      _$Enable2FARequestFromJson(json);

  @override
  List<Object?> get props => [token, secret];

  @override
  String toString() => 'Enable2FARequest(token: *****, secret: *****)';
}
