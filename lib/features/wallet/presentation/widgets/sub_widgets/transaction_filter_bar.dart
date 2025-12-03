import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/core/localization/app_localizations.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/sub_widgets/transaction_filter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TransactionFilterBar extends StatelessWidget {
  const TransactionFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isMobile = context.isMobile;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TransactionFilterButton(
          title: localizations?.translate("filter_currency") ??
              "Filter By Currency",
        ),
        SizedBox(width: isMobile ? 6 : 10),
        TransactionFilterButton(
          title: localizations?.translate("filter_type") ?? "Filter By Type",
        ),
        SizedBox(width: isMobile ? 6 : 8),
        SvgPicture.asset(
          "assets/images/icons/Refresh ccw.svg",
          width: isMobile ? 16 : 24,
          height: isMobile ? 16 : 24,
        )
      ],
    );
  }
}
