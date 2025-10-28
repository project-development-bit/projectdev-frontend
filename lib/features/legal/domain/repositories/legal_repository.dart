import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/legal_document.dart';
import '../entities/contact_submission.dart';

/// Repository interface for legal documents and contact forms
abstract class LegalRepository {
  /// Get privacy policy document
  Future<Either<Failure, LegalDocument>> getPrivacyPolicy();

  /// Get terms of service document
  Future<Either<Failure, LegalDocument>> getTermsOfService();

  /// Submit contact form
  Future<Either<Failure, void>> submitContactForm(ContactSubmission submission);

  /// Get legal document by type
  Future<Either<Failure, LegalDocument>> getLegalDocument(String documentType);

  /// Check if legal documents need update
  Future<Either<Failure, bool>> checkDocumentUpdates();
}