import 'package:cointiply_app/features/referrals/domain/entity/banner_entity.dart';
import 'package:cointiply_app/features/referrals/domain/usecases/get_referral_banners_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import 'package:flutter_riverpod/legacy.dart';

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
  final List<ReferalBannerEntity> banners;

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
  final GetReferralBannersUsecase _usecase;

  ReferralBannerNotifier(this._usecase) : super(const ReferralBannerInitial());

  /// Fetch referral banners from the repository
  Future<void> fetchReferralBanners() async {
    if (state is ReferralBannerLoading) return; // Prevent duplicate requests

    state = const ReferralBannerLoading();
    debugPrint('🔄 ReferralBannerNotifier: Fetching referral banners...');

    final result = await _usecase.call();

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
  List<ReferalBannerEntity>? get currentBanners {
    final currentState = state;
    return currentState is ReferralBannerSuccess ? currentState.banners : null;
  }
}

/// ─────────────────────────────────────────────────────────────
/// PROVIDERS
/// ─────────────────────────────────────────────────────────────
final referralBannerNotifierProvider =
    StateNotifierProvider<ReferralBannerNotifier, ReferralBannerState>((ref) {
  final usecase = ref.read(getReferralBannersUsecaseProvider);
  return ReferralBannerNotifier(usecase);
});

/// Provides list of banners directly
final referralBannersProvider = Provider<List<ReferalBannerEntity>>((ref) {
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
