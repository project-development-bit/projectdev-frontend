import 'package:gigafaucet/core/common/model/pagination_model.dart';
import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/features/affiliate_program/data/models/referred_user_model.dart';
import 'package:gigafaucet/features/affiliate_program/data/models/request/referred_users_request.dart';
import 'package:gigafaucet/features/affiliate_program/domain/usecases/get_referred_users_usecase.dart';
import 'package:gigafaucet/features/affiliate_program/presentation/providers/referral_link_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Status enum
enum ReferredUsersStatus { initial, loading, success, failure }

// State class
class ReferredUsersState {
  final ReferredUsersStatus status;
  final List<ReferredUserModel> users;
  final PaginationModel? pagination;
  final String? message;
  final String? errorMessage;
  final ReferredUsersRequest? currentRequest;

  bool get isLoading => status == ReferredUsersStatus.loading;
  bool get hasError => status == ReferredUsersStatus.failure;
  bool get isSuccess => status == ReferredUsersStatus.success;
  bool get isEmpty => users.isEmpty && status == ReferredUsersStatus.success;

  ReferredUsersState({
    this.status = ReferredUsersStatus.initial,
    this.users = const [],
    this.pagination,
    this.message,
    this.errorMessage,
    this.currentRequest,
  });

  ReferredUsersState copyWith({
    ReferredUsersStatus? status,
    List<ReferredUserModel>? users,
    PaginationModel? pagination,
    String? message,
    String? errorMessage,
    ReferredUsersRequest? currentRequest,
  }) {
    return ReferredUsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      pagination: pagination ?? this.pagination,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      currentRequest: currentRequest ?? this.currentRequest,
    );
  }
}

// Use case provider
final getReferredUsersUseCaseProvider = Provider((ref) {
  final repository = ref.watch(affiliateProgramRepositoryProvider);
  return GetReferredUsersUseCase(repository);
});

// Notifier provider
final referredUsersProvider =
    StateNotifierProvider<ReferredUsersNotifier, ReferredUsersState>((ref) {
  final useCase = ref.watch(getReferredUsersUseCaseProvider);
  return ReferredUsersNotifier(ReferredUsersState(), useCase);
});

// Notifier class
class ReferredUsersNotifier extends StateNotifier<ReferredUsersState> {
  final GetReferredUsersUseCase _useCase;

  ReferredUsersNotifier(super.state, this._useCase);

  Future<void> getReferredUsers(ReferredUsersRequest request) async {
    state = state.copyWith(
      status: ReferredUsersStatus.loading,
      errorMessage: null,
      currentRequest: request,
    );

    final result = await _useCase.call(request);

    result.fold(
      (failure) {
        debugPrint(
            '❌ ReferredUsersNotifier: Error getting referred users - Failure type: ${failure.runtimeType}');

        String errorMessage = 'Failed to get referred users';

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
          status: ReferredUsersStatus.failure,
          errorMessage: errorMessage,
        );
      },
      (result) {
        debugPrint(
            '✅ Referred users retrieved successfully: ${result.users.length} users');
        state = state.copyWith(
          status: ReferredUsersStatus.success,
          users: result.users,
          pagination: result.pagination,
          message: result.message,
        );
      },
    );
  }

  void changePage(int page) {
    if (state.currentRequest != null) {
      getReferredUsers(state.currentRequest!.copyWith(page: page));
    }
  }

  void changeLimit(int limit) {
    if (state.currentRequest != null) {
      getReferredUsers(state.currentRequest!.copyWith(limit: limit, page: 1));
    }
  }

  void refreshData() {
    if (state.currentRequest != null) {
      getReferredUsers(state.currentRequest!);
    }
  }

  void changeDate(DateTime date) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final dateTo = date.add(const Duration(days: 1));
    getReferredUsers(ReferredUsersRequest(
      page: 1,
      limit: 10,
      dateFrom: dateFormat.format(date),
      dateTo: dateFormat.format(dateTo),
    ));
  }

  void changeDateRange(DateTime startDate, DateTime endDate) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    getReferredUsers(ReferredUsersRequest(
      page: 1,
      limit: 10,
      dateFrom: dateFormat.format(startDate),
      dateTo: dateFormat.format(endDate),
    ));
  }

  void clearDateFilter() {
    if (state.currentRequest != null) {
      getReferredUsers(state.currentRequest!.copyWith(
        dateFrom: null,
        dateTo: null,
      ));
    }
  }
}
