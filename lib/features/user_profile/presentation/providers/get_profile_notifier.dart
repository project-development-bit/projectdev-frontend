import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/profile_detail.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import 'profile_providers.dart';

/// Status enum for profile fetching
enum GetProfileStatus {
  initial,
  loading,
  success,
  failure,
}

/// State for profile fetching
class GetProfileState {
  final GetProfileStatus status;
  final ProfileDetail? profile;
  final String? errorMessage;

  bool get isLoading => status == GetProfileStatus.loading;
  bool get hasData => profile != null;
  bool get hasError => status == GetProfileStatus.failure;

  GetProfileState({
    this.status = GetProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  GetProfileState copyWith({
    GetProfileStatus? status,
    ProfileDetail? profile,
    String? errorMessage,
  }) {
    return GetProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// State notifier for managing profile fetching
class GetProfileNotifier extends StateNotifier<GetProfileState> {
  final GetProfileUseCase _getProfileUseCase;

  GetProfileNotifier(this._getProfileUseCase) : super(GetProfileState());

  /// Fetch user profile
  Future<void> fetchProfile({bool isLoading = true}) async {
    if (state.status == GetProfileStatus.success) {
      return;
    }
    if (isLoading) {
      state = state.copyWith(
        status: GetProfileStatus.loading,
        errorMessage: null,
      );
    }

    final result = await _getProfileUseCase.call();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: GetProfileStatus.failure,
          errorMessage: failure.message ?? 'Failed to fetch profile',
        );
      },
      (profile) {
        state = state.copyWith(
          status: GetProfileStatus.success,
          profile: profile,
        );
      },
    );
  }

  /// Refresh profile (silent refresh without loading state)
  Future<void> refreshProfile() async {
    final result = await _getProfileUseCase.call();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: GetProfileStatus.failure,
          errorMessage: failure.message ?? 'Failed to refresh profile',
        );
      },
      (profile) {
        state = state.copyWith(
          status: GetProfileStatus.success,
          profile: profile,
        );
      },
    );
  }

  /// Reset to initial state
  void reset() {
    state = GetProfileState();
  }
}

/// Provider for get profile state notifier
final getProfileNotifierProvider =
    StateNotifierProvider<GetProfileNotifier, GetProfileState>((ref) {
  final useCase = ref.watch(getProfileUseCaseProvider);
  return GetProfileNotifier(useCase);
});
