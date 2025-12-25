import 'package:gigafaucet/features/localization/domain/usecases/get_localization_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gigafaucet/features/localization/presentation/providers/get_localization_notifier.dart';
import 'package:gigafaucet/features/localization/presentation/providers/localization_state.dart';

final localizationNotifierProvider =
    StateNotifierProvider<LocalizationController, LocalizationState>((ref) {
  final usecase = ref.read(getLocalizationUseCaseProvider);
  return LocalizationController(usecase, ref);
});
