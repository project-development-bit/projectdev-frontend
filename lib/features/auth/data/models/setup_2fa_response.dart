import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'setup_2fa_response.g.dart';

/// Response model for 2FA setup API
@JsonSerializable(createFactory: true)
class Setup2FAResponse extends Equatable {
  /// Whether the setup was successful
  final bool success;

  /// Response message
  final String message;

  /// 2FA setup data
  final Setup2FAData? data;

  const Setup2FAResponse({
    required this.success,
    required this.message,
    this.data,
  });

  /// Create Setup2FAResponse from JSON
  factory Setup2FAResponse.fromJson(Map<String, dynamic> json) =>
      _$Setup2FAResponseFromJson(json);

  /// Convert Setup2FAResponse to JSON
  Map<String, dynamic> toJson() => _$Setup2FAResponseToJson(this);

  @override
  List<Object?> get props => [success, message, data];

  @override
  String toString() =>
      'Setup2FAResponse(success: $success, message: $message, hasData: ${data != null})';
}

/// Data model for 2FA setup response
@JsonSerializable(createFactory: true)
class Setup2FAData extends Equatable {
  /// Secret key for manual entry
  final String secret;

  /// QR code as base64 encoded image (data:image/png;base64,...)
  final String qrCode;

  /// OTPAuth URL for authenticator apps
  final String otpauthUrl;

  const Setup2FAData({
    required this.secret,
    required this.qrCode,
    required this.otpauthUrl,
  });

  /// Create Setup2FAData from JSON
  factory Setup2FAData.fromJson(Map<String, dynamic> json) =>
      _$Setup2FADataFromJson(json);

  /// Convert Setup2FAData to JSON
  Map<String, dynamic> toJson() => _$Setup2FADataToJson(this);

  @override
  List<Object?> get props => [secret, qrCode, otpauthUrl];

  @override
  String toString() => 'Setup2FAData(secret: $secret, hasQrCode: ${qrCode.isNotEmpty})';
}
