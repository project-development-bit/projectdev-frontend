import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/affiliate_program/data/datasources/affiliate_program_remote_data_source_impl.dart';
import 'package:cointiply_app/features/affiliate_program/data/repositories/affiliate_program_repository_impl.dart';
import 'package:cointiply_app/features/affiliate_program/domain/repositories/affiliate_program_repository.dart';
import 'package:cointiply_app/features/affiliate_program/domain/usecases/get_referral_link_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cointiply_app/core/network/base_dio_client.dart';

// Status enum
enum ReferralLinkStatus { initial, loading, success, failure }

// State class
class ReferralLinkState {
  final ReferralLinkStatus status;
  final String? referralCode;
  final String? message;
  final String? errorMessage;

  bool get isLoading => status == ReferralLinkStatus.loading;
  bool get hasError => status == ReferralLinkStatus.failure;
  bool get isSuccess => status == ReferralLinkStatus.success;

  ReferralLinkState({
    this.status = ReferralLinkStatus.initial,
    this.referralCode,
    this.message,
    this.errorMessage,
  });

  ReferralLinkState copyWith({
    ReferralLinkStatus? status,
    String? referralCode,
    String? message,
    String? errorMessage,
  }) {
    return ReferralLinkState(
      status: status ?? this.status,
      referralCode: referralCode ?? this.referralCode,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Data source provider
final affiliateProgramRemoteDataSourceProvider = Provider((ref) {
  final dio = ref.watch(dioClientProvider);
  return AffiliateProgramRemoteDataSourceImpl(dioClient: dio);
});

// Repository provider
final affiliateProgramRepositoryProvider =
    Provider<AffiliateProgramRepository>((ref) {
  final remoteDataSource = ref.watch(affiliateProgramRemoteDataSourceProvider);
  return AffiliateProgramRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Use case provider
final getReferralLinkUseCaseProvider = Provider((ref) {
  final repository = ref.watch(affiliateProgramRepositoryProvider);
  return GetReferralLinkUseCase(repository);
});

// Notifier provider
final referralLinkProvider =
    StateNotifierProvider<ReferralLinkNotifier, ReferralLinkState>((ref) {
  final useCase = ref.watch(getReferralLinkUseCaseProvider);
  return ReferralLinkNotifier(ReferralLinkState(), useCase);
});

// Notifier class
class ReferralLinkNotifier extends StateNotifier<ReferralLinkState> {
  final GetReferralLinkUseCase _useCase;

  ReferralLinkNotifier(super.state, this._useCase);

  Future<void> getReferralLink() async {
    state = state.copyWith(
      status: ReferralLinkStatus.loading,
      errorMessage: null,
    );

    final result = await _useCase.call();

    result.fold(
      (failure) {
        debugPrint(
            '❌ ReferralLinkNotifier: Error getting referral link - Failure type: ${failure.runtimeType}');

        String errorMessage = 'Failed to get referral link';

        if (failure is ServerFailure) {
          debugPrint(
              '❌ ServerFailure - message: ${failure.message}, statusCode: ${failure.statusCode}');

          if (failure.errorModel?.message != null &&
              failure.errorModel!.message.isNotEmpty) {
            errorMessage = failure.errorModel!.message;
          } else if (failure.message != null && failure.message!.isNotEmpty) {
            errorMessage = failure.message!;
          }
        } else if (failure.message != null && failure.message!.isNotEmpty) {
          errorMessage = failure.message!;
        }

        debugPrint('❌ Final error message to show: $errorMessage');
        state = state.copyWith(
          status: ReferralLinkStatus.failure,
          errorMessage: errorMessage,
        );
      },
      (result) {
        debugPrint(
            '✅ Referral link retrieved successfully: ${result.referralCode}');
        state = state.copyWith(
          status: ReferralLinkStatus.success,
          referralCode: result.referralCode,
          message: result.message,
        );
      },
    );
  }
}
