import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/features/affiliate_program/domain/entities/referral_stats_result.dart';
import 'package:gigafaucet/features/affiliate_program/domain/usecases/get_referral_stats_usecase.dart';
import 'package:gigafaucet/features/affiliate_program/presentation/providers/referral_link_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for referral stats
class ReferralStatsState {
  final ReferralStatsStatus status;
  final ReferralStatsResult? data;
  final String? errorMessage;

  ReferralStatsState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  factory ReferralStatsState.initial() => ReferralStatsState(
        status: ReferralStatsStatus.initial,
      );

  factory ReferralStatsState.loading() => ReferralStatsState(
        status: ReferralStatsStatus.loading,
      );

  factory ReferralStatsState.success(ReferralStatsResult data) =>
      ReferralStatsState(
        status: ReferralStatsStatus.success,
        data: data,
      );

  factory ReferralStatsState.failure(String errorMessage) => ReferralStatsState(
        status: ReferralStatsStatus.failure,
        errorMessage: errorMessage,
      );

  ReferralStatsState copyWith({
    ReferralStatsStatus? status,
    ReferralStatsResult? data,
    String? errorMessage,
  }) {
    return ReferralStatsState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Status enum for referral stats
enum ReferralStatsStatus {
  initial,
  loading,
  success,
  failure,
}

/// Notifier for managing referral stats state
class ReferralStatsNotifier extends StateNotifier<ReferralStatsState> {
  final GetReferralStatsUseCase getReferralStatsUseCase;

  ReferralStatsNotifier({
    required this.getReferralStatsUseCase,
  }) : super(ReferralStatsState.initial());

  /// Fetch referral stats
  Future<void> fetchReferralStats() async {
    debugPrint('🔄 Fetching referral stats...');
    state = ReferralStatsState.loading();

    final result = await getReferralStatsUseCase();

    result.fold(
      (failure) {
        debugPrint('❌ Failed to fetch referral stats: ${failure.message}');
        String errorMessage = 'Failed to load referral stats';

        if (failure is ServerFailure) {
          errorMessage = failure.errorModel?.message ??
              failure.message ??
              'Failed to load referral stats';
        }

        state = ReferralStatsState.failure(errorMessage);
      },
      (data) {
        debugPrint('✅ Referral stats fetched successfully');
        state = ReferralStatsState.success(data);
      },
    );
  }

  /// Refresh referral stats
  Future<void> refreshReferralStats() async {
    debugPrint('🔄 Refreshing referral stats...');
    await fetchReferralStats();
  }
}

/// Use case provider
final getReferralStatsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(affiliateProgramRepositoryProvider);
  return GetReferralStatsUseCase(repository);
});

/// Referral stats provider
final referralStatsProvider = StateNotifierProvider.autoDispose<
    ReferralStatsNotifier, ReferralStatsState>((ref) {
  final useCase = ref.watch(getReferralStatsUseCaseProvider);
  return ReferralStatsNotifier(getReferralStatsUseCase: useCase);
});
