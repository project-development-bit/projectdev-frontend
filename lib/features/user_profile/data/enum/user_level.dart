import 'package:cointiply_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

enum UserLevel {
  bronze,
  silver,
  gold,
  diamond,
  legend,
}

extension UserLevelColor on UserLevel {
  Color get color {
    switch (this) {
      case UserLevel.bronze:
        return const Color(0xFFCD7F32); // Bronze
      case UserLevel.silver:
        return const Color(0xFFC0C0C0); // Silver
      case UserLevel.gold:
        return const Color(0xFFFFD700); // Gold
      case UserLevel.diamond:
        return const Color(0xFF4DD0E1); // Diamond
      case UserLevel.legend:
        return const Color(0xFFB71C1C); // Legendary
    }
  }
}

extension UserLevelIcon on UserLevel {
  String get asset {
    switch (this) {
      case UserLevel.bronze:
        return "assets/images/rewards/bronze_level.png";
      case UserLevel.silver:
        return "assets/images/rewards/sliver.png";
      case UserLevel.gold:
        return "assets/images/rewards/gold.png";
      case UserLevel.diamond:
        return "assets/images/rewards/diamond.png";
      case UserLevel.legend:
        return "assets/images/rewards/legend.png";
    }
  }
}

extension UserLevelLabel on UserLevel {
  String lable(AppLocalizations? t, String tier) {
    switch (tier) {
      case "bronze":
        return t?.translate("status_bronze") ?? "Bronze";
      case "silver":
        return t?.translate("status_silver") ?? "Silver";
      case "gold":
        return t?.translate("status_gold") ?? "Gold";
      case "diamond":
        return t?.translate("status_diamond") ?? "Diamond";
      case "legend":
        return t?.translate("status_legend") ?? "Legend";
      default:
        return tier;
    }
  }
}

extension UserLevelParsing on String {
  UserLevel toUserLevel() {
    switch (toLowerCase().trim()) {
      case 'bronze':
        return UserLevel.bronze;
      case 'silver':
        return UserLevel.silver;
      case 'gold':
        return UserLevel.gold;
      case 'diamond':
        return UserLevel.diamond;
      case 'legend':
        return UserLevel.legend;
      default:
        throw ArgumentError('Invalid UserLevel: $this');
    }
  }
}
