import 'dart:ui';

import 'package:cointiply_app/features/localization/domain/entities/localization_entity.dart';

enum LocalizationStatus {
  initial,
  loading,
  success,
  error,
}

class LocalizationState {
  final LocalizationEntity? localization;
  final LocalizationStatus status;
  final String? error;

  // final String currentLocale;
  final Locale currentLocale;

  const LocalizationState({
    this.localization,
    this.status = LocalizationStatus.initial,
    this.error,
    this.currentLocale = const Locale('en', 'US'),
  });

  LocalizationState copyWith({
    LocalizationEntity? localization,
    LocalizationStatus? status,
    String? error,
    Locale? currentLocale,
  }) {
    return LocalizationState(
      localization: localization ?? this.localization,
      status: status ?? this.status,
      error: error ?? this.error,
      currentLocale: currentLocale ?? this.currentLocale,
    );
  }
}
