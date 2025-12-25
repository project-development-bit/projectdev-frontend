import 'package:gigafaucet/features/wallet/domain/entity/withdrawal_option.dart';

enum GetWithdrawalOptionStatus {
  initial,
  loading,
  data,
  error,
}

class WithdrawalOptionState {
  final List<WithdrawalOption> withdrawalOptions;
  final GetWithdrawalOptionStatus status;
  final String? error;

  bool get isLoading => status == GetWithdrawalOptionStatus.loading;

  const WithdrawalOptionState({
    this.withdrawalOptions = const [],
    this.status = GetWithdrawalOptionStatus.initial,
    this.error,
  });

  WithdrawalOptionState copyWith({
    List<WithdrawalOption>? withdrawalOptions,
    GetWithdrawalOptionStatus? status,
    String? error,
  }) {
    return WithdrawalOptionState(
      withdrawalOptions: withdrawalOptions ?? this.withdrawalOptions,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
