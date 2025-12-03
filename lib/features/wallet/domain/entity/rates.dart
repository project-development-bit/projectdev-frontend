import 'package:equatable/equatable.dart';

class Rates extends Equatable {
  final double coinToUsd;
  final double? btcUsdPrice;
  final bool ratesAvailable;

  const Rates({
    required this.coinToUsd,
    this.btcUsdPrice,
    required this.ratesAvailable,
  });

  @override
  List<Object?> get props => [
        coinToUsd,
        btcUsdPrice,
        ratesAvailable,
      ];
}
