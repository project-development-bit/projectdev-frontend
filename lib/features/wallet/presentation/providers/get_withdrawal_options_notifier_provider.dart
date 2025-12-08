import 'package:cointiply_app/features/wallet/domain/usecases/get_withdrawal_options_usecase.dart';
import 'package:cointiply_app/features/wallet/presentation/providers/get_withdrawal_options_notifier.dart';
import 'package:cointiply_app/features/wallet/presentation/providers/withdrawal_option_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getWithdrawalNotifierProvider =
    StateNotifierProvider<GetWithdrawalOptionNotifier, WithdrawalOptionState>(
        (ref) {
  final usecase = ref.read(getWithdrawalOptionsUseCaseProvider);
  return GetWithdrawalOptionNotifier(usecase);
});
