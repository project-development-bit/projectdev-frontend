import 'package:gigafaucet/core/extensions/context_extensions.dart';
import 'package:gigafaucet/features/wallet/presentation/providers/payment_history_notifier_provider.dart';
import 'package:gigafaucet/features/wallet/presentation/widgets/sub_widgets/transactions_table.dart';
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
    return Container(
        padding: EdgeInsets.symmetric(horizontal: context.isMobile ? 9.5 : 31),
        child: PayamentHistoryTable());
  }
}
