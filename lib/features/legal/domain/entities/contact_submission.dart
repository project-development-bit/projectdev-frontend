/// Contact form submission entity
class ContactSubmission {
  final String name;
  final String email;
  final String subject;
  final String message;
  final ContactCategory category;
  final DateTime createdAt;
  final String? status;
  final String? phone;
  final String? userId;
  final String? turnstileToken;
  final String action;

  const ContactSubmission({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.category,
    required this.createdAt,
    this.status,
    this.phone,
    this.userId,
    this.turnstileToken,
    this.action = 'contact_us',
  });

  ContactSubmission copyWith({
    String? name,
    String? email,
    String? subject,
    String? message,
    ContactCategory? category,
    DateTime? createdAt,
    String? phone,
    String? userId,
    String? status,
    String? turnstileToken,
  }) {
    return ContactSubmission(
        name: name ?? this.name,
        email: email ?? this.email,
        subject: subject ?? this.subject,
        message: message ?? this.message,
        category: category ?? this.category,
        createdAt: createdAt ?? this.createdAt,
        phone: phone ?? this.phone,
        userId: userId ?? this.userId,
        status: status ?? this.status,
        turnstileToken: turnstileToken ?? this.turnstileToken);
  }
}

/// Contact category enum
enum ContactCategory {
  general('general'),
  technical('technical'),
  billing('billing'),
  feedback('feedback'),
  bug('bug'),
  feature('feature');

  const ContactCategory(this.value);
  final String value;

  String get displayName {
    switch (this) {
      case ContactCategory.general:
        return 'General Inquiry';
      case ContactCategory.technical:
        return 'Technical Support';
      case ContactCategory.billing:
        return 'Billing & Payments';
      case ContactCategory.feedback:
        return 'Feedback';
      case ContactCategory.bug:
        return 'Bug Report';
      case ContactCategory.feature:
        return 'Feature Request';
    }
  }
}
