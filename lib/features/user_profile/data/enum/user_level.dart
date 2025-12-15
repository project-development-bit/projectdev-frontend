import 'package:cointiply_app/core/config/app_local_images.dart';
import 'package:cointiply_app/features/localization/data/helpers/app_localizations.dart';
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
        return const Color(0xFFEB681F); // Bronze
      case UserLevel.silver:
        return const Color(0xFFACB9BF); // Silver
      case UserLevel.gold:
        return const Color(0xFFF3A800); // Gold
      case UserLevel.diamond:
        return const Color(0xFF00A0DC); // Diamond
      case UserLevel.legend:
        return const Color(0xFF860400); // Legendary
    }
  }
}

extension UserLevelIcon on UserLevel {
  String get asset {
    switch (this) {
      case UserLevel.bronze:
        return AppLocalImages.bronze;
      case UserLevel.silver:
        return AppLocalImages.silver;
      case UserLevel.gold:
        return AppLocalImages.gold;
      case UserLevel.diamond:
        return AppLocalImages.diamond;
      case UserLevel.legend:
        return AppLocalImages.legend;
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
