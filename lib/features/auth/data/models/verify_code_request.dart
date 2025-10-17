import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify_code_request.g.dart';

/// Request model for verifying email with code
@JsonSerializable(createToJson: true)
class VerifyCodeRequest extends Equatable {
  /// User's email address
  final String email;
  
  /// Verification code
  final String code;

  const VerifyCodeRequest({
    required this.email,
    required this.code,
  });

  /// Create VerifyCodeRequest from JSON
  factory VerifyCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyCodeRequestFromJson(json);

  /// Convert VerifyCodeRequest to JSON
  Map<String, dynamic> toJson() => _$VerifyCodeRequestToJson(this);

  @override
  List<Object?> get props => [email, code];

  @override
  String toString() => 'VerifyCodeRequest(email: $email, code: $code)';
}