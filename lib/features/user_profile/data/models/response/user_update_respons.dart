/// User update response model
///
/// Contains the complete response from the user update API endpoint
class UserUpdateResponse {
  const UserUpdateResponse({
    required this.success,
    required this.message,
  });

  /// Whether the request was successful
  final bool success;

  /// Response message from server
  final String message;

  /// Create from JSON response
  factory UserUpdateResponse.fromJson(Map<String, dynamic> json) {
    return UserUpdateResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
    );
  }

  /// Convert to JSON (for testing/debugging)
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }

  @override
  String toString() =>
      'UserUpdateResponse(success: $success, message: $message)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserUpdateResponse &&
        other.success == success &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(success, message);
}
