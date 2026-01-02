import '../enum/error_code.dart';

/// Model for API error responses
class ErrorModel {
  final String type;
  final int status;
  final String message;
  final ErrorCode? code;

  const ErrorModel({
    required this.type,
    required this.status,
    required this.message,
    this.code,
  });

  /// Create instance from JSON
  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      type: json['type'] as String? ?? 'error',
      status: json['status'] is int ? json['status'] as int : 500,
      message: json['message'] as String? ?? 'Unknown error',
      code: json['code'] != null && json['code'] is String
          ? ErrorCode.fromString(json['code'] as String)
          : null,
    );
  }

  /// Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'status': status,
      'message': message,
      'code': code?.value,
    };
  }

  /// Check if error is unverified account error
  bool get isUnverifiedAccount => code == ErrorCode.unverifiedAccount;

  @override
  String toString() {
    return 'ErrorModel(type: $type, status: $status, message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ErrorModel &&
        other.type == type &&
        other.status == status &&
        other.message == message &&
        other.code == code;
  }

  @override
  int get hashCode {
    return type.hashCode ^ status.hashCode ^ message.hashCode ^ code.hashCode;
  }
}
