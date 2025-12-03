import 'package:cointiply_app/features/wallet/data/models/response/transaction_model.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/sub_widgets/transaction_desktop_header.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/sub_widgets/transaction_desktop_row.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/sub_widgets/transaction_filter_bar.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/sub_widgets/transaction_table_footer.dart';
import 'package:flutter/material.dart';
import 'package:cointiply_app/core/core.dart';

class TransactionsTable extends StatelessWidget {
  final List<TransactionModel> items;

  const TransactionsTable({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        TransactionFilterBar(),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF00131E), // TODO: to use from scheme
            borderRadius: BorderRadius.circular(10),
          ),
          child: isMobile || isTablet
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: items.length * 150.0,
                    child: Column(
                      children: [
                        TransactionDesktopHeader(),
                        Divider(
                            color: const Color(
                                0xFF333333), // TODO: to use from scheme
                            height: 1),
                        ...items.map((e) => TransactionDesktopRow(item: e)),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    TransactionDesktopHeader(),
                    Divider(color: const Color(0xFF333333), height: 1),
                    ...items.map((e) => TransactionDesktopRow(item: e)),
                  ],
                ),
        ),
        const SizedBox(height: 12),
        // Table Footer (pagination)
        TransactionTableFooter(itemsCount: items.length),
      ],
    );
  }
}
