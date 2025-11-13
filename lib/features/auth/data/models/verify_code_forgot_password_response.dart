import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify_code_forgot_password_response.g.dart';

@JsonSerializable()
class VerifyCodeForForgotPasswordResponse extends Equatable {
  final bool success;
  final String message;
  final VerifyCodeForForgotPasswordData? data;

  const VerifyCodeForForgotPasswordResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory VerifyCodeForForgotPasswordResponse.fromJson(
          Map<String, dynamic> json) =>
      _$VerifyCodeForForgotPasswordResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$VerifyCodeForForgotPasswordResponseToJson(this);

  @override
  List<Object?> get props => [success, message, data];
}

@JsonSerializable()
class VerifyCodeForForgotPasswordData extends Equatable {
  final String email;
  final bool verified;

  const VerifyCodeForForgotPasswordData({
    required this.email,
    required this.verified,
  });

  factory VerifyCodeForForgotPasswordData.fromJson(Map<String, dynamic> json) =>
      _$VerifyCodeForForgotPasswordDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$VerifyCodeForForgotPasswordDataToJson(this);

  @override
  List<Object?> get props => [email, verified];
}
