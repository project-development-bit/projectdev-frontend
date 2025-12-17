import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/user_profile/data/models/request/user_update_request.dart';
import 'package:cointiply_app/features/user_profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ChangeLanguageStatus {
  initial,
  changing,
  success,
  failure,
}

class ChangeLanguageState {
  final ChangeLanguageStatus status;
  final String? errorMessage;

  bool get isChanging => status == ChangeLanguageStatus.changing;
  bool get hasError => status == ChangeLanguageStatus.failure;

  ChangeLanguageState({
    this.status = ChangeLanguageStatus.initial,
    this.errorMessage,
  });

  ChangeLanguageState copyWith({
    ChangeLanguageStatus? status,
    String? errorMessage,
  }) {
    return ChangeLanguageState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final changeLanguageProvider =
    StateNotifierProvider<ChangeLanguageNotifier, ChangeLanguageState>(
  (ref) {
    final updateUserProfileUsecase =
        ref.watch(updateUserProfileUseCaseProvider);
    return ChangeLanguageNotifier(
      ChangeLanguageState(),
      updateUserProfileUsecase,
      ref,
    );
  },
);

class ChangeLanguageNotifier extends StateNotifier<ChangeLanguageState> {
  final UpdateUserProfileUsecase _updateUserProfile;
  // final LocalizationController _localeNotifier;
  final Ref _ref;

  ChangeLanguageNotifier(
    super.state,
    this._updateUserProfile,
    this._ref,
    // this._localeNotifier,
  );

  /// Map language codes from API (EN, FR, MM) to locale language codes (en, fr, my)

  Future<void> changeLanguage({
    required String languageCode,
    required String countryName,
    required String userid,
  }) async {
    state = state.copyWith(
      status: ChangeLanguageStatus.changing,
      errorMessage: null,
    );

    try {
      // Update profile with language preference (you might need to add a language field to UserUpdateRequest)
      // For now, we'll just update the locale in the app
      // If you need to save this to the backend, uncomment and modify the following:

      final updatedProfile = UserUpdateRequest(
        language: languageCode,
        id: userid,
      );

      final result = await _updateUserProfile(
        UpdateUserProfileParams(profile: updatedProfile),
      );

      result.fold(
        (failure) {
          state = state.copyWith(
            status: ChangeLanguageStatus.failure,
            errorMessage: 'Failed to change language',
          );
          return;
        },
        (response) async {
          // Continue to update locale
          // Update app locale

          final newLocale = Locale(languageCode, countryName);

          // await _localeNotifier.changeLocale(newLocale);
          localizationService.changeLocale(newLocale, _ref);
          debugPrint('✅ Language changed to: $countryName ($languageCode)');
          debugPrint(
              '✅ Locale set to: ${newLocale.languageCode}-${newLocale.countryCode}');

          state = state.copyWith(status: ChangeLanguageStatus.success);
        },
      );
    } catch (e) {
      debugPrint('❌ Error changing language: $e');
      state = state.copyWith(
        status: ChangeLanguageStatus.failure,
        errorMessage: 'Failed to change language: $e',
      );
    }
  }
}
