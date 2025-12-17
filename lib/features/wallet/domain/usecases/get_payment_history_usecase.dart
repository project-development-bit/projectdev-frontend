import 'package:gigafaucet/core/error/failures.dart';
import 'package:gigafaucet/core/usecases/usecase.dart';
import 'package:gigafaucet/features/wallet/data/models/request/payment_history_request.dart';
import 'package:gigafaucet/features/wallet/data/repositories/payment_history_respoitory_provider.dart';
import 'package:gigafaucet/features/wallet/data/repositories/payment_history_response_model.dart';
import 'package:gigafaucet/features/wallet/domain/repositories/payment_history_respoitory.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getPaymentHistoryUseCaseProvider =
    Provider<GetPaymentHistoryUseCase>((ref) {
  final repository = ref.read(paymentHistoryRepositoryProvider);
  return GetPaymentHistoryUseCase(repository);
});

class GetPaymentHistoryUseCase
    implements UseCase<PaymentHistoryResponseModel, PaymentHistoryRequest> {
  final PaymentHistoryRespoitory repository;

  GetPaymentHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentHistoryResponseModel>> call(
      PaymentHistoryRequest params) {
    return repository.getPaymentHistory(params);
  }
}
