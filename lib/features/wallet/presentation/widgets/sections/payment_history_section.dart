import 'package:cointiply_app/features/wallet/presentation/providers/payment_history_notifier_provider.dart';
import 'package:cointiply_app/features/wallet/presentation/widgets/sub_widgets/transactions_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PayamentHistorySection extends ConsumerWidget {
  const PayamentHistorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(paymentHistoryNotifierProvider).paymentHistory;

    return TransactionsTable(
      items: items,
    );
  }
}
