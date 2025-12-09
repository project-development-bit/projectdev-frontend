import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/core/usecases/usecase.dart';
import 'package:cointiply_app/features/affiliate_program/data/models/request/referred_users_request.dart';
import 'package:cointiply_app/features/affiliate_program/domain/entities/referred_users_result.dart';
import 'package:cointiply_app/features/affiliate_program/domain/repositories/affiliate_program_repository.dart';
import 'package:dartz/dartz.dart';

/// Use case for getting referred users list
class GetReferredUsersUseCase
    implements UseCase<ReferredUsersResult, ReferredUsersRequest> {
  final AffiliateProgramRepository repository;

  GetReferredUsersUseCase(this.repository);

  @override
  Future<Either<Failure, ReferredUsersResult>> call(
      ReferredUsersRequest params) async {
    return await repository.getReferredUsers(params);
  }
}
