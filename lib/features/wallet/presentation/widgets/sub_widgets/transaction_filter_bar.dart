import 'package:cointiply_app/core/common/table/table_filter_dropdown.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/wallet/presentation/providers/payment_history_notifier_provider.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/sub_widgets/transaction_filter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class TransactionFilterBar extends ConsumerWidget {
  const TransactionFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(paymentHistoryNotifierProvider.notifier);
    final state = ref.watch(paymentHistoryNotifierProvider);

    final isMobile = context.isMobile;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22.5),
      width: double.infinity,
      child: LayoutBuilder(builder: (context, constraints) {
        const double spacing = 4;
        return Wrap(
          spacing: spacing,
          runSpacing: 12,
          alignment: context.screenWidth < 500
              ? WrapAlignment.start
              : WrapAlignment.end,
          children: [
            TableFilterDropdown(
              width: 165,
              selected: state.filterCurrency ?? "all",
              options: const ["all", "usdt", "coin", "btc"],
              onSelect: notifier.changeFilterCurrency,
              child: TransactionFilterButton(
                title:
                    "Currency: ${(state.filterCurrency ?? "all").toUpperCase()}",
              ),
            ),
            SizedBox(width: isMobile ? 6 : 10),
            TableFilterDropdown(
              width: 165,
              selected: state.filterStatus ?? "all",
              options: const ["all", "confirmed", "pending", "failed"],
              onSelect: notifier.changeStatus,
              child: TransactionFilterButton(
                title: "Type: ${(state.filterStatus ?? "all").toUpperCase()}",
              ),
            ),
            SizedBox(width: isMobile ? 6 : 10),
            GestureDetector(
              onTap: notifier.refresh,
              child: Container(
                width: 30,
                height: 40,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  "assets/images/icons/Refresh ccw.svg",
                  width: isMobile ? 16 : 24,
                  height: isMobile ? 16 : 24,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
