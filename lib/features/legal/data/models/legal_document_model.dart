import '../../domain/entities/legal_document.dart';

/// Legal document model for JSON serialization
class LegalDocumentModel extends LegalDocument {
  const LegalDocumentModel({
    required super.id,
    required super.title,
    required super.content,
    required super.lastUpdated,
    required super.version,
    required super.sections,
  });

  factory LegalDocumentModel.fromJson(Map<String, dynamic> json) {
    return LegalDocumentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      version: json['version'] as String,
      sections: (json['sections'] as List<dynamic>?)
              ?.map((section) => LegalSectionModel.fromJson(section as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'lastUpdated': lastUpdated.toIso8601String(),
      'version': version,
      'sections': sections.map((section) => (section as LegalSectionModel).toJson()).toList(),
    };
  }

  factory LegalDocumentModel.fromEntity(LegalDocument entity) {
    return LegalDocumentModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      lastUpdated: entity.lastUpdated,
      version: entity.version,
      sections: entity.sections,
    );
  }
}

/// Legal section model for JSON serialization
class LegalSectionModel extends LegalSection {
  const LegalSectionModel({
    required super.id,
    required super.title,
    required super.content,
    required super.order,
    super.subsections,
  });

  factory LegalSectionModel.fromJson(Map<String, dynamic> json) {
    return LegalSectionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      order: json['order'] as int,
      subsections: (json['subsections'] as List<dynamic>?)
          ?.map((subsection) => LegalSubsectionModel.fromJson(subsection as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'order': order,
      'subsections': subsections?.map((subsection) => (subsection as LegalSubsectionModel).toJson()).toList(),
    };
  }
}

/// Legal subsection model for JSON serialization
class LegalSubsectionModel extends LegalSubsection {
  const LegalSubsectionModel({
    required super.id,
    required super.title,
    required super.content,
    required super.order,
  });

  factory LegalSubsectionModel.fromJson(Map<String, dynamic> json) {
    return LegalSubsectionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'order': order,
    };
  }
}