import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'disable_2fa_request.g.dart';

/// Request model for disabling 2FA
///
/// Used for POST /2fa/disable endpoint
/// Requires a 4-digit token from the authenticator app
@JsonSerializable()
class Disable2FARequest extends Equatable {
  /// The 4-digit 2FA token from the authenticator app
  final String token;

  /// Creates an instance of [Disable2FARequest]
  const Disable2FARequest({required this.token});

  /// Creates [Disable2FARequest] from JSON
  factory Disable2FARequest.fromJson(Map<String, dynamic> json) =>
      _$Disable2FARequestFromJson(json);

  /// Converts [Disable2FARequest] to JSON
  Map<String, dynamic> toJson() => _$Disable2FARequestToJson(this);

  @override
  List<Object?> get props => [token];
}
