import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/features/auth/domain/usecases/set_security_pin_usecase.dart';
import 'package:gigafaucet/features/auth/domain/usecases/verify_security_pin_usecase.dart';
import 'package:gigafaucet/features/auth/presentation/providers/auth_providers.dart';
import 'package:gigafaucet/features/auth/presentation/providers/security_pin/set_security_pin_notifier.dart';
import 'package:gigafaucet/features/auth/presentation/providers/security_pin/verify_security_pin_notifier.dart';

/// Provider for set security PIN use case
final setSecurityPinUseCaseProvider = Provider<SetSecurityPinUsecase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return SetSecurityPinUsecase(repository);
});

/// Provider for set security PIN notifier
final setSecurityPinNotifierProvider = StateNotifierProvider.autoDispose<
    SetSecurityPinNotifier, SetSecurityPinState>((ref) {
  final setSecurityPinUsecase = ref.read(setSecurityPinUseCaseProvider);
  return SetSecurityPinNotifier(setSecurityPinUsecase);
});

final verifySecurityPinUseCaseProvider =
    Provider<VerifySecurityPinUsecase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return VerifySecurityPinUsecase(repository);
});

/// Provider for verify security PIN notifier
final verifySecurityPinNotifierProvider = StateNotifierProvider.autoDispose<
    VerifySecurityPinNotifier, VerifySecurityPinState>((ref) {
  final verifySecurityPinUseCase = ref.read(verifySecurityPinUseCaseProvider);
  return VerifySecurityPinNotifier(verifySecurityPinUseCase);
});
