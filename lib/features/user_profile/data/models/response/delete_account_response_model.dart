/// Response model for delete account API
class DeleteAccountResponseModel {
  final bool success;
  final String message;

  DeleteAccountResponseModel({
    required this.success,
    required this.message,
  });

  factory DeleteAccountResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteAccountResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? 'User has been deleted.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
