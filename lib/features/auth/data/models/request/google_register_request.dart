import 'package:equatable/equatable.dart';
import 'package:gigafaucet/core/enum/user_role.dart';

/// Login request model for API calls
class GoogleRegisterRequest extends Equatable {
  const GoogleRegisterRequest({
    this.avatar,
    required this.recaptchaToken,
    required this.countryCode,
    required this.userAgent,
    required this.deviceFingerprint,
    required this.role,
    this.accessToken,
    this.referralCode,
  });

  /// User's Firebase UserCredential obtained from Google sign-in
  final String? avatar;

  /// reCAPTCHA token for verification (optional, will be null in debug mode)
  final String? recaptchaToken;

  /// Country code for the user's location
  final String countryCode;

  // User agent string for the device
  final String userAgent;

  // Device unique identifier
  final String deviceFingerprint;

  final String? referralCode;

  final UserRole role;

  final String? accessToken;

  /// Convert to JSON for API request
  Future<Map<String, dynamic>> toJson() async {
    final json = {
      'country_code': countryCode,
      'userAgent': userAgent,
      'device_fingerprint': deviceFingerprint,
      'accessToken': accessToken ?? '',
      'avatar': avatar ?? '',
      'role': role.toString(),
      'referralCode': referralCode,
    };

    // Only add recaptchaToken if it's not null
    if (recaptchaToken != null) {
      json['turnstileToken'] = recaptchaToken!;
    }

    return json;
  }

  /// Create a copy with updated values
  GoogleRegisterRequest copyWith({
    String? avatar,
    String? accessToken,
    String? recaptchaToken,
    String? countryCode,
    String? userAgent,
    String? deviceFingerprint,
    UserRole? role,
    String? referralCode,
  }) {
    return GoogleRegisterRequest(
      recaptchaToken: recaptchaToken ?? this.recaptchaToken,
      countryCode: countryCode ?? this.countryCode,
      userAgent: userAgent ?? this.userAgent,
      deviceFingerprint: deviceFingerprint ?? this.deviceFingerprint,
      role: role ?? this.role,
      referralCode: referralCode ?? this.referralCode,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  @override
  List<Object?> get props => [
        avatar,
        accessToken,
        recaptchaToken,
        countryCode,
        userAgent,
        deviceFingerprint,
        role,
        referralCode
      ];
  @override
  String toString() =>
      'GoogleLoginRequest(avatar: $avatar, accessToken: $accessToken, '
      'recaptchaToken: $recaptchaToken, countryCode: $countryCode, '
      'userAgent: $userAgent, deviceFingerprint: $deviceFingerprint, '
      'role: $role, referralCode: $referralCode)';
}
