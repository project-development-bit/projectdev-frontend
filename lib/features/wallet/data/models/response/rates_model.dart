import 'package:gigafaucet/features/wallet/domain/entity/rates.dart';

class RatesModel extends Rates {
  const RatesModel({
    required super.coinToUsd,
    super.btcUsdPrice,
    required super.ratesAvailable,
  });

  factory RatesModel.fromJson(Map<String, dynamic> json) {
    return RatesModel(
      coinToUsd: json['coinToUsd']?.toDouble() ?? 0.0,
      btcUsdPrice: json['btcUsdPrice']?.toDouble(),
      ratesAvailable: json['ratesAvailable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coinToUsd': coinToUsd,
      'btcUsdPrice': btcUsdPrice,
      'ratesAvailable': ratesAvailable,
    };
  }
}
