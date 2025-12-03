import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/country.dart';
import '../../domain/usecases/get_countries_usecase.dart';
import 'profile_providers.dart';

/// Status enum for countries fetching
enum GetCountriesStatus {
  initial,
  loading,
  success,
  failure,
}

/// State for countries fetching
class GetCountriesState {
  final GetCountriesStatus status;
  final List<Country>? countries;
  final String? errorMessage;

  bool get isLoading => status == GetCountriesStatus.loading;
  bool get hasData => countries != null && countries!.isNotEmpty;
  bool get hasError => status == GetCountriesStatus.failure;

  GetCountriesState({
    this.status = GetCountriesStatus.initial,
    this.countries,
    this.errorMessage,
  });

  GetCountriesState copyWith({
    GetCountriesStatus? status,
    List<Country>? countries,
    String? errorMessage,
  }) {
    return GetCountriesState(
      status: status ?? this.status,
      countries: countries ?? this.countries,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// State notifier for managing countries fetching
class GetCountriesNotifier extends StateNotifier<GetCountriesState> {
  final GetCountriesUseCase _getCountriesUseCase;

  GetCountriesNotifier(this._getCountriesUseCase) : super(GetCountriesState());

  /// Fetch countries list
  Future<void> fetchCountries() async {
    state = state.copyWith(
      status: GetCountriesStatus.loading,
      errorMessage: null,
    );

    final result = await _getCountriesUseCase.call();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: GetCountriesStatus.failure,
          errorMessage: failure.message ?? 'Failed to fetch countries',
        );
      },
      (countries) {
        state = state.copyWith(
          status: GetCountriesStatus.success,
          countries: countries,
        );
      },
    );
  }

  /// Refresh countries list
  Future<void> refreshCountries() async {
    final result = await _getCountriesUseCase.call();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: GetCountriesStatus.failure,
          errorMessage: failure.message ?? 'Failed to refresh countries',
        );
      },
      (countries) {
        state = state.copyWith(
          status: GetCountriesStatus.success,
          countries: countries,
        );
      },
    );
  }

  /// Reset to initial state
  void reset() {
    state = GetCountriesState();
  }
}

/// Provider for get countries state notifier
final getCountriesNotifierProvider =
    StateNotifierProvider<GetCountriesNotifier, GetCountriesState>((ref) {
  final useCase = ref.watch(getCountriesUseCaseProvider);
  return GetCountriesNotifier(useCase);
});
