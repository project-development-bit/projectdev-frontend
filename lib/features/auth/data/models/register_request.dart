import '../../../../core/enum/user_role.dart';

class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final UserRole role;
  final String? recaptchaToken;
  final String? countryCode;
  late final String userAgent;
  late final String deviceId;
  final String? referralCode;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.userAgent,
    required this.deviceId,
    this.countryCode,
    this.role = UserRole.normalUser,
    this.recaptchaToken,
    this.referralCode,
  });

  Future<Map<String, dynamic>> toJson() async {
    return {
      'country_code': countryCode,
      'userAgent': userAgent,
      'device_fingerprint': deviceId,
      "name": name,
      "email": email,
      "password": password,
      "confirm_password": confirmPassword,
      "role": role.value,
      if (referralCode != null) "referral_code": referralCode,
      if (recaptchaToken != null) "turnstileToken": recaptchaToken,
    };
  }

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      userAgent: json['userAgent'] ?? '',
      deviceId: json['device_fingerprint'] ?? '',
      countryCode: json['country_code'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      confirmPassword: json['confirm_password'] ?? '',
      role: UserRole.tryFromString(json['role']) ?? UserRole.normalUser,
      recaptchaToken: json['turnstileToken'],
      referralCode: json['referral_code'],
    );
  }

  RegisterRequest copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    UserRole? role,
    String? recaptchaToken,
    String? userAgent,
    String? deviceId,
  }) {
    return RegisterRequest(
      userAgent: userAgent ?? this.userAgent,
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      role: role ?? this.role,
      recaptchaToken: recaptchaToken ?? this.recaptchaToken,
    );
  }
}

// {
//     "name": "User 9",
//     "email": "user9@gmail.com",
//     "password": "12345678",
//     "confirm_password": "12345678",
//     "role": "NormalUser"        // 'Dev', 'Admin', 'SuperUser', 'NormalUser'
// }
