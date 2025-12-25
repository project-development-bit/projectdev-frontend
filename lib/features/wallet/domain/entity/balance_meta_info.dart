import 'package:gigafaucet/features/wallet/domain/entity/rates.dart';
import 'package:equatable/equatable.dart';

class BalanceMetaInfo extends Equatable {
  final String asOf;
  final int windowDays;
  final int cacheTtlSec;
  final Rates rates;

  const BalanceMetaInfo({
    required this.asOf,
    required this.windowDays,
    required this.cacheTtlSec,
    required this.rates,
  });

  @override
  List<Object?> get props => [
        asOf,
        windowDays,
        cacheTtlSec,
        rates,
      ];
}
