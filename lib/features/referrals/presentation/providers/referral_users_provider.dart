import 'package:cointiply_app/features/referrals/data/datasources/referral_user_remote_service.dart';
import 'package:cointiply_app/features/referrals/data/repositories/referral_user_repository_impl.dart';
import 'package:cointiply_app/features/referrals/domain/entity/referred_user_entity.dart';
import 'package:cointiply_app/features/referrals/domain/repository/referral_users_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/base_dio_client.dart';
import '../../../../core/error/failures.dart';

/// Repository Provider
final referralUsersRepositoryProvider =
    Provider<ReferralUsersRepository>((ref) {
  final dioClient = ref.read(dioClientProvider);
  final remote = ReferralUsersRemoteService(dioClient);
  return ReferralUsersRepositoryImpl(remote);
});

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
  final ReferralUsersRepository _repository;

  ReferralUsersNotifier(this._repository) : super(const ReferralUsersInitial());

  Future<void> fetchReferralUsers() async {
    if (state is ReferralUsersLoading) return;

    state = const ReferralUsersLoading();
    debugPrint('🔄 ReferralUsersNotifier: Loading...');

    final result = await _repository.getReferredUsers();
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
  final repository = ref.read(referralUsersRepositoryProvider);
  return ReferralUsersNotifier(repository);
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
