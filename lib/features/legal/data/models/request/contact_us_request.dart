import 'package:cointiply_app/features/legal/domain/entities/contact_submission.dart';

class ContactUsRequest {
  final String name;
  final String email;
  final String subject;
  final String message;
  final ContactCategory category;
  final String? phone;
  final String? turnstileToken;

  ContactUsRequest({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.category,
    this.phone,
    this.turnstileToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category.displayName,
      'subject': subject,
      'message': message,
      'phone': phone,
      'email': email,
      'turnstile_token': turnstileToken,
    };
  }

  ContactUsRequest copyWith({
    String? name,
    String? email,
    String? subject,
    String? message,
    ContactCategory? category,
    String? phone,
    String? turnstileToken,
  }) {
    return ContactUsRequest(
      name: name ?? this.name,
      email: email ?? this.email,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      category: category ?? this.category,
      phone: phone ?? this.phone,
      turnstileToken: turnstileToken ?? this.turnstileToken,
    );
  }
}
