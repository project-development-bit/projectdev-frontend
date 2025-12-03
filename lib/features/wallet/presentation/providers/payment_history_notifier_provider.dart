import 'package:cointiply_app/features/wallet/domain/usecases/get_payment_history_usecase.dart';
import 'package:cointiply_app/features/wallet/presentation/providers/payment_history_notifier.dart';
import 'package:cointiply_app/features/wallet/presentation/providers/payment_history_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentHistoryNotifierProvider =
    StateNotifierProvider<PaymentHistoryNotifier, PaymentHistoryState>((ref) {
  final useCase = ref.read(getPaymentHistoryUseCaseProvider);
  return PaymentHistoryNotifier(useCase);
});
