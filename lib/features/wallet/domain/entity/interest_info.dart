import 'package:equatable/equatable.dart';

class InterestInfo extends Equatable {
  final bool interestEnabled;
  final double interestRate;
  final int minimumBalanceRequired;
  final bool isEligible;
  final String nextPayoutDate;

  const InterestInfo({
    required this.interestEnabled,
    required this.interestRate,
    required this.minimumBalanceRequired,
    required this.isEligible,
    required this.nextPayoutDate,
  });

  @override
  List<Object?> get props => [
        interestEnabled,
        interestRate,
        minimumBalanceRequired,
        isEligible,
        nextPayoutDate,
      ];
}
