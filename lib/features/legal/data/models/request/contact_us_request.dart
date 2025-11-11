import 'package:cointiply_app/features/legal/domain/entities/contact_submission.dart';

class ContactUsRequest {
  final String name;
  final String email;
  final String subject;
  final String message;
  final String category;
  final String? phone;
  final String? turnstileToken;
  final String action;

  ContactUsRequest({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.category,
    this.phone,
    this.turnstileToken,
    this.action = "contact_us",
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'subject': subject,
      'message': message,
      'phone': phone,
      'email': email,
      'turnstileToken': turnstileToken,
      'action': action,
    };
  }

  ContactUsRequest copyWith({
    String? name,
    String? email,
    String? subject,
    String? message,
    String? category,
    String? phone,
    String? turnstileToken,
    String? action,
  }) {
    return ContactUsRequest(
      name: name ?? this.name,
      email: email ?? this.email,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      category: category ?? this.category,
      phone: phone ?? this.phone,
      turnstileToken: turnstileToken ?? this.turnstileToken,
      action: action ?? this.action,
    );
  }
}
