/// Set Security Pin Response Model
///
/// Represents the response from `POST /users/security-pin`
class SetSecurityPinResponseModel {
  const SetSecurityPinResponseModel({
    required this.success,
    required this.message,
    required this.securityPinEnabled,
  });

  final bool success;
  final String message;
  final bool securityPinEnabled;

  factory SetSecurityPinResponseModel.fromJson(Map<String, dynamic> json) {
    return SetSecurityPinResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      securityPinEnabled: (json['data'] as Map<String, dynamic>?)?['security_pin_enabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        'security_pin_enabled': securityPinEnabled,
      },
    };
  }
}
