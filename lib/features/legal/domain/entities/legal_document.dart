/// Legal document entity representing privacy policy, terms of service, etc.
class LegalDocument {
  final String id;
  final String title;
  final String content;
  final DateTime lastUpdated;
  final String version;
  final List<LegalSection> sections;

  const LegalDocument({
    required this.id,
    required this.title,
    required this.content,
    required this.lastUpdated,
    required this.version,
    required this.sections,
  });

  LegalDocument copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? lastUpdated,
    String? version,
    List<LegalSection>? sections,
  }) {
    return LegalDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      version: version ?? this.version,
      sections: sections ?? this.sections,
    );
  }
}

/// Legal document section
class LegalSection {
  final String id;
  final String title;
  final String content;
  final int order;
  final List<LegalSubsection>? subsections;

  const LegalSection({
    required this.id,
    required this.title,
    required this.content,
    required this.order,
    this.subsections,
  });

  LegalSection copyWith({
    String? id,
    String? title,
    String? content,
    int? order,
    List<LegalSubsection>? subsections,
  }) {
    return LegalSection(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      order: order ?? this.order,
      subsections: subsections ?? this.subsections,
    );
  }
}

/// Legal document subsection
class LegalSubsection {
  final String id;
  final String title;
  final String content;
  final int order;

  const LegalSubsection({
    required this.id,
    required this.title,
    required this.content,
    required this.order,
  });

  LegalSubsection copyWith({
    String? id,
    String? title,
    String? content,
    int? order,
  }) {
    return LegalSubsection(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      order: order ?? this.order,
    );
  }
}