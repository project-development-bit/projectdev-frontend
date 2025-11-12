import 'package:cointiply_app/core/error/error_handling.dart'
    show ErrorHandling;
import 'package:cointiply_app/features/legal/data/datasource/legal_remote_data_source.dart';
import 'package:cointiply_app/features/legal/data/models/request/contact_us_request.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/legal_document.dart';
import '../../domain/repositories/legal_repository.dart';
import '../models/response/legal_document_model.dart';

/// Repository implementation for legal documents and contact forms
class LegalRepositoryImpl implements LegalRepository {
  final LegalRemoteDataSource _remoteDataSource;
  LegalRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, LegalDocument>> getPrivacyPolicy() async {
    try {
      // Mock data - replace with actual API call
      final privacyPolicy = LegalDocumentModel(
        id: 'privacy-policy',
        title: 'Privacy Policy',
        content: '''
Gigafaucet Privacy Policy

Last updated: October 28, 2025

1. Information We Collect
We collect information you provide directly to us, such as when you create an account, make a transaction, or contact us for support.

2. How We Use Your Information
We use the information we collect to provide, maintain, and improve our services, process transactions, and communicate with you.

3. Information Sharing
We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this policy.

4. Data Security
We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.

5. Your Rights
You have the right to access, update, or delete your personal information. You can do this through your account settings or by contacting us.

6. Changes to This Policy
We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page.

7. Contact Us
If you have any questions about this privacy policy, please contact us at support@gigafaucet.com.
        ''',
        lastUpdated: DateTime.now(),
        version: '1.0',
        sections: [
          LegalSectionModel(
            id: 'information-collection',
            title: 'Information We Collect',
            content: 'We collect information you provide directly to us...',
            order: 1,
          ),
          LegalSectionModel(
            id: 'information-usage',
            title: 'How We Use Your Information',
            content:
                'We use the information we collect to provide, maintain, and improve our services...',
            order: 2,
          ),
          LegalSectionModel(
            id: 'information-sharing',
            title: 'Information Sharing',
            content:
                'We do not sell, trade, or otherwise transfer your personal information...',
            order: 3,
          ),
        ],
      );

      return Right(privacyPolicy);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LegalDocument>> getTermsOfService() async {
    try {
      // Mock data - replace with actual API call
      final termsOfService = LegalDocumentModel(
        id: 'terms-of-service',
        title: 'Terms of Service',
        content: '''
Gigafaucet Terms of Service

Last updated: October 28, 2025

1. Acceptance of Terms
By accessing and using Gigafaucet, you accept and agree to be bound by the terms and provision of this agreement.

2. Use License
Permission is granted to temporarily use Gigafaucet for personal, non-commercial transitory viewing only.

3. Disclaimer
The materials on Gigafaucet are provided on an 'as is' basis. Gigafaucet makes no warranties, expressed or implied.

4. Limitations
In no event shall Gigafaucet or its suppliers be liable for any damages arising out of the use or inability to use the materials.

5. Accuracy of Materials
The materials appearing on Gigafaucet could include technical, typographical, or photographic errors.

6. Links
Gigafaucet has not reviewed all of the sites linked to our website and is not responsible for the contents of any such linked site.

7. Modifications
Gigafaucet may revise these terms of service for its website at any time without notice.

8. Governing Law
These terms and conditions are governed by and construed in accordance with the laws of the jurisdiction.
        ''',
        lastUpdated: DateTime.now(),
        version: '1.0',
        sections: [
          LegalSectionModel(
            id: 'acceptance',
            title: 'Acceptance of Terms',
            content:
                'By accessing and using Gigafaucet, you accept and agree to be bound...',
            order: 1,
          ),
          LegalSectionModel(
            id: 'license',
            title: 'Use License',
            content: 'Permission is granted to temporarily use Gigafaucet...',
            order: 2,
          ),
          LegalSectionModel(
            id: 'disclaimer',
            title: 'Disclaimer',
            content:
                'The materials on Gigafaucet are provided on an as is basis...',
            order: 3,
          ),
        ],
      );

      return Right(termsOfService);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitContactForm(
      ContactUsRequest submission) async {
    try {
      await _remoteDataSource.submitContactForm(
        submission,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: ErrorHandling.getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, LegalDocument>> getLegalDocument(
      String documentType) async {
    try {
      switch (documentType.toLowerCase()) {
        case 'privacy':
        case 'privacy-policy':
          return await getPrivacyPolicy();
        case 'terms':
        case 'terms-of-service':
          return await getTermsOfService();
        default:
          return Left(
              ServerFailure(message: 'Unknown document type: $documentType'));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkDocumentUpdates() async {
    try {
      // Mock implementation - replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      return const Right(false); // No updates available
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
