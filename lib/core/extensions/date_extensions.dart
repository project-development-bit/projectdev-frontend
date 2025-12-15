import 'package:cointiply_app/features/localization/data/helpers/app_localizations.dart';
import 'package:flutter/material.dart';

extension TimeAgoExtension on DateTime {
  String timeAgo(BuildContext context) {
    final now = DateTime.now();
    final diff = now.difference(this);
    final l10n = AppLocalizations.of(context);

    String t(String key, {int? count}) {
      final value = l10n
          ?.translate(key, args: [if (count != null) count.toString() else '']);
      return value ?? '';
    }

    if (diff.inMinutes < 1) {
      return t('time_just_now');
    } else if (diff.inMinutes < 60) {
      return t('time_min_ago', count: diff.inMinutes);
    } else if (diff.inHours < 24) {
      return t('time_hr_ago', count: diff.inHours);
    } else if (diff.inDays < 7) {
      return t('time_day_ago', count: diff.inDays);
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return t('time_week_ago', count: weeks);
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return t('time_month_ago', count: months);
    } else {
      final years = (diff.inDays / 365).floor();
      return t('time_year_ago', count: years);
    }
  }
}
