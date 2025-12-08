import 'package:cointiply_app/core/common/table/table_footer.dart';
import 'package:flutter/material.dart';

class TransactionTableFooter extends StatelessWidget {
  const TransactionTableFooter(
      {super.key,
      required this.total,
      required this.page,
      required this.limit,
      required this.totalPages,
      required this.changePage,
      required this.changeLimit});
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final Function(int) changePage;
  final Function(int) changeLimit;

  @override
  Widget build(
    BuildContext context,
  ) {
    // final state = ref.watch(paymentHistoryNotifierProvider);
    // final notifier = ref.read(paymentHistoryNotifierProvider.notifier);
    // final total = state.pagination?.total ?? 0;
    // final page = state.pagination?.currentPage ?? 1;
    // final limit = state.pagination?.limit ?? 10;
    // final totalPages = (total / limit).ceil() == 0 ? 1 : (total / limit).ceil();

    return TableFooter(
      total: total,
      page: page,
      limit: limit,
      totalPages: totalPages,
      // changePage: (int page) {
      //   notifier.changePage(page);
      // },
      // changeLimit: (int limit) {
      //   notifier.changeLimit(limit);
      // },
      changePage: changePage,
      changeLimit: changeLimit,
    );
  }
}
