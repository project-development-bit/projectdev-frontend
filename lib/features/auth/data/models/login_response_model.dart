import '../../domain/entities/login_response.dart';
import 'user_model.dart';
import 'auth_tokens_model.dart';

/// LoginResponse model for data layer
///
/// Extends the LoginResponse entity with JSON serialization capabilities
class LoginResponseModel extends LoginResponse {
  const LoginResponseModel({
    required super.success,
    required super.message,
    super.user,
    super.tokens,
    super.userId,
  });

  /// Create LoginResponseModel from JSON response
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    // When 2FA is required, the response only contains success, message, and userId
    // without user and tokens data
    if (data == null || data['user'] == null || data['tokens'] == null) {
      // Return a minimal response with userId for 2FA verification
      return LoginResponseModel(
        success: json['success'] as bool,
        message: json['message'] as String,
        user: null,
        tokens: null,
        userId: json['userId'] as int?,
      );
    }

    return LoginResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
      tokens: AuthTokensModel.fromJson(data['tokens'] as Map<String, dynamic>),
      userId: data['userId'] as int?,
    );
  }

  /// Convert to JSON for API requests (if needed)
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'userId': userId,
      if (user != null && tokens != null)
        'data': {
          'user': (user as UserModel).toJson(),
          'tokens': (tokens as AuthTokensModel).toJson(),
        },
    };
  }

  /// Create LoginResponseModel from LoginResponse entity
  factory LoginResponseModel.fromEntity(LoginResponse loginResponse) {
    return LoginResponseModel(
      success: loginResponse.success,
      message: loginResponse.message,
      user: loginResponse.user,
      tokens: loginResponse.tokens,
      userId: loginResponse.userId,
    );
  }

  /// Convert to LoginResponse entity
  LoginResponse toEntity() {
    return LoginResponse(
      success: success,
      message: message,
      user: user,
      tokens: tokens,
      userId: userId,
    );
  }

  /// Create a copy with updated values (returns LoginResponseModel)
  LoginResponseModel copyWithModel({
    bool? success,
    String? message,
    UserModel? user,
    AuthTokensModel? tokens,
    int? userId,
  }) {
    return LoginResponseModel(
      success: success ?? this.success,
      message: message ?? this.message,
      user: user ?? (this.user != null ? this.user as UserModel : null),
      tokens: tokens ?? (this.tokens != null ? this.tokens as AuthTokensModel : null),
      userId: userId ?? this.userId,
    );
  }
}
