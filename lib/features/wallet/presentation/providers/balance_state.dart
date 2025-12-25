import 'package:gigafaucet/features/wallet/domain/entity/balance.dart';

enum GetBalanceStatus {
  initial,
  loading,
  data,
  error,
}

class BalanceState {
  final BalanceResponse? balance;
  final GetBalanceStatus status;
  final String? error;

  bool get isLoading => status == GetBalanceStatus.loading;

  const BalanceState({
    this.balance,
    this.status = GetBalanceStatus.initial,
    this.error,
  });

  BalanceState copyWith({
    BalanceResponse? balance,
    GetBalanceStatus? status,
    String? error,
  }) {
    return BalanceState(
      balance: balance ?? this.balance,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
