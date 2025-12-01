import 'package:cointiply_app/features/referrals/domain/entity/referred_user_entity.dart';
import 'package:cointiply_app/features/referrals/domain/usecases/get_referred_users_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import 'package:flutter_riverpod/legacy.dart';

/// States
@immutable
sealed class ReferralUsersState {
  const ReferralUsersState();
}

class ReferralUsersInitial extends ReferralUsersState {
  const ReferralUsersInitial();
}

class ReferralUsersLoading extends ReferralUsersState {
  const ReferralUsersLoading();
}

class ReferralUsersSuccess extends ReferralUsersState {
  final List<ReferredUserEntity> users;
  const ReferralUsersSuccess(this.users);
}

class ReferralUsersError extends ReferralUsersState {
  final String message;
  final int? statusCode;
  const ReferralUsersError(this.message, {this.statusCode});
}

/// Notifier
class ReferralUsersNotifier extends StateNotifier<ReferralUsersState> {
  final GetReferredUsersUsecase _usecase;

  ReferralUsersNotifier(this._usecase) : super(const ReferralUsersInitial());

  Future<void> fetchReferralUsers() async {
    if (state is ReferralUsersLoading) return;

    state = const ReferralUsersLoading();
    debugPrint('🔄 ReferralUsersNotifier: Loading...');

    final result = await _usecase.call();
    result.fold(
      (failure) {
        debugPrint('❌ ReferralUsersNotifier: Failed - ${failure.message}');
        state = ReferralUsersError(
          failure.message ?? 'Failed to load referral users',
          statusCode: (failure as ServerFailure).statusCode,
        );
      },
      (users) {
        debugPrint('✅ ReferralUsersNotifier: Success (${users.length} users)');
        if (users.isEmpty) {
          state = const ReferralUsersError('No referred users found',
              statusCode: 204);
        } else {
          state = ReferralUsersSuccess(users);
        }
      },
    );
  }
}

/// Provider
final referralUsersNotifierProvider =
    StateNotifierProvider<ReferralUsersNotifier, ReferralUsersState>((ref) {
  final usecase = ref.read(getReferredUsersUsecaseProvider);
  return ReferralUsersNotifier(usecase);
});

/// Helpers
final isReferralUsersLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(referralUsersNotifierProvider);
  return state is ReferralUsersLoading;
});

final referralUsersListProvider = Provider<List<ReferredUserEntity>>((ref) {
  final state = ref.watch(referralUsersNotifierProvider);
  return state is ReferralUsersSuccess ? state.users : [];
});
