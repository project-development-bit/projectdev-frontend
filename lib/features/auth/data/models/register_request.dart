import '../../../../core/enum/user_role.dart';

class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final UserRole role;
  final String? recaptchaToken;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.role = UserRole.normalUser,
    this.recaptchaToken,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "confirm_password": confirmPassword,
      "role": role.value,
      if (recaptchaToken != null) "recaptchaToken": recaptchaToken,
    };
  }

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      confirmPassword: json['confirm_password'] ?? '',
      role: UserRole.tryFromString(json['role']) ?? UserRole.normalUser,
      recaptchaToken: json['recaptchaToken'],
    );
  }

  RegisterRequest copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    UserRole? role,
    String? recaptchaToken,
  }) {
    return RegisterRequest(
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
