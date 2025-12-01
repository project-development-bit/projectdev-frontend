import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/base_dio_client.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/terms_privacy_remote.dart';
import '../../data/repositories/terms_privacy_repository_impl.dart';
import '../../domain/entities/terms_privacy_entity.dart';
import '../../domain/repositories/terms_privacy_repository.dart';
import 'package:flutter_riverpod/legacy.dart';

// Repository provider
final termsPrivacyRepositoryProvider = Provider<TermsPrivacyRepository>((ref) {
  final dioClient = ref.read(dioClientProvider);
  final remote = TermsPrivacyRemote(dioClient);
  return TermsPrivacyRepositoryImpl(remote);
});

// State classes for terms and privacy
@immutable
sealed class TermsPrivacyState {
  const TermsPrivacyState();
}

class TermsPrivacyInitial extends TermsPrivacyState {
  const TermsPrivacyInitial();
}

class TermsPrivacyLoading extends TermsPrivacyState {
  const TermsPrivacyLoading();
}

class TermsPrivacySuccess extends TermsPrivacyState {
  final TermsPrivacyEntity data;

  const TermsPrivacySuccess(this.data);
}

class TermsPrivacyError extends TermsPrivacyState {
  final String message;
  final int? statusCode;

  const TermsPrivacyError({
    required this.message,
    this.statusCode,
  });
}

// State notifier for terms and privacy
class TermsPrivacyNotifier extends StateNotifier<TermsPrivacyState> {
  final TermsPrivacyRepository _repository;

  TermsPrivacyNotifier(this._repository) : super(const TermsPrivacyInitial());

  /// Fetch terms and privacy data
  Future<void> fetchTermsAndPrivacy() async {
    if (state is TermsPrivacyLoading) return; // Prevent multiple calls

    state = const TermsPrivacyLoading();

    debugPrint('🔄 TermsPrivacyNotifier: Fetching terms and privacy...');

    final result = await _repository.getTermsAndPrivacy();

    result.fold(
      (failure) {
        debugPrint('❌ TermsPrivacyNotifier: Failed - ${failure.message}');

        int? statusCode;
        if (failure is ServerFailure) {
          statusCode = failure.statusCode;
        }

        state = TermsPrivacyError(
          message: failure.message ?? 'Failed to load terms and privacy',
          statusCode: statusCode,
        );
      },
      (entity) {
        debugPrint('✅ TermsPrivacyNotifier: Success');
        debugPrint('🔗 Terms URL: ${entity.termsUrl}');
        debugPrint('🔗 Privacy URL: ${entity.privacyUrl}');

        if (entity.hasValidUrls) {
          state = TermsPrivacySuccess(entity);
        } else {
          debugPrint('❌ TermsPrivacyNotifier: Invalid URLs received');
          state = const TermsPrivacyError(
            message: 'Invalid URLs received from server',
            statusCode: 422,
          );
        }
      },
    );
  }

  /// Reset state to initial
  void reset() {
    state = const TermsPrivacyInitial();
  }

  /// Check if data is available
  bool get hasData => state is TermsPrivacySuccess;

  /// Get current data (if available)
  TermsPrivacyEntity? get currentData {
    final currentState = state;
    return currentState is TermsPrivacySuccess ? currentState.data : null;
  }
}

// Provider for terms and privacy notifier
final termsPrivacyNotifierProvider =
    StateNotifierProvider<TermsPrivacyNotifier, TermsPrivacyState>((ref) {
  final repository = ref.read(termsPrivacyRepositoryProvider);
  return TermsPrivacyNotifier(repository);
});

// Convenience providers for specific data
final termsUrlProvider = Provider<String?>((ref) {
  final state = ref.watch(termsPrivacyNotifierProvider);
  return state is TermsPrivacySuccess ? state.data.termsUrl : null;
});

final privacyUrlProvider = Provider<String?>((ref) {
  final state = ref.watch(termsPrivacyNotifierProvider);
  return state is TermsPrivacySuccess ? state.data.privacyUrl : null;
});

// Provider for loading state
final isTermsPrivacyLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(termsPrivacyNotifierProvider);
  return state is TermsPrivacyLoading;
});
