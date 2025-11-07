import '../../domain/entities/contact_submission.dart';

/// Contact submission model for JSON serialization
class ContactSubmissionModel extends ContactSubmission {
  const ContactSubmissionModel({
    required super.name,
    required super.email,
    required super.subject,
    required super.message,
    required super.category,
    required super.createdAt,
    super.phone,
    super.userId,
  });

  factory ContactSubmissionModel.fromJson(Map<String, dynamic> json) {
    return ContactSubmissionModel(
      name: json['name'] as String,
      email: json['email'] as String,
      subject: json['subject'] as String,
      message: json['message'] as String,
      category: ContactCategory.values.firstWhere(
        (category) => category.value == json['category'],
        orElse: () => ContactCategory.general,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      phone: json['phone'] as String?,
      userId: json['userId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
      'category': category.value,
      'createdAt': createdAt.toIso8601String(),
      if (phone != null) 'phone': phone,
      if (userId != null) 'userId': userId,
    };
  }

  factory ContactSubmissionModel.fromEntity(ContactSubmission entity) {
    return ContactSubmissionModel(
      name: entity.name,
      email: entity.email,
      subject: entity.subject,
      message: entity.message,
      category: entity.category,
      createdAt: entity.createdAt,
      phone: entity.phone,
      userId: entity.userId,
    );
  }
}
