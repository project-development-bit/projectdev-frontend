import 'package:gigafaucet/features/wallet/domain/entity/withdrawal_option.dart';

class WithdrawalOptionModel extends WithdrawalOption {
  const WithdrawalOptionModel({
    required super.code,
    required super.name,
    required super.iconUrl,
    required super.minAmountCoins,
    required super.feeCoins,
    required super.isAvailable,
    required super.network,
  });

  factory WithdrawalOptionModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalOptionModel(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      iconUrl: json['icon_url'] ?? '',
      minAmountCoins: json['min_amount_coins'] ?? 0,
      feeCoins: json['fee_coins'] ?? 0,
      isAvailable: json['is_available'] ?? false,
      network: json['network'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'icon_url': iconUrl,
      'min_amount_coins': minAmountCoins,
      'fee_coins': feeCoins,
      'is_available': isAvailable,
      'network': network,
    };
  }
}
