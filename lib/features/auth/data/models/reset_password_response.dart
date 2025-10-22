import '../../domain/entities/login_response.dart';

/// Response model for reset password operation
/// 
/// Since the API returns the same structure as login response (with tokens),
/// we reuse the LoginResponse entity but provide a clear type alias
typedef ResetPasswordResponse = LoginResponse;

/// Extension to provide context-specific methods for reset password response
extension ResetPasswordResponseExtension on LoginResponse {
  /// Check if password reset was successful
  bool get isResetSuccessful => user.id > 0;
  
  /// Get the reset success message (if available)
  String get resetMessage => 'Password was saved successfully!';
  
  /// Get user information after successful reset
  String get userInfo => 'User: ${user.name} (${user.email})';
}