import 'package:gigafaucet/features/affiliate_program/data/models/referral_link_response_model.dart';
import 'package:gigafaucet/features/affiliate_program/data/models/referral_stats_response_model.dart';
import 'package:gigafaucet/features/affiliate_program/data/models/referred_users_response_model.dart';
import 'package:gigafaucet/features/affiliate_program/data/models/request/referred_users_request.dart';

/// Remote data source interface for affiliate program
abstract class AffiliateProgramRemoteDataSource {
  /// Get referral link from the API
  Future<ReferralLinkResponseModel> getReferralLink();

  /// Get referred users list from the API
  Future<ReferredUsersResponseModel> getReferredUsers(
      ReferredUsersRequest request);

  /// Get referral stats from the API
  Future<ReferralStatsResponseModel> getReferralStats();
}
