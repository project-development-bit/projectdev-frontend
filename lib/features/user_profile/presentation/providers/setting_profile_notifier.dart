import 'package:gigafaucet/features/user_profile/data/models/request/user_update_request.dart';
import 'package:gigafaucet/features/user_profile/domain/usecases/update_user_profile.dart';
import 'package:gigafaucet/features/user_profile/presentation/providers/profile_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SettingProfileStatus {
  initial,
  updating,
  success,
  failure,
}

class SettingProfileState {
  final bool notificationsEnabled;
  final bool showStatsEnabled;
  final bool anonymousInContests;
  final String language;
  final SettingProfileStatus status;
  final String? errorMessage;

  bool get isUpdating => status == SettingProfileStatus.updating;
  bool get hasError => status == SettingProfileStatus.failure;

  SettingProfileState({
    required this.notificationsEnabled,
    required this.showStatsEnabled,
    required this.anonymousInContests,
    required this.language,
    this.status = SettingProfileStatus.initial,
    this.errorMessage,
  });

  SettingProfileState copyWith({
    bool? notificationsEnabled,
    bool? showStatsEnabled,
    bool? anonymousInContests,
    String? language,
    SettingProfileStatus? status,
    String? errorMessage,
  }) {
    return SettingProfileState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      showStatsEnabled: showStatsEnabled ?? this.showStatsEnabled,
      anonymousInContests: anonymousInContests ?? this.anonymousInContests,
      language: language ?? this.language,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final settingProfileProvider =
    StateNotifierProvider<SettingProfileNotifier, SettingProfileState>(
  (ref) {
    final updateUserProfileUsecase =
        ref.watch(updateUserProfileUseCaseProvider);
    return SettingProfileNotifier(
      SettingProfileState(
        notificationsEnabled: true,
        showStatsEnabled: true,
        anonymousInContests: false,
        language: "",
      ),
      updateUserProfileUsecase,
    );
  },
);

class SettingProfileNotifier extends StateNotifier<SettingProfileState> {
  final UpdateUserProfileUsecase _updateUserProfile;

  SettingProfileNotifier(super.state, this._updateUserProfile);

  /// Initialize settings from profile data
  void initSettings({
    required bool notificationsEnabled,
    required bool showStatsEnabled,
    required bool anonymousInContests,
    required String language,
  }) {
    state = SettingProfileState(
      notificationsEnabled: notificationsEnabled,
      showStatsEnabled: showStatsEnabled,
      anonymousInContests: anonymousInContests,
      language: language,
    );
  }

  /// Generic method to update a single setting
  Future<void> _updateSetting({
    required String userId,
    required UserUpdateRequest request,
    required SettingProfileState Function() getUpdatedState,
  }) async {
    // Set updating status
    state = state.copyWith(
      status: SettingProfileStatus.updating,
      errorMessage: null,
    );

    final result = await _updateUserProfile(
      UpdateUserProfileParams(profile: request),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: SettingProfileStatus.failure,
          errorMessage: failure.message ?? 'Failed to update setting',
        );
      },
      (response) {
        // Successfully updated on server, now update local state
        state = getUpdatedState().copyWith(
          status: SettingProfileStatus.success,
        );
      },
    );
  }

  /// Toggle notifications setting
  Future<void> toggleNotifications({required String userId}) async {
    await _updateSetting(
      userId: userId,
      request: UserUpdateRequest(
        id: userId,
        notificationsEnabled: !state.notificationsEnabled,
      ),
      getUpdatedState: () => state.copyWith(
        notificationsEnabled: !state.notificationsEnabled,
      ),
    );
  }

  /// Toggle show stats setting
  Future<void> toggleShowStats({required String userId}) async {
    await _updateSetting(
      userId: userId,
      request: UserUpdateRequest(
        id: userId,
        showStatsEnabled: !state.showStatsEnabled,
      ),
      getUpdatedState: () => state.copyWith(
        showStatsEnabled: !state.showStatsEnabled,
      ),
    );
  }

  /// Toggle anonymous in contests setting
  Future<void> toggleAnonymousInContests({required String userId}) async {
    await _updateSetting(
      userId: userId,
      request: UserUpdateRequest(
        id: userId,
        anonymousInContests: !state.anonymousInContests,
      ),
      getUpdatedState: () => state.copyWith(
        anonymousInContests: !state.anonymousInContests,
      ),
    );
  }

  /// Reset status to initial (useful after showing success/error messages)
  void resetStatus() {
    state = state.copyWith(
      status: SettingProfileStatus.initial,
      errorMessage: null,
    );
  }
}
