import 'package:cointiply_app/core/services/device_info.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Login request model for API calls
class LoginRequest extends Equatable {
  const LoginRequest({
    required this.email,
    required this.password,
    required this.countryCode,
    this.recaptchaToken,
  });

  /// User's email address
  final String email;

  /// User's password
  final String password;

  /// reCAPTCHA token for verification (optional, will be null in debug mode)
  final String? recaptchaToken;

  /// Country code for the user's location
  final String countryCode;

  /// Convert to JSON for API request
  Future<Map<String, dynamic>> toJson() async {
    var userAgent = await DeviceInfo.getUserAgent();
    debugPrint("device info User Agent: $userAgent");
    String? deviceId = await DeviceInfo.getUniqueIdentifier();
    final json = {
      'country_code': countryCode,
      'userAgent': userAgent,
      'device_fingerprint': deviceId,
      'email': email,
      'password': password,
    };

    // Only add recaptchaToken if it's not null
    if (recaptchaToken != null) {
      json['recaptchaToken'] = recaptchaToken!;
    }

    return json;
  }

  /// Create from JSON response (if needed)
  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      countryCode: json['country_code'] ?? '',
      recaptchaToken: json['recaptchaToken'],
    );
  }

  /// Create a copy with updated values
  LoginRequest copyWith({
    String? email,
    String? password,
    String? recaptchaToken,
    String? countryCode,
    bool clearRecaptchaToken = false,
  }) {
    return LoginRequest(
      email: email ?? this.email,
      password: password ?? this.password,
      countryCode: countryCode ?? this.countryCode,
      recaptchaToken:
          clearRecaptchaToken ? null : (recaptchaToken ?? this.recaptchaToken),
    );
  }

  @override
  List<Object?> get props => [email, password, recaptchaToken];

  @override
  String toString() =>
      'LoginRequest(email: $email, hasRecaptcha: ${recaptchaToken != null})';
}
