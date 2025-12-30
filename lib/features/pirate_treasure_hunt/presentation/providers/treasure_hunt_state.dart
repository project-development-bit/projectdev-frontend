enum TreasureHuntStatus {
  initial,
  loading,
  success,
  error,
}

class TreasureHuntState<T> {
  final TreasureHuntStatus status;
  final T? data;
  final String? error;

  const TreasureHuntState({
    this.status = TreasureHuntStatus.initial,
    this.data,
    this.error,
  });

  TreasureHuntState<T> copyWith({
    TreasureHuntStatus? status,
    T? data,
    String? error,
  }) {
    return TreasureHuntState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error,
    );
  }

  bool get isLoading => status == TreasureHuntStatus.loading;
}
