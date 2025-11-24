import 'package:flutter_riverpod/flutter_riverpod.dart';


enum ChangeCountryStatus{
  initial,
  changing,
  success,
  failure,
}

class ChangeCountryState{
  final ChangeCountryStatus status;
  final String? errorMessage;

  bool get isChanging => status == ChangeCountryStatus.changing;
  bool get hasError => status == ChangeCountryStatus.failure;

  ChangeCountryState({
    this.status = ChangeCountryStatus.initial,
    this.errorMessage,
  });

  ChangeCountryState copyWith({
    ChangeCountryStatus? status,
    String? errorMessage,
  }) {
    return ChangeCountryState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ChangeCountryNotifier extends StateNotifier{
/// TODO: Implement change country logic
  ChangeCountryNotifier(super.state);
}