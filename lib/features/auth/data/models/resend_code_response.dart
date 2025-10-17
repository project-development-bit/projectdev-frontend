import 'package:equatable/equatable.dart';

/// Response model for resend verification code
class ResendCodeResponse extends Equatable {
  /// Indicates if the request was successful
  final bool success;
  
  /// Response message
  final String message;
  
  /// Response data containing email and security code
  final ResendCodeData data;

  /// Creates a new [ResendCodeResponse]
  const ResendCodeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  /// Creates a [ResendCodeResponse] from JSON
  factory ResendCodeResponse.fromJson(Map<String, dynamic> json) {
    return ResendCodeResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ResendCodeData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  /// Converts [ResendCodeResponse] to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }

  @override
  List<Object?> get props => [success, message, data];
}

/// Data model for resend code response
class ResendCodeData extends Equatable {
  /// User's email address
  final String email;
  
  /// Security code sent to user (for testing purposes)
  final int securityCode;

  /// Creates a new [ResendCodeData]
  const ResendCodeData({
    required this.email,
    required this.securityCode,
  });

  /// Creates a [ResendCodeData] from JSON
  factory ResendCodeData.fromJson(Map<String, dynamic> json) {
    return ResendCodeData(
      email: json['email'] as String,
      securityCode: json['securityCode'] as int,
    );
  }

  /// Converts [ResendCodeData] to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'securityCode': securityCode,
    };
  }

  @override
  List<Object?> get props => [email, securityCode];
}