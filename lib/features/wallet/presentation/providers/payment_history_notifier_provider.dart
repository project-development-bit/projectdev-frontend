import 'package:gigafaucet/features/wallet/domain/usecases/get_payment_history_usecase.dart';
import 'package:gigafaucet/features/wallet/presentation/providers/payment_history_notifier.dart';
import 'package:gigafaucet/features/wallet/presentation/providers/payment_history_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentHistoryNotifierProvider = StateNotifierProvider.autoDispose<
    PaymentHistoryNotifier, PaymentHistoryState>((ref) {
  final useCase = ref.read(getPaymentHistoryUseCaseProvider);
  return PaymentHistoryNotifier(useCase);
});
