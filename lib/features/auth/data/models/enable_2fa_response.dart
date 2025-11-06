import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'enable_2fa_response.g.dart';

/// Response model for enabling 2FA
@JsonSerializable(createFactory: true)
class Enable2FAResponse extends Equatable {
  /// Whether the operation was successful
  final bool success;

  /// Response message
  final String message;

  /// 2FA enable data
  final Enable2FAData? data;

  const Enable2FAResponse({
    required this.success,
    required this.message,
    this.data,
  });

  /// Create Enable2FAResponse from JSON
  factory Enable2FAResponse.fromJson(Map<String, dynamic> json) =>
      _$Enable2FAResponseFromJson(json);

  /// Convert Enable2FAResponse to JSON
  Map<String, dynamic> toJson() => _$Enable2FAResponseToJson(this);

  @override
  List<Object?> get props => [success, message, data];

  @override
  String toString() =>
      'Enable2FAResponse(success: $success, message: $message, data: $data)';
}

/// Data model for 2FA enable response
@JsonSerializable(createFactory: true)
class Enable2FAData extends Equatable {
  /// Whether 2FA is now enabled for the account
  @JsonKey(name: 'twofa_enabled')
  final bool twofaEnabled;

  const Enable2FAData({
    required this.twofaEnabled,
  });

  /// Create Enable2FAData from JSON
  factory Enable2FAData.fromJson(Map<String, dynamic> json) =>
      _$Enable2FADataFromJson(json);

  /// Convert Enable2FAData to JSON
  Map<String, dynamic> toJson() => _$Enable2FADataToJson(this);

  @override
  List<Object?> get props => [twofaEnabled];

  @override
  String toString() => 'Enable2FAData(twofaEnabled: $twofaEnabled)';
}
