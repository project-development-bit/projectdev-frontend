import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/features/wallet/data/models/response/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionDesktopRow extends StatelessWidget {
  final TransactionModel item;

  const TransactionDesktopRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;

    final values = [
      item.description,
      item.status,
      item.amount,
      item.coins,
      item.currency,
      item.address,
      item.date
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
