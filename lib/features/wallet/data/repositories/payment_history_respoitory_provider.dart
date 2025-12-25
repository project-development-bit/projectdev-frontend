import 'package:gigafaucet/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:gigafaucet/features/wallet/data/repositories/payment_history_respoitory_impl.dart';
import 'package:gigafaucet/features/wallet/domain/repositories/payment_history_respoitory.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentHistoryRepositoryProvider =
    Provider<PaymentHistoryRespoitory>((ref) {
  final remote = ref.read(walletRemoteDataSourceProvider);
  return PaymentHistoryRespoitoryImpl(remote);
});
