import 'package:gigafaucet/features/faucet/domain/entity/actual_faucet_status.dart';

enum GetFaucetStatusState {
  initial,
  loading,
  data,
  error,
}

class FaucetState {
  final ActualFaucetStatus? status;
  final GetFaucetStatusState state;
  final String? error;

  const FaucetState({
    this.status,
    this.state = GetFaucetStatusState.initial,
    this.error,
  });

  FaucetState copyWith({
    ActualFaucetStatus? status,
    GetFaucetStatusState? state,
    String? error,
  }) {
    return FaucetState(
      status: status ?? this.status,
      state: state ?? this.state,
      error: error ?? this.error,
    );
  }

  bool get isLoading => state == GetFaucetStatusState.loading;
}
