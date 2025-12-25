import 'package:flutter/material.dart';
import 'package:gigafaucet/features/localization/data/helpers/app_localizations.dart';

extension LocalizationHelper on BuildContext {
  String translate(String key, {List<String>? args}) {
    return AppLocalizations.of(this)?.translate(key, args: args) ?? key;
  }
}
