import 'package:cointiply_app/core/common/table/common_table_widget.dart';
import 'package:cointiply_app/core/common/table/models/table_column.dart';
import 'package:cointiply_app/features/localization/data/helpers/app_localizations.dart';
import 'package:cointiply_app/features/wallet/presentation/providers/payment_history_notifier_provider.dart';
import 'package:cointiply_app/features/wallet/presentation/providers/payment_history_state.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/sub_widgets/transaction_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PayamentHistoryTable extends ConsumerWidget {
  const PayamentHistoryTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final items = ref.watch(paymentHistoryNotifierProvider).paymentHistory;
    final state = ref.watch(paymentHistoryNotifierProvider);
    final notifier = ref.read(paymentHistoryNotifierProvider.notifier);
    final total = state.pagination?.total ?? 0;
    final page = state.pagination?.currentPage ?? 1;
    final limit = state.pagination?.limit ?? 10;
    final totalPages = (total / limit).ceil() == 0 ? 1 : (total / limit).ceil();

    final bool isloading = state.status == GetPaymentHistoryStatus.loading;
    return CommonTableWidget(
      columns: [
        TableColumn(
            header: localizations?.translate("tx_status") ?? "Status",
            width: 60),
        TableColumn(
            header: localizations?.translate("tx_amount") ?? "Amount",
            width: 60),
        TableColumn(
            header: localizations?.translate("tx_currency") ?? "Currency",
            width: 60),
        TableColumn(
            header: localizations?.translate("tx_fee") ?? "Fee", width: 60),
        TableColumn(
            header: localizations?.translate("tx_address") ?? "Address",
            width: 150),
        TableColumn(
            header: localizations?.translate("tx_date") ?? "Date", width: 150),
      ],
      filterBar: const TransactionFilterBar(),
      isLoading: isloading,
      values: isloading
          ? [
              ["", "", "", "", "", ""],
              ["", "", "", "", "", ""]
            ]
          : items
              .map((e) => [
                    e.status.toUpperCase().toString(),
                    e.amount.toString(),
                    e.currency,
                    e.fee.toString(),
                    e.address,
                    e.updatedAt.toString(),
                  ])
              .toList(),
      total: total,
      page: page,
      limit: limit,
      totalPages: totalPages,
      changePage: (int page) {
        notifier.changePage(page);
      },
      changeLimit: (int limit) {
        notifier.changeLimit(limit);
      },
    );
  }
}
