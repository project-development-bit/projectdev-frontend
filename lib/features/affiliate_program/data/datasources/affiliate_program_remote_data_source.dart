import 'package:cointiply_app/features/affiliate_program/data/models/referral_link_response_model.dart';

/// Remote data source interface for affiliate program
abstract class AffiliateProgramRemoteDataSource {
  /// Get referral link from the API
  Future<ReferralLinkResponseModel> getReferralLink();
}
