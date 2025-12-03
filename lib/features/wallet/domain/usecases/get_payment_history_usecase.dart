import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/core/usecases/usecase.dart';
import 'package:cointiply_app/features/wallet/data/repositories/payment_history_respoitory_provider.dart';
import 'package:cointiply_app/features/wallet/domain/entity/payment_history.dart';
import 'package:cointiply_app/features/wallet/domain/repositories/payment_history_respoitory.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getPaymentHistoryUseCaseProvider =
    Provider<GetPaymentHistoryUseCase>((ref) {
  final repository = ref.read(paymentHistoryRepositoryProvider);
  return GetPaymentHistoryUseCase(repository);
});

class GetPaymentHistoryUseCase
    implements UseCase<List<PaymentHistory>, NoParams> {
  final PaymentHistoryRespoitory repository;

  GetPaymentHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<PaymentHistory>>> call(NoParams params) {
    return repository.getPaymentHistory();
  }
}
