import 'package:equatable/equatable.dart';

/// Login request model for API calls
class GoogleLoginRequest extends Equatable {
  const GoogleLoginRequest({
    this.accessToken,
    this.avatar,
    required this.recaptchaToken,
    required this.countryCode,
    required this.userAgent,
    required this.deviceFingerprint,
  });

  final String? accessToken;
  final String? avatar;

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
    if (accessToken == null) {
      throw Exception('ID Token is required to create JSON payload.');
    }
    final json = {
      'country_code': countryCode,
      'userAgent': userAgent,
      'device_fingerprint': deviceFingerprint,
      'accessToken': accessToken ?? '',
      // 'avatar': avatar ?? '',
    };

    // Only add recaptchaToken if it's not null
    if (recaptchaToken != null) {
      json['turnstileToken'] = recaptchaToken!;
    }

    return json;
  }

  /// Create a copy with updated values
  GoogleLoginRequest copyWith({
    String? accessToken,
    String? avatar,
    String? recaptchaToken,
    String? countryCode,
    String? userAgent,
    String? deviceFingerprint,
  }) {
    return GoogleLoginRequest(
      accessToken: accessToken ?? this.accessToken,
      avatar: avatar ?? this.avatar,
      recaptchaToken: recaptchaToken ?? this.recaptchaToken,
      countryCode: countryCode ?? this.countryCode,
      userAgent: userAgent ?? this.userAgent,
      deviceFingerprint: deviceFingerprint ?? this.deviceFingerprint,
    );
  }

  @override
  List<Object?> get props => [
        accessToken,
        avatar,
        recaptchaToken,
        countryCode,
        userAgent,
        deviceFingerprint
      ];
  @override
  String toString() =>
      'GoogleLoginRequest(accessToken: $accessToken, avatar: $avatar, recaptchaToken: $recaptchaToken, countryCode: $countryCode, userAgent: $userAgent, deviceFingerprint: $deviceFingerprint)';
}
