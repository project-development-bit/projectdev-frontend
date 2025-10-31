import 'package:equatable/equatable.dart';

class TermsPrivacyEntity extends Equatable {
  final String termsUrl;
  final String termsVersion;
  final String privacyUrl;
  final String privacyVersion;

  const TermsPrivacyEntity({
    required this.termsUrl,
    required this.termsVersion,
    required this.privacyUrl,
    required this.privacyVersion,
  });

  @override
  List<Object?> get props => [
        termsUrl,
        termsVersion,
        privacyUrl,
        privacyVersion,
      ];

  @override
  String toString() {
    return 'TermsPrivacyEntity(termsUrl: $termsUrl, termsVersion: $termsVersion, privacyUrl: $privacyUrl, privacyVersion: $privacyVersion)';
  }

  /// Check if URLs are valid
  bool get hasValidUrls {
    return termsUrl.isNotEmpty && 
           privacyUrl.isNotEmpty &&
           Uri.tryParse(termsUrl) != null &&
           Uri.tryParse(privacyUrl) != null;
  }

  /// Get terms URI
  Uri? get termsUri => Uri.tryParse(termsUrl);

  /// Get privacy URI  
  Uri? get privacyUri => Uri.tryParse(privacyUrl);
}