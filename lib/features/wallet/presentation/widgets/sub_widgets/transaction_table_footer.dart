import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class TransactionTableFooter extends StatelessWidget {
  final int itemsCount;

  const TransactionTableFooter({super.key, required this.itemsCount});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = context.isMobile;

    final pegination = Row(
      mainAxisAlignment:
          isMobile ? MainAxisAlignment.center : MainAxisAlignment.end,
      children: [
        Icon(Icons.chevron_left,
            color: const Color(0xFF98989A)), // TODO: use Color From Scheme
        const SizedBox(width: 6),
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: CommonText.bodyMedium(
            "1",
            color: colorScheme.surface,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 6),
        Icon(Icons.chevron_right,
            color: const Color(0xFF98989A)), // TODO: use Color From Scheme
      ],
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // PAGE SIZE DROPDOWN
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10.5),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color(
                            0xFF333333)), // TODO: use Color From Scheme
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      CommonText.bodyMedium("20",
                          fontWeight: FontWeight.w400,
                          color: const Color(
                              0xFF98989A)), // TODO: use Color From Scheme
                      const SizedBox(width: 6),
                      Icon(Icons.keyboard_arrow_down_rounded,
                          color: const Color(
                              0xFF98989A)), // TODO: use Color From Scheme
                    ],
                  ),
                ),
                SizedBox(width: 8),
                // SHOWING TEXT
                CommonText.bodyMedium(
                  fontWeight: FontWeight.w400,
                  "${localizations?.translate('showing') ?? 'Showing'} 1 to 0 of $itemsCount ${localizations?.translate('records') ?? 'records'}",
                  color: const Color(0xFF98989A), // TODO: use Color From Scheme
                ),
              ],
            ),

            // PAGINATION
            if (!isMobile) pegination
          ],
        ),
        if (isMobile)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: pegination,
          ),
      ],
    );
  }
}
