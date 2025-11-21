import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/reward/data/datasource/reward_remote_datasource.dart';
import 'package:cointiply_app/features/reward/data/models/response/reward_response.dart';
import 'package:cointiply_app/features/reward/domain/repositories/reward_repository.dart';
import 'package:dartz/dartz.dart';

class RewardRepositoryImpl implements RewardRepository {
  final RewardRemoteDataSource _remote;

  RewardRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, RewardResponse>> getUserRewards() async {
    try {
      final result = await _remote.getUserRewards();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
