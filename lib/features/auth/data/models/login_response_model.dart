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
    required super.user,
    required super.tokens,
  });

  /// Create LoginResponseModel from JSON response
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    
    return LoginResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
      tokens: AuthTokensModel.fromJson(data['tokens'] as Map<String, dynamic>),
    );
  }

  /// Convert to JSON for API requests (if needed)
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
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
    );
  }

  /// Convert to LoginResponse entity
  LoginResponse toEntity() {
    return LoginResponse(
      success: success,
      message: message,
      user: user,
      tokens: tokens,
    );
  }

  /// Create a copy with updated values (returns LoginResponseModel)
  LoginResponseModel copyWithModel({
    bool? success,
    String? message,
    UserModel? user,
    AuthTokensModel? tokens,
  }) {
    return LoginResponseModel(
      success: success ?? this.success,
      message: message ?? this.message,
      user: user ?? this.user as UserModel,
      tokens: tokens ?? this.tokens as AuthTokensModel,
    );
  }
}