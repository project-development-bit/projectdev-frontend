import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/language.dart';
import '../../domain/usecases/get_languages_usecase.dart';
import 'profile_providers.dart';

/// Status enum for languages fetching
enum GetLanguagesStatus {
  initial,
  loading,
  success,
  failure,
}

/// State for languages fetching
class GetLanguagesState {
  final GetLanguagesStatus status;
  final List<Language>? languages;
  final String? errorMessage;

  bool get isLoading => status == GetLanguagesStatus.loading;
  bool get hasData => languages != null && languages!.isNotEmpty;
  bool get hasError => status == GetLanguagesStatus.failure;

  GetLanguagesState({
    this.status = GetLanguagesStatus.initial,
    this.languages,
    this.errorMessage,
  });

  GetLanguagesState copyWith({
    GetLanguagesStatus? status,
    List<Language>? languages,
    String? errorMessage,
  }) {
    return GetLanguagesState(
      status: status ?? this.status,
      languages: languages ?? this.languages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// State notifier for managing languages fetching
class GetLanguagesNotifier extends StateNotifier<GetLanguagesState> {
  final GetLanguagesUseCase _getLanguagesUseCase;

  GetLanguagesNotifier(this._getLanguagesUseCase) : super(GetLanguagesState());

  /// Fetch languages list
  Future<void> fetchLanguages() async {
    state = state.copyWith(
      status: GetLanguagesStatus.loading,
      errorMessage: null,
    );

    final result = await _getLanguagesUseCase.call();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: GetLanguagesStatus.failure,
          errorMessage: failure.message ?? 'Failed to fetch languages',
        );
      },
      (languages) {
        state = state.copyWith(
          status: GetLanguagesStatus.success,
          languages: languages,
        );
      },
    );
  }

  /// Refresh languages list
  Future<void> refreshLanguages() async {
    final result = await _getLanguagesUseCase.call();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: GetLanguagesStatus.failure,
          errorMessage: failure.message ?? 'Failed to refresh languages',
        );
      },
      (languages) {
        state = state.copyWith(
          status: GetLanguagesStatus.success,
          languages: languages,
        );
      },
    );
  }

  /// Reset to initial state
  void reset() {
    state = GetLanguagesState();
  }
}

/// Provider for get languages notifier
final getLanguagesNotifierProvider =
    StateNotifierProvider<GetLanguagesNotifier, GetLanguagesState>(
  (ref) {
    final useCase = ref.watch(getLanguagesUseCaseProvider);
    return GetLanguagesNotifier(useCase);
  },
);
