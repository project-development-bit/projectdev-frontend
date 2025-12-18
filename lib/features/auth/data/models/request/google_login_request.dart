import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Login request model for API calls
class GoogleLoginRequest extends Equatable {
  const GoogleLoginRequest({
    this.userCredential,
    required this.recaptchaToken,
    required this.countryCode,
    required this.userAgent,
    required this.deviceFingerprint,
  });

  /// User's Firebase UserCredential obtained from Google sign-in
  final UserCredential? userCredential;

  /// reCAPTCHA token for verification (optional, will be null in debug mode)
  final String? recaptchaToken;

  /// Country code for the user's location
  final String countryCode;

  // User agent string for the device
  final String userAgent;

  // Device unique identifier
  final String deviceFingerprint;

  /// Convert to JSON for API request
  Future<Map<String, dynamic>> toJson() async {
    if (userCredential == null) {
      throw Exception('UserCredential is required to create JSON payload.');
    }
    final json = {
      'country_code': countryCode,
      'userAgent': userAgent,
      'device_fingerprint': deviceFingerprint,
      'idToken': userCredential?.credential?.accessToken ?? '',
    };

    // Only add recaptchaToken if it's not null
    if (recaptchaToken != null) {
      json['turnstileToken'] = recaptchaToken!;
    }

    return json;
  }

  /// Create a copy with updated values
  GoogleLoginRequest copyWith({
    UserCredential? userCredential,
    String? recaptchaToken,
    String? countryCode,
    String? userAgent,
    String? deviceFingerprint,
  }) {
    return GoogleLoginRequest(
      userCredential: userCredential ?? this.userCredential,
      recaptchaToken: recaptchaToken ?? this.recaptchaToken,
      countryCode: countryCode ?? this.countryCode,
      userAgent: userAgent ?? this.userAgent,
      deviceFingerprint: deviceFingerprint ?? this.deviceFingerprint,
    );
  }

  @override
  List<Object?> get props => [userCredential];
  @override
  String toString() => 'GoogleLoginRequest(userCredential: $userCredential)';
}
