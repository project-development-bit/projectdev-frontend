import 'package:equatable/equatable.dart';

/// Request model for resending verification code
class ResendCodeRequest extends Equatable {
  /// User's email address
  final String email;

  /// Creates a new [ResendCodeRequest]
  const ResendCodeRequest({
    required this.email,
  });

  /// Creates a [ResendCodeRequest] from JSON
  factory ResendCodeRequest.fromJson(Map<String, dynamic> json) {
    return ResendCodeRequest(
      email: json['email'] as String,
    );
  }

  /// Converts [ResendCodeRequest] to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }

  @override
  List<Object?> get props => [email];
}
