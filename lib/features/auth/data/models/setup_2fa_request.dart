import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'setup_2fa_request.g.dart';

/// Request model for setting up 2FA
/// Note: This endpoint doesn't require a body, but we keep the model for consistency
@JsonSerializable(createToJson: true)
class Setup2FARequest extends Equatable {
  const Setup2FARequest();

  /// Create Setup2FARequest from JSON
  factory Setup2FARequest.fromJson(Map<String, dynamic> json) =>
      _$Setup2FARequestFromJson(json);

  /// Convert Setup2FARequest to JSON
  Map<String, dynamic> toJson() => _$Setup2FARequestToJson(this);

  @override
  List<Object?> get props => [];

  @override
  String toString() => 'Setup2FARequest()';
}
