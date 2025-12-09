/// Domain entity for referral link result
class ReferralLinkResult {
  const ReferralLinkResult({
    required this.message,
    required this.referralCode,
  });

  final String message;
  final String referralCode;
}
