import 'package:cointiply_app/core/error/failures.dart';
import 'package:cointiply_app/features/reward/data/models/response/reward_data_model.dart';
import 'package:dartz/dartz.dart';

abstract class RewardRepository {
  Future<Either<Failure, RewardDataModel>> getUserRewards();
}
