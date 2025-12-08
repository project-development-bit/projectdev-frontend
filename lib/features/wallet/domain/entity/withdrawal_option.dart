import 'package:equatable/equatable.dart';

class WithdrawalOption extends Equatable {
  final String code;
  final String name;
  final String iconUrl;
  final int minAmountCoins;
  final int feeCoins;
  final bool isAvailable;
  final String network;

  const WithdrawalOption({
    required this.code,
    required this.name,
    required this.iconUrl,
    required this.minAmountCoins,
    required this.feeCoins,
    required this.isAvailable,
    required this.network,
  });

  @override
  List<Object?> get props => [
        code,
        name,
        iconUrl,
        minAmountCoins,
        feeCoins,
        isAvailable,
        network,
      ];
}
