enum ClaimFaucetStatus {
  initial,
  loading,
  success,
  error,
}

class ClaimFaucetState {
  final ClaimFaucetStatus status;
  final String? error;

  const ClaimFaucetState({
    this.status = ClaimFaucetStatus.initial,
    this.error,
  });

  ClaimFaucetState copyWith({
    ClaimFaucetStatus? status,
    String? error,
  }) {
    return ClaimFaucetState(
      status: status ?? this.status,
      error: error,
    );
  }
}
