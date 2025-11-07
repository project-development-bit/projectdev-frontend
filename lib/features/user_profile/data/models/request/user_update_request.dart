import 'package:equatable/equatable.dart';

/// Request model for updating user information
class UserUpdateRequest extends Equatable {
  final String id;
  final String? name;
  final String? password;
  final String? confirmPassword;
  final String? email;
  final String? role;
  final String? country;
  final String? language;
  final String? profilePictureUrl;

  const UserUpdateRequest({
    required this.id,
    this.name,
    this.password,
    this.confirmPassword,
    this.email,
    this.role,
    this.country,
    this.language,
    this.profilePictureUrl,
  });

  /// Convert JSON → Model
  factory UserUpdateRequest.fromJson(Map<String, dynamic> json) {
    return UserUpdateRequest(
        id: json['id'] as String,
        name: json['name'] as String,
        password: json['password'] as String?,
        confirmPassword: json['confirm_password'] as String?,
        email: json['email'] as String?,
        role: json['role'] as String?,
        country: json['country'] as String?,
        language: json['language'] as String?,
        profilePictureUrl: json['profile_picture_url'] as String?);
  }

  /// Convert Model → JSON (for API request)
  Map<String, dynamic> toJson() => {
        "name": name,
        if (password != null) "password": password,
        if (confirmPassword != null) "confirm_password": confirmPassword,
        if (email != null) "email": email,
        if (role != null) "role": role,
        if (country != null) "country": country,
        if (language != null) "language": language,
      };

  /// Create a copy with modified fields
  UserUpdateRequest copyWith({
    String? id,
    String? name,
    String? password,
    String? confirmPassword,
    String? email,
    String? role,
    String? country,
    String? language,
  }) {
    return UserUpdateRequest(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      email: email ?? this.email,
      role: role ?? this.role,
      country: country ?? this.country,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [
        name,
        password,
        confirmPassword,
        email,
        role,
        country,
        language,
      ];
}
