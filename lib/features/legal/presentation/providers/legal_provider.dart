import 'package:gigafaucet/features/legal/data/datasource/legal_remote_data_source.dart';
import 'package:gigafaucet/features/legal/data/models/request/contact_us_request.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/legal_document.dart';
import '../../domain/usecases/get_privacy_policy_usecase.dart';
import '../../domain/usecases/get_terms_of_service_usecase.dart';
import '../../domain/usecases/submit_contact_form_usecase.dart';
import '../../data/repositories/legal_repository_impl.dart';

// =============================================================================
// LEGAL STATE CLASSES
// =============================================================================

/// Base legal state
@immutable
sealed class LegalState {
  const LegalState();
}

/// Initial state
class LegalInitial extends LegalState {
  const LegalInitial();
}

/// Loading state
class LegalLoading extends LegalState {
  const LegalLoading();
}

/// Success state for legal document
class LegalDocumentLoaded extends LegalState {
  final LegalDocument document;

  const LegalDocumentLoaded(this.document);
}

/// Success state for contact form submission
class ContactFormSubmitted extends LegalState {
  const ContactFormSubmitted();
}

/// Error state
class LegalError extends LegalState {
  final String message;

  const LegalError(this.message);
}

// =============================================================================
// LEGAL NOTIFIER
// =============================================================================

/// Legal notifier for managing legal documents and contact forms
class LegalNotifier extends StateNotifier<LegalState> {
  LegalNotifier(this._ref) : super(const LegalInitial());

  final Ref _ref;

  /// Get privacy policy
  Future<void> getPrivacyPolicy() async {
    state = const LegalLoading();

    try {
      final useCase =
          GetPrivacyPolicyUseCase(_ref.read(legalRepositoryProvider));
      final result = await useCase.call();

      result.fold(
        (failure) => state =
            LegalError(failure.message ?? 'Failed to load privacy policy'),
        (document) => state = LegalDocumentLoaded(document),
      );
    } catch (e) {
      state = LegalError('An unexpected error occurred: $e');
    }
  }

  /// Get terms of service
  Future<void> getTermsOfService() async {
    state = const LegalLoading();

    try {
      final useCase =
          GetTermsOfServiceUseCase(_ref.read(legalRepositoryProvider));
      final result = await useCase.call();

      result.fold(
        (failure) => state =
            LegalError(failure.message ?? 'Failed to load terms of service'),
        (document) => state = LegalDocumentLoaded(document),
      );
    } catch (e) {
      state = LegalError('An unexpected error occurred: $e');
    }
  }

  /// Submit contact form
  Future<void> submitContactForm(ContactUsRequest submission) async {
    state = const LegalLoading();

    try {
      final useCase =
          SubmitContactFormUseCase(_ref.read(legalRepositoryProvider));
      final result = await useCase.call(submission);

      result.fold(
        (failure) {
          state =
              LegalError(failure.message ?? 'Failed to submit contact form');
          debugPrint(" Error submitting contact form: $failure");
        },
        (_) => state = const ContactFormSubmitted(),
      );
    } catch (e) {
      debugPrint(" Error submitting contact form: $e");
      state = LegalError('An unexpected error occurred: $e');
    }
  }

  /// Reset to initial state
  void resetState() {
    state = const LegalInitial();
  }
}

// =============================================================================
// PROVIDERS
// =============================================================================

/// Legal repository provider
final legalRepositoryProvider = Provider<LegalRepositoryImpl>((ref) {
  return LegalRepositoryImpl(ref.read(legalRemoteDataSourceProvider));
});

/// Legal notifier provider
final legalNotifierProvider =
    StateNotifierProvider<LegalNotifier, LegalState>((ref) {
  return LegalNotifier(ref);
});

/// Helper providers for checking state
final isLegalLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(legalNotifierProvider);
  return state is LegalLoading;
});

final legalErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(legalNotifierProvider);
  return state is LegalError ? state.message : null;
});

final currentLegalDocumentProvider = Provider<LegalDocument?>((ref) {
  final state = ref.watch(legalNotifierProvider);
  return state is LegalDocumentLoaded ? state.document : null;
});

final isContactFormSubmittedProvider = Provider<bool>((ref) {
  final state = ref.watch(legalNotifierProvider);
  return state is ContactFormSubmitted;
});
