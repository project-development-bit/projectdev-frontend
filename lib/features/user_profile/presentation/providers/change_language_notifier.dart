import 'package:cointiply_app/core/providers/locale_provider.dart';
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
    final localeNotifier = ref.read(localeProvider.notifier);
    return ChangeLanguageNotifier(
      ChangeLanguageState(),
      updateUserProfileUsecase,
      localeNotifier,
    );
  },
);

class ChangeLanguageNotifier extends StateNotifier<ChangeLanguageState> {
  final UpdateUserProfileUsecase _updateUserProfile;
  final LocaleNotifier _localeNotifier;

  ChangeLanguageNotifier(
    super.state,
    this._updateUserProfile,
    this._localeNotifier,
  );

  /// Map language codes from API (EN, FR, MM) to locale language codes (en, fr, my)
  String _mapLanguageCodeToLocale(String languageCode) {
    switch (languageCode.toUpperCase()) {
      case 'EN':
        return 'en';
      case 'FR':
        return 'fr';
      case 'MM':
        return 'my';
      default:
        return 'en'; // Default to English
    }
  }

  /// Map language codes to country codes for Locale
  String _mapLanguageCodeToCountry(String languageCode) {
    switch (languageCode.toUpperCase()) {
      case 'EN':
        return 'US';
      case 'FR':
        return 'FR';
      case 'MM':
        return 'MM';
      default:
        return 'US'; // Default to US
    }
  }

  Future<void> changeLanguage({
    required String languageCode,
    required String languageName,
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
          final localeLanguageCode = _mapLanguageCodeToLocale(languageCode);
          final localeCountryCode = _mapLanguageCodeToCountry(languageCode);
          final newLocale = Locale(localeLanguageCode, localeCountryCode);

          await _localeNotifier.setLocale(newLocale);

          debugPrint('✅ Language changed to: $languageName ($languageCode)');
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
