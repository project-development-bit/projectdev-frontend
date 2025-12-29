/// Set Security Pin Response Model
///
/// Represents the response from `POST /users/security-pin`
class VerifySecurityPinResponseModel {
  const VerifySecurityPinResponseModel({
    required this.success,
    required this.message,
    required this.verified,
  });

  final bool success;
  final String message;
  final bool verified;

  factory VerifySecurityPinResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifySecurityPinResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      verified: (json['data'] as Map<String, dynamic>?)?['verified'] as bool? ??
          false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        'verified': verified,
      },
    };
  }
}
