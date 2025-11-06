import 'package:cointiply_app/features/referrals/data/datasources/referral_banner_remote_service.dart';
import 'package:cointiply_app/features/referrals/domain/entity/banner_entity.dart';
import 'package:cointiply_app/features/referrals/domain/repository/referral_banner_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/base_dio_client.dart';
import '../../../../core/error/failures.dart';
import '../../data/repositories/referral_banner_repository_impl.dart';

/// ─────────────────────────────────────────────────────────────
/// REPOSITORY PROVIDER
/// ─────────────────────────────────────────────────────────────
final referralBannerRepositoryProvider =
    Provider<ReferralBannerRepository>((ref) {
  final dioClient = ref.read(dioClientProvider);
  final remote = ReferralBannerRemoteService(dioClient);
  return ReferralBannerRepositoryImpl(remote);
});

/// ─────────────────────────────────────────────────────────────
/// STATE CLASSES
/// ─────────────────────────────────────────────────────────────
@immutable
sealed class ReferralBannerState {
  const ReferralBannerState();
}

class ReferralBannerInitial extends ReferralBannerState {
  const ReferralBannerInitial();
}

class ReferralBannerLoading extends ReferralBannerState {
  const ReferralBannerLoading();
}

class ReferralBannerSuccess extends ReferralBannerState {
  final List<RefferalBannerEntity> banners;

  const ReferralBannerSuccess(this.banners);
}

class ReferralBannerError extends ReferralBannerState {
  final String message;
  final int? statusCode;

  const ReferralBannerError({
    required this.message,
    this.statusCode,
  });
}

/// ─────────────────────────────────────────────────────────────
/// STATE NOTIFIER
/// ─────────────────────────────────────────────────────────────
class ReferralBannerNotifier extends StateNotifier<ReferralBannerState> {
  final ReferralBannerRepository _repository;

  ReferralBannerNotifier(this._repository)
      : super(const ReferralBannerInitial());

  /// Fetch referral banners from the repository
  Future<void> fetchReferralBanners() async {
    if (state is ReferralBannerLoading) return; // Prevent duplicate requests

    state = const ReferralBannerLoading();
    debugPrint('🔄 ReferralBannerNotifier: Fetching referral banners...');

    final result = await _repository.getReferralBanners();

    result.fold(
      (failure) {
        debugPrint('❌ ReferralBannerNotifier: Failed - ${failure.message}');
        int? statusCode;
        if (failure is ServerFailure) {
          statusCode = failure.statusCode;
        }

        state = ReferralBannerError(
          message: failure.message ?? 'Failed to load referral banners',
          statusCode: statusCode,
        );
      },
      (banners) {
        debugPrint('✅ ReferralBannerNotifier: Success');
        debugPrint('🖼️ Total Banners: ${banners.length}');

        if (banners.isNotEmpty) {
          for (final banner in banners) {
            debugPrint(
                '➡️ ${banner.imageUrl} (${banner.width}x${banner.height}, ${banner.format})');
          }
          state = ReferralBannerSuccess(banners);
        } else {
          debugPrint('⚠️ ReferralBannerNotifier: No banners found');
          state = const ReferralBannerError(
            message: 'No referral banners available',
            statusCode: 204,
          );
        }
      },
    );
  }

  /// Reset to initial state
  void reset() => state = const ReferralBannerInitial();

  /// Check if data available
  bool get hasData => state is ReferralBannerSuccess;

  /// Get current list (if available)
  List<RefferalBannerEntity>? get currentBanners {
    final currentState = state;
    return currentState is ReferralBannerSuccess ? currentState.banners : null;
  }
}

/// ─────────────────────────────────────────────────────────────
/// PROVIDERS
/// ─────────────────────────────────────────────────────────────
final referralBannerNotifierProvider =
    StateNotifierProvider<ReferralBannerNotifier, ReferralBannerState>((ref) {
  final repository = ref.read(referralBannerRepositoryProvider);
  return ReferralBannerNotifier(repository);
});

/// Provides list of banners directly
final referralBannersProvider = Provider<List<RefferalBannerEntity>>((ref) {
  final state = ref.watch(referralBannerNotifierProvider);
  return state is ReferralBannerSuccess ? state.banners : [];
});

/// Loading indicator provider
final isReferralBannerLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(referralBannerNotifierProvider);
  return state is ReferralBannerLoading;
});

/// Error message provider
final referralBannerErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(referralBannerNotifierProvider);
  return state is ReferralBannerError ? state.message : null;
});
