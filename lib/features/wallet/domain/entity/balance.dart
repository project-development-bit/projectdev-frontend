import 'package:gigafaucet/features/wallet/domain/entity/balance_meta_info.dart';
import 'package:gigafaucet/features/wallet/domain/entity/interest_info.dart';
import 'package:equatable/equatable.dart';

class BalanceResponse extends Equatable {
  final int coinBalance;
  final double? usdBalance;
  final double? btcBalance;
  final double? interestEarned;
  final double? coinsToday;
  final double coinsLast7Days;
  final InterestInfo interestInfo;
  final BalanceMetaInfo metaInfo;

  const BalanceResponse({
    required this.coinBalance,
    this.usdBalance,
    this.btcBalance,
    this.interestEarned,
    this.coinsToday,
    required this.coinsLast7Days,
    required this.interestInfo,
    required this.metaInfo,
  });

  @override
  List<Object?> get props => [
        coinBalance,
        usdBalance,
        btcBalance,
        interestEarned,
        coinsToday,
        coinsLast7Days,
        interestInfo,
        metaInfo,
      ];
}
