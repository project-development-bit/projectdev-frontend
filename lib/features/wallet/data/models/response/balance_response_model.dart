import 'package:gigafaucet/features/wallet/data/models/response/balance_meta_nfo_model.dart';
import 'package:gigafaucet/features/wallet/data/models/response/interest_info_model.dart';
import 'package:gigafaucet/features/wallet/domain/entity/balance.dart';

class BalanceResponseModel extends BalanceResponse {
  const BalanceResponseModel({
    required super.coinBalance,
    super.usdBalance,
    super.btcBalance,
    super.interestEarned,
    super.coinsToday,
    required super.coinsLast7Days,
    required super.interestInfo,
    required super.metaInfo,
  });

  factory BalanceResponseModel.fromJson(Map<String, dynamic> json) {
    return BalanceResponseModel(
      coinBalance: json['coinBalance'] ?? 0,
      usdBalance: json['usdBalance']?.toDouble(),
      btcBalance: json['btcBalance']?.toDouble(),
      interestEarned: json['interestEarned']?.toDouble(),
      coinsToday: json['coinsToday']?.toDouble(),
      coinsLast7Days: json['coinsLast7Days']?.toDouble() ?? 0.0,
      interestInfo: InterestInfoModel.fromJson(json['interestInfo']),
      metaInfo: MetaInfoModel.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coinBalance': coinBalance,
      'usdBalance': usdBalance,
      'btcBalance': btcBalance,
      'interestEarned': interestEarned,
      'coinsToday': coinsToday,
      'coinsLast7Days': coinsLast7Days,
      'interestInfo': (interestInfo as InterestInfoModel).toJson(),
      'meta': (metaInfo as MetaInfoModel).toJson(),
    };
  }
}
