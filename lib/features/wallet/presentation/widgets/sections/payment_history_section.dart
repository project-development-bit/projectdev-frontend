import 'package:cointiply_app/features/wallet/presentation/providers/payment_history_notifier_provider.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/sub_widgets/transactions_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PayamentHistorySection extends ConsumerStatefulWidget {
  const PayamentHistorySection({super.key});

  @override
  ConsumerState<PayamentHistorySection> createState() =>
      _PayamentHistorySectionState();
}

class _PayamentHistorySectionState
    extends ConsumerState<PayamentHistorySection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentHistoryNotifierProvider.notifier).fetchPaymentHistory();
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final items = ref.watch(paymentHistoryNotifierProvider).paymentHistory;
    return TransactionsTable(
      items: items,
    );
  }
}
