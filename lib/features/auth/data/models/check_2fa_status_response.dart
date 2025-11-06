import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'check_2fa_status_response.g.dart';

/// Response model for checking 2FA status
@JsonSerializable(createFactory: true)
class Check2FAStatusResponse extends Equatable {
  /// Whether the request was successful
  final bool success;

  /// 2FA status data
  final Check2FAStatusData? data;

  const Check2FAStatusResponse({
    required this.success,
    this.data,
  });

  /// Create Check2FAStatusResponse from JSON
  factory Check2FAStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$Check2FAStatusResponseFromJson(json);

  /// Convert Check2FAStatusResponse to JSON
  Map<String, dynamic> toJson() => _$Check2FAStatusResponseToJson(this);

  @override
  List<Object?> get props => [success, data];

  @override
  String toString() =>
      'Check2FAStatusResponse(success: $success, data: $data)';
}

/// Data model for 2FA status response
@JsonSerializable(createFactory: true)
class Check2FAStatusData extends Equatable {
  /// Whether 2FA is enabled for the account
  @JsonKey(name: 'twofa_enabled')
  final bool twofaEnabled;

  const Check2FAStatusData({
    required this.twofaEnabled,
  });

  /// Create Check2FAStatusData from JSON
  factory Check2FAStatusData.fromJson(Map<String, dynamic> json) =>
      _$Check2FAStatusDataFromJson(json);

  /// Convert Check2FAStatusData to JSON
  Map<String, dynamic> toJson() => _$Check2FAStatusDataToJson(this);

  @override
  List<Object?> get props => [twofaEnabled];

  @override
  String toString() => 'Check2FAStatusData(twofaEnabled: $twofaEnabled)';
}
