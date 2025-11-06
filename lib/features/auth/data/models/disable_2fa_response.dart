import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'disable_2fa_response.g.dart';

/// Response model for disabling 2FA
///
/// Used for POST /2fa/disable endpoint
@JsonSerializable()
class Disable2FAResponse extends Equatable {
  /// Success status of the disable operation
  final bool success;

  /// Success message from the server
  final String message;

  /// Data containing the updated 2FA status
  final Disable2FAData? data;

  /// Creates an instance of [Disable2FAResponse]
  const Disable2FAResponse({
    required this.success,
    required this.message,
    this.data,
  });

  /// Creates [Disable2FAResponse] from JSON
  factory Disable2FAResponse.fromJson(Map<String, dynamic> json) =>
      _$Disable2FAResponseFromJson(json);

  /// Converts [Disable2FAResponse] to JSON
  Map<String, dynamic> toJson() => _$Disable2FAResponseToJson(this);

  @override
  List<Object?> get props => [success, message, data];
}

/// Data model containing 2FA status after disabling
@JsonSerializable()
class Disable2FAData extends Equatable {
  /// Whether 2FA is enabled (should be false after disable)
  @JsonKey(name: 'twofa_enabled')
  final bool twofaEnabled;

  /// Creates an instance of [Disable2FAData]
  const Disable2FAData({
    required this.twofaEnabled,
  });

  /// Creates [Disable2FAData] from JSON
  factory Disable2FAData.fromJson(Map<String, dynamic> json) =>
      _$Disable2FADataFromJson(json);

  /// Converts [Disable2FAData] to JSON
  Map<String, dynamic> toJson() => _$Disable2FADataToJson(this);

  @override
  List<Object?> get props => [twofaEnabled];
}
