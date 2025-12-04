import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/features/wallet/domain/entity/payment_history.dart';
import 'package:flutter/material.dart';

class TransactionDesktopRow extends StatelessWidget {
  final PaymentHistory item;

  const TransactionDesktopRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final values = [
      item.status.toString(),
      item.amount.toString(),
      item.currency,
      item.fee.toString(),
      item.address,
      item.updatedAt.toString(),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: values.map((e) {
          return Expanded(
            child: CommonText.bodySmall(
              e,
              color: const Color(0xFF808080), //TODO: use Color From Scheme
            ),
          );
        }).toList(),
      ),
    );
  }
}
