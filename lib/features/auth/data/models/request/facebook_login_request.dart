import 'package:equatable/equatable.dart';
import 'package:gigafaucet/core/enum/user_role.dart';

class FacebookLoginRequest extends Equatable {
  final String? accessToken;
  final String? recaptchaToken;
  final String countryCode;
  final String userAgent;
  final String deviceFingerprint;

  const FacebookLoginRequest({
    this.accessToken,
    this.recaptchaToken,
    required this.countryCode,
    required this.userAgent,
    required this.deviceFingerprint,
  });
  FacebookLoginRequest copyWith(
      {String? accessToken,
      String? recaptchaToken,
      String? countryCode,
      String? userAgent,
      String? deviceFingerprint}) {
    return FacebookLoginRequest(
      accessToken: accessToken ?? this.accessToken,
      recaptchaToken: recaptchaToken ?? this.recaptchaToken,
      countryCode: countryCode ?? this.countryCode,
      userAgent: userAgent ?? this.userAgent,
      deviceFingerprint: deviceFingerprint ?? this.deviceFingerprint,
    );
  }

  @override
  List<Object?> get props =>
      [accessToken, recaptchaToken, countryCode, userAgent, deviceFingerprint];

  Future<Map<String, dynamic>> toJson() async {
    if (accessToken?.isEmpty ?? true) {
      throw Exception('Access Token is required to create JSON payload.');
    }
    final json = {
      'country_code': countryCode,
      'userAgent': userAgent,
      'device_fingerprint': deviceFingerprint,
      'accessToken': accessToken,
    };

    // Only add recaptchaToken if it's not null
    if (recaptchaToken != null) {
      json['turnstileToken'] = recaptchaToken!;
    }

    return json;
  }
}

class FacebookRegisterRequest extends Equatable {
  final String? accessToken;
  final String? recaptchaToken;

  /// Country code for the user's location
  final String countryCode;

  // User agent string for the device
  final String userAgent;

  // Device unique identifier
  final String deviceFingerprint;

  final String? referralCode;

  final UserRole role;

  const FacebookRegisterRequest({
    this.accessToken,
    this.recaptchaToken,
    required this.countryCode,
    required this.userAgent,
    required this.deviceFingerprint,
    this.referralCode,
    required this.role,
  });

  // Method to copy with updated values
  FacebookRegisterRequest copyWith(
      {String? accessToken,
      String? recaptchaToken,
      String? countryCode,
      String? userAgent,
      String? deviceFingerprint,
      String? referralCode,
      UserRole? role}) {
    return FacebookRegisterRequest(
      accessToken: accessToken ?? this.accessToken,
      recaptchaToken: recaptchaToken ?? this.recaptchaToken,
      countryCode: countryCode ?? this.countryCode,
      userAgent: userAgent ?? this.userAgent,
      deviceFingerprint: deviceFingerprint ?? this.deviceFingerprint,
      referralCode: referralCode ?? this.referralCode,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [
        accessToken,
        recaptchaToken,
        countryCode,
        userAgent,
        deviceFingerprint,
        referralCode,
        role
      ];

  Future<Map<String, dynamic>> toJson() async {
    final json = {
      'country_code': countryCode,
      'userAgent': userAgent,
      'device_fingerprint': deviceFingerprint,
      'accessToken': accessToken,
      'role': role.toString(),
      'referralCode': referralCode,
    };

    // Only add recaptchaToken if it's not null
    if (recaptchaToken != null) {
      json['turnstileToken'] = recaptchaToken!;
    }

    return json;
  }
}
