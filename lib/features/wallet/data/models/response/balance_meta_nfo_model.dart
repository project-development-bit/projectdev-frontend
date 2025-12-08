import 'package:cointiply_app/features/wallet/data/models/response/rates_model.dart';
import 'package:cointiply_app/features/wallet/domain/entity/balance_meta_info.dart';

class MetaInfoModel extends BalanceMetaInfo {
  const MetaInfoModel({
    required super.asOf,
    required super.windowDays,
    required super.cacheTtlSec,
    required super.rates,
  });

  factory MetaInfoModel.fromJson(Map<String, dynamic> json) {
    return MetaInfoModel(
      asOf: json['asOf'] ?? '',
      windowDays: json['windowDays'] ?? 0,
      cacheTtlSec: json['cacheTtlSec'] ?? 0,
      rates: RatesModel.fromJson(json['rates']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asOf': asOf,
      'windowDays': windowDays,
      'cacheTtlSec': cacheTtlSec,
      'rates': (rates as RatesModel).toJson(),
    };
  }
}
