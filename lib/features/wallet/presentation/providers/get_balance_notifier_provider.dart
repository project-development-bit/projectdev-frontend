import 'package:cointiply_app/features/wallet/domain/usecases/get_user_balance_usecase.dart';
import 'package:cointiply_app/features/wallet/presentation/providers/balance_state.dart';
import 'package:cointiply_app/features/wallet/presentation/providers/get_balance_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getBalanceNotifierProvider =
    StateNotifierProvider<GetBalanceNotifier, BalanceState>((ref) {
  final usecase = ref.read(getUserBalanceUseCaseProvider);
  return GetBalanceNotifier(usecase);
});
